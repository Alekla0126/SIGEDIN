import 'package:http/http.dart' as http;

class AppException implements Exception {
  final String message;
  final int? statusCode;
  final http.Response? response;

  const AppException({
    required this.message,
    this.statusCode,
    this.response,
  });

  @override
  String toString() => message;
}

class ServerException extends AppException {
  ServerException({
    String message = 'Error de servidor',
    int? statusCode,
    http.Response? response,
  }) : super(
          message: message,
          statusCode: statusCode,
          response: response,
        );
}

class CacheException extends AppException {
  const CacheException({String message = 'Error de caché'})
      : super(message: message);
}

class NetworkException extends AppException {
  const NetworkException({String message = 'Error de red'})
      : super(message: message);
}

class UnauthorizedException extends AppException {
  const UnauthorizedException({String message = 'No autorizado'})
      : super(message: message, statusCode: 401);
}

class NotFoundException extends AppException {
  const NotFoundException({String message = 'Recurso no encontrado'})
      : super(message: message, statusCode: 404);
}

class TimeoutException extends AppException {
  const TimeoutException({String message = 'Tiempo de espera agotado'})
      : super(message: message);
}

class FileNotFoundException extends AppException {
  const FileNotFoundException({String message = 'Archivo no encontrado'})
      : super(message: message);
}

class ValidationException extends AppException {
  final Map<String, dynamic>? errors;

  const ValidationException({
    String message = 'Error de validación',
    this.errors,
  }) : super(message: message, statusCode: 422);

  @override
  String toString() {
    if (errors != null) {
      return '$message: $errors';
    }
    return message;
  }
}
