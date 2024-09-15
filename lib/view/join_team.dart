import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class TeamListPage extends StatefulWidget {
  @override
  _TeamListPageState createState() => _TeamListPageState();
}

class _TeamListPageState extends State<TeamListPage> {
  List<dynamic> teams = [];
  List<dynamic> filteredTeams = [];
  bool isLoading = true;
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    fetchTeams();
  }

  // Function to fetch data from the API
  Future<void> fetchTeams() async {
    try {
      Dio dio = Dio();
      final response =
          await dio.get('https://66d71637006bfbe2e64fc664.mockapi.io/team');
      setState(() {
        teams = response.data;
        filteredTeams = teams; // Initially, all teams are displayed
        isLoading = false;
      });
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
                  CircularProgressIndicator()) // Show loading indicator while fetching data
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
