import 'package:dio/dio.dart';
import 'package:team_up/api/auth_model.dart';

class DioService {
  final Dio _dio = Dio()
    ..interceptors.add(LogInterceptor(
      request: true,
      requestBody: true,
      responseBody: true,
      error: true,
    ));

  DioService() {
    _dio.options.baseUrl =
        'https://kcgteamupserver-production.up.railway.app/api';
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Fetch the token from Sembast database
        final authModel = AuthModel();
        final token = await authModel.getToken();

        if (token != null) {
          // Add Authorization token to the headers
          options.headers['Authorization'] = 'Bearer $token';
          print('Authorization Header: Bearer $token');
        } else {
          print('No token found');
        }

        return handler.next(options); // Continue with the request
      },
    ));
  }

  // Update this method to accept FormData
  Future<Response> postRequest(String endpoint, dynamic data) async {
    try {
      return await _dio.post(endpoint, data: data);
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getRequest(String endpoint) async {
    try {
      return await _dio.get(endpoint);
    } catch (e) {
      rethrow;
    }
  }
}
