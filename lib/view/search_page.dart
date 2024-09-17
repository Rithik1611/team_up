import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:team_up/db/sembast_service.dart';

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
      // You can handle the case where no token is found if needed
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
            'avatarUrl': item['avatarUrl'] ??
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
                          builder: (context) =>
                              MemberDetailsPage(member: member),
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
  final Map<String, dynamic>
      member; // Member details passed from the SearchPage

  const MemberDetailsPage({Key? key, required this.member}) : super(key: key);

  @override
  _MemberDetailsPageState createState() => _MemberDetailsPageState();
}

class _MemberDetailsPageState extends State<MemberDetailsPage> {
  late Map<String, dynamic> _member;

  @override
  void initState() {
    super.initState();
    _member = widget.member; // Initialize member details
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 49, 0, 128),
        title: const Text("Member Profile"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(_member['avatarUrl']),
                    backgroundColor: const Color.fromARGB(255, 137, 137, 137),
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
                      // If additional details like year/department/section exist in member, show them here
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
                children: (_member['skills'] as String)
                    .split(', ') // Convert comma-separated string into a list
                    .map((skill) => Chip(
                        label: Text(skill,
                            style: const TextStyle(color: Colors.white)),
                        backgroundColor: const Color.fromARGB(255, 49, 0, 128)))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
