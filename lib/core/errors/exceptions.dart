import 'package:equatable/equatable.dart';

abstract class AppException extends Equatable implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  const AppException({
    required this.message,
    this.statusCode,
    this.data,
  });

  @override
  List<Object?> get props => [message, statusCode, data];

  @override
  String toString() => message;
}

// 400
class BadRequestException extends AppException {
  const BadRequestException({
    String message = 'Solicitud incorrecta',
    int? statusCode,
    dynamic data,
  }) : super(
          message: message,
          statusCode: statusCode,
          data: data,
        );
}

// 401
class UnauthorizedException extends AppException {
  const UnauthorizedException({
    String message = 'No autorizado',
    int? statusCode,
    dynamic data,
  }) : super(
          message: message,
          statusCode: statusCode,
          data: data,
        );
}

// 403
class ForbiddenException extends AppException {
  const ForbiddenException({
    String message = 'Acceso denegado',
    int? statusCode,
    dynamic data,
  }) : super(
          message: message,
          statusCode: statusCode,
          data: data,
        );
}

// 404
class NotFoundException extends AppException {
  const NotFoundException({
    String message = 'Recurso no encontrado',
    int? statusCode,
    dynamic data,
  }) : super(
          message: message,
          statusCode: statusCode,
          data: data,
        );
}

// 422
class ValidationException extends AppException {
  final Map<String, dynamic>? errors;

  const ValidationException({
    String message = 'Error de validación',
    int? statusCode,
    this.errors,
    dynamic data,
  }) : super(
          message: message,
          statusCode: statusCode,
          data: data,
        );

  @override
  List<Object?> get props => [message, statusCode, errors, data];
}

// 500
class ServerException extends AppException {
  const ServerException({
    String message = 'Error en el servidor',
    int? statusCode,
    dynamic data,
  }) : super(
          message: message,
          statusCode: statusCode,
          data: data,
        );
}

// No Internet
class NoInternetException extends AppException {
  const NoInternetException({
    String message = 'No hay conexión a internet',
    int? statusCode,
    dynamic data,
  }) : super(
          message: message,
          statusCode: statusCode,
          data: data,
        );
}

// Timeout
class TimeoutException extends AppException {
  const TimeoutException({
    String message = 'Tiempo de espera agotado',
    int? statusCode,
    dynamic data,
  }) : super(
          message: message,
          statusCode: statusCode,
          data: data,
        );
}
