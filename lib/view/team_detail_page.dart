import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:team_up/db/sembast_service.dart'; // Ensure you have the correct import

class TeamDetailPage extends StatefulWidget {
  final String teamId;
  final Map<String, dynamic> team;

  const TeamDetailPage({Key? key, required this.teamId, required this.team})
      : super(key: key);

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
    final token = await _sembastService.getToken();

    final options = Options(
      headers: token != null ? {'Authorization': 'Bearer $token'} : {},
    );
    print(widget.teamId);
    final response = await _dio.get(
      'https://kcgteamupserver-production.up.railway.app/api/team/getTeamDetails/${widget.teamId}',
      options: options,
    );
    print(response);

    if (response.statusCode == 200) {
      setState(() {
        team = response.data;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
        team = {};
      });
      print('Failed to load team details: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.team['teamName'] ?? 'Team Details'),
        backgroundColor: const Color.fromARGB(255, 49, 0, 128),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Team Info Card
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                             team?['teamName'] ?? 'N/A',
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Description: ${team?['teamDes'] ?? 'No Description'}',
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 10),
                           Text(
                              'SIZE: ${team?['teamSize'] ?? 'N/A'}',
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Members Section
                    const Text(
                      'Members :',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Display list of members
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: team?['members'].length ?? 0,
                      itemBuilder: (context, index) {
                        final member = team?['members'][index];
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 3,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  member['name'] ?? 'Unknown',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  member['department'] ?? '', // Assuming dept is passed
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
