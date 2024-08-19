import 'package:dio/dio.dart';

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
        // Add Authorization token to the headers
        options.headers['Authorization'] =
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYW1lIjoiQXN3aW4iLCJpZCI6IjY2YmVlZmQzNDJhOTE4Yzg0YWNkOTk3NyIsInJvbGUiOiJzdHVkZW50IiwiaWF0IjoxNzIzNzg5MjY3LCJleHAiOjE3MjYzODEyNjd9.n9pmbrvLlYd9HVl6vyCKulyKO7VpPr5WDHQEaY6o-ZE';
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
