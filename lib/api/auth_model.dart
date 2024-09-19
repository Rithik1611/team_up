import 'package:dio/dio.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:team_up/db/sembast_service.dart';

class AuthModel {
  final Dio _dio;
  final SembastService _sembastService = SembastService();
  IO.Socket? socket;
  String? userid;

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
        final data = response.data;
        if (response.data['accessToken'] != null) {
          print(data);
          print(data['id']);
          userid = data['id'];
          connectToSocket(userid!);
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

  // Connect to the socket and register the userId
  void connectToSocket(String userId) {
    socket = IO.io(
        'https://kcgteamupserver-production.up.railway.app', <String, dynamic>{
      'transports': ['websocket'], // Use WebSocket transport
      'autoConnect': false,
    });

    // Connect to the socket
    socket!.connect();
    print("connected to socket");

    // Listen for the 'connect' event
    socket!.onConnect((_) {
      print('Connected to the server');

      // Register the userId with the server
      socket!.emit('register', userId);

      // Listen for 'inviteNotification' event
      socket!.on('inviteNotification', (data) async {
        print('Invite notification received: $data');
        print('data: $data');
        // Store the message in Sembast database as a map
        await _sembastService.storeMessage({
          'message': data['message'],
          'teamName': data['teamName'],
          'teamId': data['teamId'],
          'inviteDate': data['inviteDate'],
        });
      });
    });

    // Handle disconnection
    socket!.onDisconnect((_) => print('Disconnected from server'));
  }

  // Optionally, disconnect the socket when done
  void disconnectSocket() {
    if (socket != null) {
      socket!.disconnect();
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
