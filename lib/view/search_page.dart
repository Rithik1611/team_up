import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

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
  final String defaultToken =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYW1lIjoiQXN3aW4iLCJpZCI6IjY2YmVlZmQzNDJhOTE4Yzg0YWNkOTk3NyIsInJvbGUiOiJzdHVkZW50IiwiaWF0IjoxNzIzNzg5MjY3LCJleHAiOjE3MjYzODEyNjd9.n9pmbrvLlYd9HVl6vyCKulyKO7VpPr5WDHQEaY6o-ZE'; // Default token

  @override
  void initState() {
    super.initState();
    fetchTeamMembers();
  }

  @override
  void dispose() {
    debounce?.cancel();
    super.dispose();
  }

  Future<void> fetchTeamMembers() async {
    try {
      String mockApiUrl =
          'https://kcgteamupserver-production.up.railway.app/api/user/getAllUsers';

      Response response = await Dio().get(
        mockApiUrl,
        options: Options(
          headers: {
            'Authorization': 'Bearer $defaultToken',
          },
        ),
      );

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
            'token': item['token'] ??
                defaultToken, // Use default token if not provided
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search for team members by skill or name',
                prefixIcon: Icon(Icons.search),
                suffixIcon: searchQuery.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          setState(() {
                            searchQuery = '';
                          });
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
          ),
          if (searchQuery.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: filteredMembers.length,
                itemBuilder: (context, index) {
                  final member = filteredMembers[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage:
                          NetworkImage(member['avatarUrl'] ?? defaultAvatarUrl),
                    ),
                    title: Text(member['name']!),
                    subtitle: Text('${member['skills']}'),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
