import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dartz/dartz.dart';
import '../config/env_config.dart';
import '../errors/exceptions.dart';
import '../errors/failures.dart';

String _getMimeType(String fileName) {
  final ext = p.extension(fileName).toLowerCase();
  switch (ext) {
    case '.pdf':
      return 'application/pdf';
    case '.doc':
      return 'application/msword';
    case '.docx':
      return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
    case '.xls':
      return 'application/vnd.ms-excel';
    case '.xlsx':
      return 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
    case '.jpg':
    case '.jpeg':
      return 'image/jpeg';
    case '.png':
      return 'image/png';
    case '.txt':
      return 'text/plain';
    default:
      return 'application/octet-stream';
  }
}

class ApiClient {
  final http.Client client;
  final SharedPreferences prefs;
  final String baseUrl;

  ApiClient({
    required this.client,
    required this.prefs,
    String? baseUrl,
  }) : baseUrl = baseUrl ?? EnvConfig.baseUrl;

  Future<Either<Failure, T>> downloadFile<T>(
    String path,
    File file, {
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await client.get(
        Uri.parse('$baseUrl$path'),
        headers: await _headers,
      ).timeout(
        const Duration(seconds: 60),
        onTimeout: () => throw TimeoutException(
          message: 'Download timed out',
        ),
      );

      if (response.statusCode >= 400) {
        throw ServerException(
          message: 'Failed to download file: ${response.reasonPhrase}',
          statusCode: response.statusCode,
        );
      }

      await file.writeAsBytes(response.bodyBytes);
      
      if (fromJson != null) {
        return Right(fromJson(response.body));
      }
      // Return a default value of type T when no fromJson is provided
      // This is a workaround since we can't return null for a non-nullable type
      if (null is T) {
        return Right(null as T);
      }
      throw Exception('Cannot return null for non-nullable type $T');
    } on AppException catch (e) {
      return Left(_mapExceptionToFailure(e));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  Future<Map<String, String>> get _headers async {
    final token = prefs.getString('auth_token');
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<Either<Failure, T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParams,
    T Function(dynamic)? fromJson,
  }) async {
    final uri = Uri.parse('$baseUrl$path').replace(queryParameters: queryParams);
    final headers = await _headers;

    // Debug print for the request
    print('-----------------------------------------------------------');
    print('REQUEST (GET): $uri');
    print('HEADERS: $headers');
    if (queryParams != null) {
      print('QUERY PARAMS: $queryParams');
    }
    print('-----------------------------------------------------------');

    try {
      final response = await client.get(uri, headers: headers).timeout(
        const Duration(seconds: 30),
        onTimeout: () => throw TimeoutException(),
      );

      // Debug print for the response
      print('-----------------------------------------------------------');
      print('RESPONSE (GET): $uri');
      print('STATUS CODE: ${response.statusCode}');
      print('HEADERS: ${response.headers}');
      print('BODY: ${response.body}');
      print('-----------------------------------------------------------');

      return handleApiResponse<T>(
        response: response,
        onSuccess: (json) => fromJson != null ? fromJson(json) : json as T,
      );
    } on AppException catch (e) {
      return Left(_mapExceptionToFailure(e));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  Future<Either<Failure, T>> post<T>(
    String path, {
    dynamic body,
    T Function(dynamic)? fromJson,
    Map<String, String>? headers,
  }) async {
    try {
      final requestHeaders = await _headers;
      if (headers != null) {
        requestHeaders.addAll(headers);
      }

      // Format the body based on content type
      dynamic formattedBody;
      if (requestHeaders['Content-Type'] == 'application/x-www-form-urlencoded' && body is Map) {
        // Convert Map to urlencoded format for form data
        formattedBody = body.entries
            .map((e) => '${Uri.encodeComponent(e.key.toString())}=${Uri.encodeComponent(e.value.toString())}')
            .join('&');
      } else {
        // Use JSON for other requests
        formattedBody = body is Map || body is List ? jsonEncode(body) : body;
      }

      final response = await client.post(
        Uri.parse('$baseUrl$path'),
        headers: requestHeaders,
        body: formattedBody,
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () => throw TimeoutException(),
      );

      return handleApiResponse<T>(
        response: response,
        onSuccess: (json) => fromJson != null ? fromJson(json) : json as T,
      );
    } on AppException catch (e) {
      return Left(_mapExceptionToFailure(e));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  Future<Either<Failure, T>> multipartPost<T>({
    required String path,
    required Map<String, dynamic> fields,
    required Map<String, String> files,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final requestHeaders = await _headers;
      final uri = Uri.parse('$baseUrl$path');
      
      // Create multipart request
      var request = http.MultipartRequest('POST', uri);
      
      // Add headers
      request.headers.addAll({
        'Accept': 'application/json',
        if (requestHeaders['Authorization'] != null)
          'Authorization': requestHeaders['Authorization']!,
      });
      
      // Add fields
      fields.forEach((key, value) {
        if (value != null) {
          request.fields[key] = value.toString();
        }
      });
      
      // Add files
      for (var entry in files.entries) {
        final filePath = entry.value;
        final fileName = p.basename(filePath);
        final mimeType = _getMimeType(fileName);
        
        final file = File(filePath);
        final fileStream = http.ByteStream(file.openRead());
        final length = await file.length();
        
        final multipartFile = http.MultipartFile(
          entry.key,
          fileStream,
          length,
          filename: fileName,
          contentType: MediaType.parse(mimeType),
        );
        
        request.files.add(multipartFile);
      }
      
      // Send the request
      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 60),
        onTimeout: () => throw TimeoutException(
          message: 'File upload timed out',
        ),
      );
      
      // Check if the request was successful
      if (streamedResponse.statusCode >= 400) {
        // Consume the stream to release resources, but we don't need the content
        await streamedResponse.stream.drain();
        throw ServerException(
          message: 'Failed to upload file: ${streamedResponse.reasonPhrase}',
          statusCode: streamedResponse.statusCode,
        );
      }
      
      // Convert the response to http.Response
      final response = await http.Response.fromStream(streamedResponse);
      
      return handleApiResponse<T>(
        response: response,
        onSuccess: (json) => fromJson != null ? fromJson(json) : json as T,
      );
    } on AppException catch (e) {
      return Left(_mapExceptionToFailure(e));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  Future<Either<Failure, T>> put<T>(
    String path, {
    dynamic body,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await client.put(
        Uri.parse('$baseUrl$path'),
        headers: await _headers,
        body: body is Map || body is List ? jsonEncode(body) : body,
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () => throw TimeoutException(),
      );

      return handleApiResponse<T>(
        response: response,
        onSuccess: (json) => fromJson != null ? fromJson(json) : json as T,
      );
    } on AppException catch (e) {
      return Left(_mapExceptionToFailure(e));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  Future<Either<Failure, T>> delete<T>(
    String path, {
    dynamic body,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final request = http.Request('DELETE', Uri.parse('$baseUrl$path'))
        ..headers.addAll(await _headers);
      
      if (body != null) {
        request.body = body is Map || body is List ? jsonEncode(body) : body.toString();
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      return handleApiResponse<T>(
        response: response,
        onSuccess: (json) => fromJson != null ? fromJson(json) : json as T,
      );
    } on AppException catch (e) {
      return Left(_mapExceptionToFailure(e));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  // Helper method to map exceptions to failures
  Failure _mapExceptionToFailure(AppException exception) {
    if (exception is ServerException) {
      return ServerFailure(
        message: exception.message,
        statusCode: exception.statusCode,
        data: exception.data,
      );
    } else if (exception is BadRequestException) {
      return ServerFailure(
        message: exception.message,
        statusCode: exception.statusCode,
        data: exception.data,
      );
    } else if (exception is UnauthorizedException) {
      return AuthenticationFailure(
        message: exception.message,
        statusCode: exception.statusCode,
        data: exception.data,
      );
    } else if (exception is ForbiddenException) {
      return PermissionFailure(
        message: exception.message,
        statusCode: exception.statusCode,
        data: exception.data,
      );
    } else if (exception is NotFoundException) {
      return ServerFailure(
        message: exception.message,
        statusCode: exception.statusCode,
        data: exception.data,
      );
    } else if (exception is ValidationException) {
      return ValidationFailure(
        message: exception.message,
        statusCode: exception.statusCode,
        errors: exception.errors,
        data: exception.data,
      );
    } else if (exception is TimeoutException) {
      return TimeoutFailure(
        message: exception.message,
        statusCode: exception.statusCode,
        data: exception.data,
      );
    } else {
      return ServerFailure(message: exception.message);
    }
  }
  
  Either<Failure, T> handleApiResponse<T>({
    required http.Response response,
    required T Function(dynamic) onSuccess,
  }) {
    final statusCode = response.statusCode;
    final responseBody = response.body;
    
    try {
      if (statusCode >= 200 && statusCode < 300) {
        if (responseBody.isEmpty) {
          return Right(onSuccess(null));
        }
        
        final json = jsonDecode(responseBody);
        return Right(onSuccess(json));
      } else if (statusCode == 401) {
        throw UnauthorizedException();
      } else if (statusCode == 404) {
        throw NotFoundException();
      } else if (statusCode >= 500) {
        throw ServerException(
          message: 'Server error',
          statusCode: statusCode,
        );
      } else {
        // Handle other 4xx errors
        String errorMessage = 'An error occurred';
        try {
          final errorJson = jsonDecode(responseBody);
          errorMessage = errorJson['message'] ?? errorJson['error'] ?? errorMessage;
        } catch (_) {
          errorMessage = responseBody;
        }
        throw ServerException(
          message: errorMessage,
          statusCode: statusCode,
        );
      }
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException(
        message: 'Failed to parse response: ${e.toString()}',
        statusCode: statusCode,
      );
    }
  }
}
