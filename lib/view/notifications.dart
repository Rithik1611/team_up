import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:team_up/db/sembast_service.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  final SembastService _sembastService = SembastService();
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://kcgteamupserver-production.up.railway.app/api',
      headers: {'Content-Type': 'application/json'},
    ),
  );
  List<Map<String, dynamic>> _messages =
      []; // Expecting List<Map<String, dynamic>>

  @override
  void initState() {
    super.initState();
    _fetchMessages();
  }

  // Fetch messages from the Sembast database
  Future<void> _fetchMessages() async {
    final messages = await _sembastService
        .getAllMessages(); // This returns a List<Map<String, dynamic>>
    setState(() {
      _messages = messages;
    });
  }

  // Function to format the date
  String _formatDate(String dateStr) {
    try {
      final dateTime = DateTime.parse(dateStr);
      return DateFormat('yyyy-MM-dd – kk:mm').format(dateTime);
    } catch (e) {
      return "Invalid Date";
    }
  }

  // Function to add token to headers and handle POST requests
  Future<void> _postRequest(String endpoint, Map<String, dynamic> body) async {
    final token = await _sembastService.getToken();
    final options = Options(
      headers: {'Authorization': 'Bearer $token'},
    );

    _dio
        .post(
      endpoint,
      data: body,
      options: options,
    )
        .then((response) {
      if (response.statusCode == 200) {
        print('Request successful.');
      } else {
        print('Failed to perform request: ${response.statusCode}');
      }
    }).catchError((error) {
      print('Error occurred: $error');
    });
  }

  // Function to handle the accept action
  Future<void> _handleAccept(String teamId, String teamName) async {
    final body = {
      'teamId': teamId,
      'teamName': teamName,
      'status': 'accept',
    };

    await _postRequest('/user/invite/decision', body);
  }

  // Function to handle the reject action
  Future<void> _handleReject(String teamId, String teamName) async {
    final body = {
      'teamId': teamId,
      'teamName': teamName,
      'status': 'reject',
    };

    await _postRequest('/user/invite/decision', body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: _messages.isEmpty
          ? Center(child: Text('No notifications found.'))
          : ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final messageMap = _messages[index]; // Already a map
                final message = messageMap['message'] ?? 'No message';
                final inviteDate = messageMap['inviteDate'] ?? '';
                final teamId = messageMap['teamId'] ?? '';
                final teamName = messageMap['teamName'] ?? 'Unknown Team';

                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      tileColor: Colors.grey[200],
                      title: Text(message),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_formatDate(inviteDate)),
                          SizedBox(height: 8), // Space between text and icons
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.end, // Align icons to the end
                            children: [
                              GestureDetector(
                                onTap: () {
                                  _handleAccept(teamId, teamName);
                                },
                                child: Icon(Icons.check, color: Colors.green),
                              ),
                              SizedBox(width: 16), // Space between the icons
                              GestureDetector(
                                onTap: () {
                                  _handleReject(teamId, teamName);
                                },
                                child: Icon(Icons.close, color: Colors.red),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
