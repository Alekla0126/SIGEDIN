import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv_package;

class EnvConfig {
  
  // Environment variables map with defaults
  static final Map<String, String> _env = {
    'ENV': 'development',
    'API_BASE_URL': 'http://localhost:8000',
    'API_KEY': '',
    // Add other default environment variables here
  };
  
  // Get base URL with fallbacks at every level
  static String get baseUrl {
    final env = _env['ENV'] ?? 'development';
    
    // In debug mode, allow overriding from loaded env file
    if (kDebugMode) {
      return _env['API_BASE_URL'] ?? 'http://10.0.2.2:8000';
    }
    
    // In release mode, use environment-specific URLs
    switch (env) {
      case 'staging':
        return 'https://staging.api.yourdomain.com';
      case 'production':
        return 'https://api.yourdomain.com';
      case 'development':
      default:
        return 'http://10.0.2.2:8000';
    }
  }
  
  // Safely get any environment variable
  static String? get(String key) {
    return _env[key];
  }
  
  static Future<void> load() async {
    try {
      // Try to load environment variables from .env file
      await dotenv_package.dotenv.load(fileName: ".env").timeout(
        Duration(seconds: 2),
        onTimeout: () {
          if (kDebugMode) {
            print('Timeout loading .env file, using default configuration');
          }
          return;
        },
      );
      
      // Copy all loaded variables to our safe map
      dotenv_package.dotenv.env.forEach((key, value) {
        _env[key] = value;
      });
      
      if (kDebugMode) {
        print('Environment variables loaded successfully');
      }
    } catch (e) {
      // If .env file doesn't exist or has errors, just use defaults
      if (kDebugMode) {
        print('No .env file found or error loading it, using default configuration: $e');
      }
      // Continue with default values
    }
    
    // Ensure API_BASE_URL is set
    if (_env['API_BASE_URL'] == null || _env['API_BASE_URL']!.isEmpty) {
      _env['API_BASE_URL'] = 'http://localhost:8000';
    }
  }
}
