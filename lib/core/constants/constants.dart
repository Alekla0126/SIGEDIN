class AppConstants {
  static const String apiBaseUrl = 'http://localhost:8000';
  static const String appName = 'SIGEDIN';
  
  // Shared Preferences Keys
  static const String authTokenKey = 'auth_token';
  static const String userDataKey = 'user_data';
  
  // API Endpoints
  static const String loginEndpoint = '/auth/login';
  static const String registerEndpoint = '/auth/register';
  static const String meEndpoint = '/auth/me';
  static const String forgotPasswordEndpoint = '/auth/forgot-password';
  static const String resetPasswordEndpoint = '/auth/reset-password';
  
  // Timeouts
  static const int receiveTimeout = 15000;
  static const int connectTimeout = 15000;
  
  // Pagination
  static const int defaultPageSize = 10;
  static const int defaultPage = 1;
  
  // Error Messages
  static const String serverError = 'Error en el servidor';
  static const String noInternetError = 'No hay conexión a internet';
  static const String unauthorizedError = 'No autorizado';
  static const String notFoundError = 'Recurso no encontrado';
  static const String timeoutError = 'Tiempo de espera agotado';
  static const String unexpectedError = 'Error inesperado';
}
