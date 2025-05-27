import 'package:flutter/material.dart';
import 'package:dartz/dartz.dart' hide State;

import '../../core/errors/failures.dart';
import 'error_handlers.dart';

typedef ApiCall<T> = Future<Either<Failure, T>> Function();
typedef OnSuccess<T> = void Function(T data);
typedef OnError = void Function(Failure failure);

class ApiRequestHandler<T> {
  static Future<void> makeRequest<T>({
    required BuildContext context,
    required ApiCall<T> apiCall,
    required OnSuccess<T> onSuccess,
    OnError? onError,
    bool showLoading = true,
    bool handleError = true,
    String? loadingMessage,
  }) async {
    try {
      if (showLoading && context.mounted) {
        _showLoadingDialog(context, loadingMessage);
      }

      final response = await apiCall();

      if (showLoading && context.mounted) {
        Navigator.of(context, rootNavigator: true).pop();
      }

      response.fold(
        (failure) {
          if (handleError) {
            _handleError(context, failure);
          }
          onError?.call(failure);
        },
        (data) => onSuccess(data),
      );
    } catch (e, stackTrace) {
      if (showLoading && context.mounted) {
        Navigator.of(context, rootNavigator: true).pop();
      }
      
      ErrorHandler.logError(e, stackTrace, tag: 'ApiRequestHandler');
      
      if (handleError && context.mounted) {
        ErrorHandler.showErrorSnackBar(
          context,
          message: 'Error inesperado. Por favor intente nuevamente.',
        );
      }
      
      onError?.call(ServerFailure(message: e.toString()));
    }
  }

  static void _showLoadingDialog(BuildContext context, String? message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(message ?? 'Cargando...'),
            ],
          ),
        ),
      ),
    );
  }

  static void _handleError(BuildContext context, Failure failure) {
    final errorMessage = ErrorHandler.getErrorMessage(failure);
    
    // For validation errors, show a dialog with the details
    if (failure is ValidationFailure && failure.errors != null) {
      ErrorHandler.showErrorDialog(
        context,
        title: 'Error de validación',
        message: errorMessage,
      );
    } 
    // For authentication errors, show a dialog and navigate to login
    else if (failure is AuthenticationFailure) {
      ErrorHandler.showErrorDialog(
        context,
        title: 'Sesión expirada',
        message: errorMessage,
        buttonText: 'Iniciar sesión',
        onPressed: () {
          Navigator.of(context).popUntil((route) => route.isFirst);
          // TODO: Navigate to login screen
        },
      );
    } 
    // For other errors, show a snackbar
    else {
      ErrorHandler.showErrorSnackBar(
        context,
        message: errorMessage,
      );
    }
  }
}


/// A mixin that provides common API request handling functionality for StatefulWidgets
///
/// Example:
/// ```dart
/// class _MyWidgetState extends State<MyWidget> with ApiRequestMixin<MyWidget> {
///   @override
///   Widget build(BuildContext context) {
///     return ElevatedButton(
///       onPressed: () => makeRequest(
///         () => someApiCall(),
///         onSuccess: (data) => print('Success: $data'),
///         onError: (failure) => print('Error: ${failure.message}'),
///       ),
///       child: isLoading ? CircularProgressIndicator() : Text('Make Request'),
///     );
///   }
/// }
/// ```
mixin ApiRequestMixin<T extends StatefulWidget> on State<T> {
  bool _isLoading = false;
  String? _errorMessage;

  /// Whether a request is currently in progress
  bool get isLoading => _isLoading;
  
  /// The current error message, if any
  String? get errorMessage => _errorMessage;

  /// Makes an API request with loading and error handling
  ///
  /// [apiCall] - The function that makes the API call
  /// [onSuccess] - Callback when the request is successful
  /// [onError] - Optional callback for handling errors
  /// [showLoading] - Whether to show loading state
  /// [handleError] - Whether to handle errors automatically
  /// [loadingMessage] - Optional custom loading message
  Future<void> makeRequest<R>(
    Future<Either<Failure, R>> Function() apiCall, {
    required Function(R data) onSuccess,
    Function(Failure failure)? onError,
    bool showLoading = true,
    bool handleError = true,
    String? loadingMessage,
  }) async {
    if (mounted && showLoading) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    }

    try {
      final response = await apiCall();
      
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      
      response.fold(
        (failure) {
          final errorMessage = ErrorHandler.getErrorMessage(failure);
          if (mounted) {
            setState(() {
              _errorMessage = errorMessage;
            });
          }
          if (handleError && mounted) {
            ErrorHandler.showErrorSnackBar(
              context,
              message: errorMessage,
            );
          }
          onError?.call(failure);
        },
        (data) {
          if (mounted) {
            setState(() {
              _isLoading = false;
            });
          }
          onSuccess(data);
        },
      );
    } catch (e, stackTrace) {
      const errorMessage = 'Ha ocurrido un error inesperado. Por favor intente más tarde.';
      
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = errorMessage;
        });
      }
      
      ErrorHandler.logError(
        e,
        stackTrace,
        tag: 'ApiRequestMixin',
      );
      
      if (handleError && mounted) {
        ErrorHandler.showErrorSnackBar(
          context,
          message: errorMessage,
        );
      }
      
      onError?.call(ServerFailure(message: errorMessage));
    }
  }
}
