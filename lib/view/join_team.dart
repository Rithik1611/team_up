import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:team_up/db/sembast_service.dart';

class TeamListPage extends StatefulWidget {
  @override
  _TeamListPageState createState() => _TeamListPageState();
}

class _TeamListPageState extends State<TeamListPage> {
  List<dynamic> teams = [];
  List<dynamic> filteredTeams = [];
  bool isLoading = true;
  String searchQuery = "";
  final SembastService sembastService =
      SembastService(); // Instance of SembastService

  @override
  void initState() {
    super.initState();
    fetchTeams();
  }

  // Function to fetch data from the API with token authorization
  Future<void> fetchTeams() async {
    try {
      Dio dio = Dio();
      String? token =
          await sembastService.getToken(); // Retrieve token from SembastService
      print(token);
      if (token != null) {
        final response = await dio.get(
          'https://kcgteamupserver-production.up.railway.app/api/team/getAllTeams',
          options: Options(
            headers: {
              'Authorization':
                  'Bearer $token', // Attach the token in the header
            },
          ),
        );
        setState(() {
          teams = response.data;
          filteredTeams = teams; // Initially, all teams are displayed
          isLoading = false;
        });
      } else {
        print('No token found');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching data: $e');
    }
  }

  // Function to filter the teams based on the search query
  void filterTeams(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      if (searchQuery.isEmpty) {
        filteredTeams = teams; // Show all teams if the search query is empty
      } else {
        filteredTeams = teams.where((team) {
          final teamName = team['teamName'].toLowerCase();
          return teamName.contains(searchQuery);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 49, 0, 128),
        title: Text('Team List'),
      ),
      body: isLoading
          ? Center(
              child:
                  CircularProgressIndicator(), // Show loading indicator while fetching data
            )
          : Column(
              children: [
                // Search bar
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 15.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search team names...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    onChanged: filterTeams, // Call filterTeams on input change
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 15.0),
                    child: ListView.builder(
                      itemCount: filteredTeams.length,
                      itemBuilder: (context, index) {
                        final team = filteredTeams[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[
                                  200], // Background color for the ListTile
                              borderRadius:
                                  BorderRadius.circular(12), // Rounded corners
                            ),
                            child: ListTile(
                              title: Text(team['teamName']),
                              subtitle: Text('Members: ${team['teamSize']}'),
                              onTap: () {
                                // Navigate to the new Team Details page
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TeamDetailsPage(
                                      teamId: team[
                                          'id'], // Pass team ID to details page
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class TeamDetailsPage extends StatefulWidget {
  final String teamId; // Accept the teamId from the previous page

  TeamDetailsPage({required this.teamId});

  @override
  _TeamDetailsPageState createState() => _TeamDetailsPageState();
}

class _TeamDetailsPageState extends State<TeamDetailsPage> {
  bool isLoading = true;
  Map<String, dynamic>? teamDetails;
  final SembastService sembastService =
      SembastService(); // Instance of SembastService

  @override
  void initState() {
    super.initState();
    fetchTeamDetails(); // Fetch the details when the page is loaded
  }

  Future<void> fetchTeamDetails() async {
    try {
      Dio dio = Dio();
      String? token = await sembastService.getToken(); // Retrieve token
      print(widget.teamId);
      if (token != null) {
        final response = await dio.get(
          'https://kcgteamupserver-production.up.railway.app/api/team/getTeamDetails/${widget.teamId}',
          options: Options(
            headers: {
              'Authorization': 'Bearer $token', // Attach token to header
            },
          ),
        );
        print(response);
        setState(() {
          teamDetails = response.data;
          isLoading = false;
        });
      } else {
        print('No token found');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching team details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Team Details'),
        backgroundColor: const Color.fromARGB(255, 49, 0, 128),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : teamDetails == null
              ? Center(child: Text('Failed to load team details'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Team Name: ${teamDetails!['teamName']}',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text('Description: ${teamDetails!['teamDes']}'),
                      SizedBox(height: 8),
                      Text('Team Size: ${teamDetails!['teamSize']}'),
                      SizedBox(height: 16),
                      Text(
                        'Team Members:',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Expanded(
                        child: ListView.builder(
                          itemCount: teamDetails!['members'].length,
                          itemBuilder: (context, index) {
                            final member = teamDetails!['members'][index];

                            // Determine text for title and subtitle based on member data
                            final String titleText = member != null
                                ? (member['memName'] ?? 'Unknown')
                                : 'accept request pending';
                            final String subtitleText = member != null
                                ? (member['memDept'] ?? 'null')
                                : 'null';

                            return ListTile(
                              title: Text(titleText), // Display member name
                              subtitle: Text(
                                  subtitleText), // Display member department
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
