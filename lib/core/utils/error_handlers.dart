import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import '../errors/failures.dart';

class ErrorHandler {
  static String getErrorMessage(Failure failure) {
    if (failure is ServerFailure) {
      return failure.message;
    } else if (failure is NetworkFailure) {
      return 'Error de conexión. Por favor verifica tu conexión a internet e intenta nuevamente.';
    } else if (failure is AuthenticationFailure) {
      return 'Sesión expirada. Por favor inicia sesión nuevamente.';
    } else if (failure is ValidationFailure) {
      return _formatValidationErrors(failure.errors);
    } else if (failure is TimeoutFailure) {
      return 'Tiempo de espera agotado. Por favor intenta nuevamente.';
    } else if (failure is PermissionFailure) {
      return 'No tienes permisos para realizar esta acción.';
    } else {
      return 'Ha ocurrido un error inesperado. Por favor intenta más tarde.';
    }
  }

  static String _formatValidationErrors(Map<String, dynamic>? errors) {
    if (errors == null || errors.isEmpty) {
      return 'Error de validación';
    }

    // Handle different formats of validation errors
    final errorMessages = <String>[];
    
    errors.forEach((key, value) {
      if (value is List) {
        errorMessages.addAll(value.map((e) => e.toString()));
      } else if (value is Map) {
        errorMessages.addAll(
          value.entries.map((e) => '${e.key}: ${e.value}'),
        );
      } else {
        errorMessages.add(value.toString());
      }
    });

    return errorMessages.join('\n');
  }

  static void showErrorSnackBar(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 4),
  }) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: duration,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    }
  }

  static void showErrorDialog(
    BuildContext context, {
    required String title,
    required String message,
    String? buttonText,
    VoidCallback? onPressed,
  }) {
    if (context.mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: onPressed ?? () => Navigator.of(context).pop(),
              child: Text(buttonText ?? 'Aceptar'),
            ),
          ],
        ),
      );
    }
  }

  static void logError(dynamic error, StackTrace stackTrace, {String? tag}) {
    debugPrint('${tag != null ? '[$tag] ' : ''}Error: $error');
    debugPrint('Stack trace: $stackTrace');
    
    // In a real app, you'd want to log this to a crash reporting service
    if (kDebugMode) {
      debugPrintStack(stackTrace: stackTrace);
    }
  }
}
