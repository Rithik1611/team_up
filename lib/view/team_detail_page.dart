import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:team_up/db/sembast_service.dart'; // Ensure you have the correct import

class TeamDetailPage extends StatefulWidget {
  final String teamId;

  const TeamDetailPage({Key? key, required this.teamId, required team}) : super(key: key);

  @override
  _TeamDetailPageState createState() => _TeamDetailPageState();
}

class _TeamDetailPageState extends State<TeamDetailPage> {
  Map<String, dynamic>? team;
  bool isLoading = true;
  final Dio _dio = Dio();
  final SembastService _sembastService = SembastService();

  @override
  void initState() {
    super.initState();
    fetchTeamDetails();
  }

  Future<void> fetchTeamDetails() async {
    // Retrieve token
    final token = await _sembastService.getToken();

    // Prepare Dio request options
    final options = Options(
      headers: token != null ? {'Authorization': 'Bearer $token'} : {},
    );

    // Perform the GET request
    final response = await _dio.get(
      'https://kcgteamupserver-production.up.railway.app/api/team/getUserTeams/${widget.teamId}',
      options: options,
    );

    // Check response status
    if (response.statusCode == 200) {
      setState(() {
        team = response.data;
        isLoading = false;
      });
    } else {
      // Handle errors based on the status code
      setState(() {
        isLoading = false;
        team = {}; // Set team to an empty map or null if appropriate
      });
      print('Failed to load team details: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(team?['teamName'] ?? 'Team Details'),
        backgroundColor: const Color.fromARGB(255, 49, 0, 128),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Team Name: ${team?['teamName'] ?? 'N/A'}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Description: ${team?['description'] ?? 'No Description'}',
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Founded Year: ${team?['foundedYear'] ?? 'N/A'}',
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
