import 'package:dio/dio.dart';

class DataService {
  Dio dio = Dio();

  Future<List> fetchEvents() async {
    final response = await dio.get('https://66e6c57517055714e58a7cc9.mockapi.io/api/v1/events');
    return response.data;
  }

  Future<List> fetchTeams() async {
    final response = await dio.get('https://66e5b9195cc7f9b6273e2c1b.mockapi.io/teamname');
    return response.data;
  }
}
