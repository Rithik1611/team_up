import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:team_up/db/sembast_service.dart';
import 'package:url_launcher/url_launcher.dart'; // Import MemberDetailsPage

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Map<String, dynamic>> teamMembers = [];
  String searchQuery = '';
  Timer? debounce;

  final String defaultAvatarUrl =
      'https://via.placeholder.com/150'; // Default image URL

  String? token; // Token to be retrieved from SembastService
  final SembastService sembastService =
      SembastService(); // Instantiate SembastService

  bool showMessage = true; // Flag to show message

  @override
  void initState() {
    super.initState();
    initializeTokenAndFetchMembers(); // Fetch token and team members
  }

  @override
  void dispose() {
    debounce?.cancel();
    super.dispose();
  }

  Future<void> initializeTokenAndFetchMembers() async {
    // Retrieve the token from SembastService
    token = await sembastService.getToken();

    if (token != null) {
      print('Token retrieved from Sembast: $token');
    } else {
      print('No token found, please log in.');
      // Handle the case where no token is found if needed
    }

    // Fetch team members after token retrieval
    fetchTeamMembers();
  }

  Future<void> fetchTeamMembers() async {
    try {
      String mockApiUrl =
          'https://kcgteamupserver-production.up.railway.app/api/user/getAllUsers';

      Response response = await Dio().get(
        mockApiUrl,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token', // Use the token from Sembast
          },
        ),
      );
      print(response);
      print(token);
      print("Res : $response");
      List<dynamic> data = response.data;

      // Print the API response to the debug console
      print("API Response: $data");

      setState(() {
        teamMembers = data.map((item) {
          return {
            'id': item['id'],
            'name': item['name'],
            'profilePic': item['profilePic'] ??
                defaultAvatarUrl, // Use default image if avatarUrl is null
            'skills': item['skills'].join(', '), // Assuming skills is a list
          };
        }).toList();
      });
    } catch (e) {
      print("Error fetching team members: $e");
    }
  }

  void onSearchChanged(String value) {
    if (debounce?.isActive ?? false) debounce?.cancel();
    debounce = Timer(Duration(milliseconds: 300), () {
      setState(() {
        searchQuery = value;
        // Update showMessage flag based on searchQuery
        showMessage = searchQuery.isEmpty && teamMembers.isEmpty;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredMembers = teamMembers
        .where((member) =>
            member['skills']!
                .toLowerCase()
                .contains(searchQuery.toLowerCase()) ||
            member['name']!.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 49, 0, 128),
        title: const Text('Search'),
      ),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              onChanged: onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search Students',
                prefixIcon: Icon(Icons.search),
                suffixIcon: searchQuery.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          setState(() {
                            searchQuery = '';
                            showMessage = teamMembers.isEmpty;
                          });
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),
          if (showMessage)
            Expanded(
              child: Center(
                child: Text(
                  'Search Students based \n on Name and Skills',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            )
          else if (searchQuery.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: filteredMembers.length,
                itemBuilder: (context, index) {
                  final member = filteredMembers[index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MemberDetailsPage(
                              memberId:
                                  member['id']), // Pass id to MemberDetailsPage
                        ),
                      );
                    },
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                            member['avatarUrl'] ?? defaultAvatarUrl),
                      ),
                      title: Text(member['name']!),
                      subtitle: Text('${member['skills']}'),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class MemberDetailsPage extends StatefulWidget {
  final String memberId; // Member ID to fetch details

  const MemberDetailsPage({Key? key, required this.memberId}) : super(key: key);

  @override
  _MemberDetailsPageState createState() => _MemberDetailsPageState();
}

class _MemberDetailsPageState extends State<MemberDetailsPage> {
  late Future<Map<String, dynamic>> _memberFuture;

  @override
  void initState() {
    super.initState();
    _memberFuture = _fetchMemberDetails(widget.memberId);
  }

  Future<Map<String, dynamic>> _fetchMemberDetails(String id) async {
    final Dio _dio = Dio();
    final SembastService _sembastService = SembastService();
    try {
      final token = await _sembastService.getToken(); // Fetch the token
      final response = await _dio.get(
        'https://kcgteamupserver-production.up.railway.app/api/user/$id',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token', // Add token to the headers
          },
        ),
      );
      return response.data;
    } catch (e) {
      throw Exception('Failed to load member details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 49, 0, 128),
        title: const Text("Member Profile"),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _memberFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('No data found'));
          } else {
            final _member = snapshot.data!;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: NetworkImage(_member['profilePic']),
                          backgroundColor:
                              const Color.fromARGB(255, 137, 137, 137),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _member['name'],
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              '${_member['year']} Year',
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              _member['department'],
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              _member['section'],
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Skill set:',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8.0,
                      children: (_member['skills'] as List<dynamic>)
                          .map((skill) => Chip(
                                label: Text(skill as String,
                                    style:
                                        const TextStyle(color: Colors.white)),
                                backgroundColor:
                                    const Color.fromARGB(255, 49, 0, 128),
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 20),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Interested:',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8.0,
                      children: (_member['interests'] as List<dynamic>)
                          .map((interest) => Chip(
                                label: Text(interest as String,
                                    style:
                                        const TextStyle(color: Colors.white)),
                                backgroundColor:
                                    const Color.fromARGB(255, 49, 0, 128),
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 20),
                    // Add links to LinkedIn, Portfolio, GitHub
                    if (_member['linkedin'] != null) ...[
                      _buildLinkTile(
                        icon: Icons.link,
                        title: 'LinkedIn',
                        url: _member['linkedin'],
                      ),
                      const SizedBox(height: 10),
                    ],
                    if (_member['portfolio'] != null) ...[
                      _buildLinkTile(
                        icon: Icons.web,
                        title: 'Portfolio',
                        url: _member['portfolio'],
                      ),
                      const SizedBox(height: 10),
                    ],
                    if (_member['github'] != null) ...[
                      _buildLinkTile(
                        icon: Icons.check,
                        title: 'GitHub',
                        url: _member['github'],
                      ),
                    ],
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildLinkTile(
      {required IconData icon, required String title, required String url}) {
    return InkWell(
      onTap: () => _launchURL(url),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        tileColor: Colors.grey[200],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        leading: Icon(icon, size: 30, color: Colors.black),
        trailing: const Icon(Icons.arrow_forward, color: Colors.black),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        subtitle: Text(
          url,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
