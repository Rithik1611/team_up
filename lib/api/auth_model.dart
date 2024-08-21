import 'package:dio/dio.dart';
import 'package:team_up/db/sembast_service.dart';

class AuthModel {
  final Dio _dio;
  final SembastService _sembastService = SembastService();

  AuthModel()
      : _dio = Dio(
          BaseOptions(
            baseUrl: 'https://kcgteamupserver-production.up.railway.app/api',
            headers: {'Content-Type': 'application/json'},
          ),
        );

  // Sign up a new user and save the token if successful
  Future<bool> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        '/auth/register',
        data: {
          'name': name,
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        if (response.data['accessToken'] != null) {
          await _sembastService.saveToken(response.data['accessToken']);
        }
        return true;
      } else {
        print('Signup failed with status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error during signup: $e');
      return false;
    }
  }

  // Log in an existing user and save the token if successful
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.data;
        print(responseData);
        if (responseData['accessToken'] != null) {
          await _sembastService.saveToken(responseData['accessToken']);
        }
        return true;
      } else {
        print('Login failed with status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error during login: $e');
      return false;
    }
  }

  // Public method to get the token
  Future<String?> getToken() async {
    return await _sembastService.getToken();
  }
}
