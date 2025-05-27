import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/network/api_client.dart';
import '../../domain/entities/user.dart';

abstract class AuthRemoteDataSource {
  Future<User> login(String email, String password);
  Future<User> getCurrentUser();
  Future<void> logout();
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> clearToken();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient client;
  final SharedPreferences prefs;

  AuthRemoteDataSourceImpl({required this.client, required this.prefs});

  @override
  Future<User> login(String email, String password) async {
    print('⚠️ Attempting login with email: $email');
    print('⚠️ API Base URL: ${client.baseUrl}');
    
    try {
      // Use x-www-form-urlencoded format for FastAPI OAuth2 password flow
      final response = await client.post<Map<String, dynamic>>(
        '/auth/login',
        body: {
          'username': email,  // Using username as per FastAPI backend expectations
          'password': password,
        },
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      );

      return response.fold(
        (failure) {
          print('⚠️ Login failed with error: ${failure.message}');
          throw failure;
        },
        (data) async {
          print('⚠️ Login response: $data');
          final token = data['access_token'] as String?;
          if (token == null) {
            print('⚠️ No token found in response');
            throw Exception('No access token in response');
          }
          
          await saveToken(token);
          print('⚠️ Token saved successfully');
          
          // Get user data after successful login
          return await getCurrentUser();
        },
      );
    } catch (e) {
      print('⚠️ Exception during login: $e');
      rethrow;
    }
  }

  @override
  Future<User> getCurrentUser() async {
    print('🔍 Fetching current user...');
    final response = await client.get<Map<String, dynamic>>(
      '/auth/me',
      fromJson: (json) => json as Map<String, dynamic>,
    );

    return response.fold(
      (failure) {
        print('❌ Failed to fetch current user: ${failure.message}');
        throw failure;
      },
      (data) {
        print('🔍 Current user data: $data');
        try {
          // Check if the data is nested under 'data' key or is the response itself
          final userData = data['data'] as Map<String, dynamic>? ?? data;
          print('🔍 Parsing user data: $userData');
          final user = User.fromJson(userData);
          print('✅ Successfully parsed user: ${user.email}');
          return user;
        } catch (e) {
          print('❌ Error parsing user data: $e');
          rethrow;
        }
      },
    );
  }

  @override
  Future<void> logout() async {
    await clearToken();
  }

  @override
  Future<void> saveToken(String token) async {
    await prefs.setString('auth_token', token);
  }

  @override
  Future<String?> getToken() async {
    return prefs.getString('auth_token');
  }

  @override
  Future<void> clearToken() async {
    await prefs.remove('auth_token');
  }
}
