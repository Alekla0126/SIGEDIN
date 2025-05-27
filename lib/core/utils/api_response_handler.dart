import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';

Either<Failure, T> handleApiResponse<T>({
  required http.Response response,
  required T Function(dynamic) onSuccess,
}) {
  try {
    final responseJson = response.body.isNotEmpty 
        ? jsonDecode(utf8.decode(response.bodyBytes)) 
        : null;

    switch (response.statusCode) {
      case 200:
      case 201:
        return Right(onSuccess(responseJson));
      case 204:
        return Right(onSuccess(null));
      case 400:
        throw BadRequestException(
          message: responseJson?['message'] ?? 'Solicitud incorrecta',
          data: responseJson,
        );
      case 401:
        throw UnauthorizedException(
          message: responseJson?['message'] ?? 'No autorizado',
          data: responseJson,
        );
      case 403:
        throw ForbiddenException(
          message: responseJson?['message'] ?? 'Acceso denegado',
          data: responseJson,
        );
      case 404:
        throw NotFoundException(
          message: responseJson?['message'] ?? 'Recurso no encontrado',
          data: responseJson,
        );
      case 422:
        throw ValidationException(
          message: responseJson?['message'] ?? 'Error de validación',
          errors: responseJson?['errors'],
          data: responseJson,
        );
      case 500:
      default:
        throw ServerException(
          message: responseJson?['message'] ?? 'Error en el servidor',
          data: responseJson,
        );
    }
  } on AppException catch (e) {
    return Left(_mapExceptionToFailure(e));
  } catch (e) {
    return Left(ServerFailure(message: e.toString()));
  }
}

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

// Extension to handle Either responses in a more functional way
extension EitherExtension<L, R> on Either<L, R> {
  R? get right => fold((_) => null, (r) => r);
  L? get left => fold((l) => l, (_) => null);
  bool get isRight => this is Right<L, R>;
  bool get isLeft => this is Left<L, R>;
}
