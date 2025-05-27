import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final int? statusCode;
  final dynamic data;

  const Failure({
    required this.message,
    this.statusCode,
    this.data,
  });

  @override
  List<Object?> get props => [message, statusCode, data];

  @override
  String toString() => 'Failure(message: $message, statusCode: $statusCode, data: $data)';
}

// Server failures
class ServerFailure extends Failure {
  const ServerFailure({
    String message = 'Error en el servidor',
    int? statusCode,
    dynamic data,
  }) : super(
          message: message,
          statusCode: statusCode,
          data: data,
        );
}

// Cache failures
class CacheFailure extends Failure {
  const CacheFailure({
    String message = 'Error de caché',
    int? statusCode,
    dynamic data,
  }) : super(
          message: message,
          statusCode: statusCode,
          data: data,
        );
}

// Network failures
class NetworkFailure extends Failure {
  const NetworkFailure({
    String message = 'Error de red',
    int? statusCode,
    dynamic data,
  }) : super(
          message: message,
          statusCode: statusCode,
          data: data,
        );
}

// Validation failures
class ValidationFailure extends Failure {
  final Map<String, dynamic>? errors;

  const ValidationFailure({
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

// Authentication failures
class AuthenticationFailure extends Failure {
  const AuthenticationFailure({
    String message = 'Error de autenticación',
    int? statusCode,
    dynamic data,
  }) : super(
          message: message,
          statusCode: statusCode,
          data: data,
        );
}

// Permission failures
class PermissionFailure extends Failure {
  const PermissionFailure({
    String message = 'Permiso denegado',
    int? statusCode,
    dynamic data,
  }) : super(
          message: message,
          statusCode: statusCode,
          data: data,
        );
}

// Timeout failures
class TimeoutFailure extends Failure {
  const TimeoutFailure({
    String message = 'Tiempo de espera agotado',
    int? statusCode,
    dynamic data,
  }) : super(
          message: message,
          statusCode: statusCode,
          data: data,
        );
}

// Format failures
class FormatFailure extends Failure {
  const FormatFailure({
    String message = 'Error de formato',
    int? statusCode,
    dynamic data,
  }) : super(
          message: message,
          statusCode: statusCode,
          data: data,
        );
}
