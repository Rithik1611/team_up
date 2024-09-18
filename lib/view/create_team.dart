import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:team_up/db/sembast_service.dart'; // Import the Sembast service
import 'package:team_up/models/student.dart';
import 'package:team_up/view/main_screen.dart';

class TeamInfoPage extends StatefulWidget {
  final Student student;
  const TeamInfoPage({Key? key, required this.student}) : super(key: key);

  @override
  _TeamInfoPageState createState() => _TeamInfoPageState();
}

class _TeamInfoPageState extends State<TeamInfoPage> {
  final TextEditingController teamNameController = TextEditingController();
  final TextEditingController teamDescriptionController =
      TextEditingController();
  int? _selectedTeamSize; // To store the selected team size
  late Student _student;
  final Dio _dio = Dio(); // Dio instance
  final SembastService _sembastService =
      SembastService(); // Sembast service instance
  String? teamId; // To store the teamId from the API response

  @override
  void initState() {
    super.initState();
    _student = widget.student; // Initialize the _student variable here
  }

  // Create team function with token retrieved from Sembast
  Future<void> _createTeam(
      String teamName, String teamDescription, int teamSize) async {
    final String url =
        'https://kcgteamupserver-production.up.railway.app/api/team/createTeam';

    // Retrieve the token from Sembast
    String? token = await _sembastService.getToken();

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                const Text('Failed to retrieve token. Please log in again.')),
      );
      return; // Exit the function if the token is null
    }

    try {
      // Make the POST request with the token in the Authorization header
      final response = await _dio.post(
        url,
        data: {
          'teamName': teamName,
          'teamDes': teamDescription,
          'teamSize': teamSize,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Extract teamId from the response data
        final data = response.data;
        if (data != null && data['teamDetails'] != null) {
          teamId = data['teamDetails']['id'];
          print(data);
          print(teamId);

          // Navigate to the next screen, passing teamId along with other details
          if (teamId != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MembersSearch(
                  student: _student,
                  teamName: teamName, // Pass team name
                  teamDescription: teamDescription, // Pass team description
                  teamId: teamId!, // Pass the retrieved teamId
                  teamSize: _selectedTeamSize!, // Pass the selected team size
                ),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed to retrieve team ID.')),
            );
          }
        } else {
          throw Exception('Invalid response data');
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to create team. Try again!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 49, 0, 128),
        title: const Text('Enter Team Info'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: teamNameController,
              decoration: const InputDecoration(
                labelText: 'Team Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: teamDescriptionController,
              decoration: const InputDecoration(
                labelText: 'Team Description',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            DropdownButtonFormField<int>(
              decoration: const InputDecoration(
                labelText: 'Team Size',
                border: OutlineInputBorder(),
              ),
              value: _selectedTeamSize,
              items: List.generate(6, (index) {
                return DropdownMenuItem<int>(
                  value: index + 1,
                  child: Text((index + 1).toString()),
                );
              }),
              onChanged: (value) {
                setState(() {
                  _selectedTeamSize = value;
                });
              },
            ),
            const SizedBox(height: 16.0),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 49, 0, 128),
                ),
                onPressed: () {
                  if (teamNameController.text.isNotEmpty &&
                      teamDescriptionController.text.isNotEmpty &&
                      _selectedTeamSize != null) {
                    _createTeam(
                      teamNameController.text,
                      teamDescriptionController.text,
                      _selectedTeamSize!,
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            'Please fill out Team Name, Description, and Team Size'),
                      ),
                    );
                  }
                },
                child: const Text('Continue to Search'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MembersSearch extends StatefulWidget {
  final Student student;
  final String teamName;
  final String teamDescription;
  final String teamId;
  final int teamSize; // Add this

  MembersSearch({
    required this.student,
    required this.teamName,
    required this.teamDescription,
    required this.teamId,
    required this.teamSize, // Add this
  });

  @override
  _MembersSearchState createState() => _MembersSearchState();
}

class _MembersSearchState extends State<MembersSearch> {
  List<Map<String, dynamic>> teamMembers = [];
  List<Map<String, dynamic>> selectedMembers = [];
  String searchQuery = '';
  Timer? debounce;

  final String defaultAvatarUrl =
      'https://via.placeholder.com/150'; // Default image URL

  String? token;
  final SembastService sembastService = SembastService();
  late Student _student;
  late String _teamId;
  late int _teamSize; // Add this

  // Use the student data from ProfilePage for myProfile
  late final Map<String, dynamic> myProfile;

  @override
  void initState() {
    super.initState();
    initializeTokenAndFetchMembers();
    _teamId = widget.teamId;
    _student = widget.student;
    _teamSize = widget.teamSize; // Initialize teamSize

    myProfile = {
      'name': widget.student.name,
      'avatarUrl': widget.student.profilePic.path.isNotEmpty
          ? widget.student.profilePic.path
          : defaultAvatarUrl,
      'skills': widget.student.skills.join(', '),
      'accepted': true, // Assume you've accepted the team invite
    };
  }

  @override
  void dispose() {
    debounce?.cancel();
    super.dispose();
  }

  Future<void> initializeTokenAndFetchMembers() async {
    token = await sembastService.getToken();
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
            'Authorization': 'Bearer $token',
          },
        ),
      );

      List<dynamic> data = response.data;

      setState(() {
        teamMembers = data.map((item) {
          return {
            'id': item['id'],
            'name': item['name'],
            'avatarUrl': item['avatarUrl'] ?? defaultAvatarUrl,
            'skills': item['skills'].join(', '),
          };
        }).toList();
      });
    } catch (e) {
      print("Error fetching team members: $e");
    }
  }

  void onSearchChanged(String value) {
    if (debounce?.isActive ?? false) debounce?.cancel();
    debounce = Timer(const Duration(milliseconds: 300), () {
      setState(() {
        searchQuery = value;
      });
    });
  }

  void selectMember(Map<String, dynamic> member) {
    setState(() {
      if (selectedMembers.contains(member)) {
        selectedMembers.remove(member); // Unselect member
      } else {
        if (selectedMembers.length < _teamSize - 1) {
          // Adjust based on teamSize
          selectedMembers.add(member); // Select member
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Maximum team size reached")),
          );
        }
      }
    });
  }

  void navigateToCreateTeam() {
    if (!selectedMembers.contains(myProfile)) {
      selectedMembers.insert(0, myProfile); // Include yourself in the team
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectedMembersPage(
          teamId: _teamId,
          student: _student,
          selectedMembers: selectedMembers,
          teamName: widget.teamName, // Pass the teamName
          teamDescription: widget.teamDescription, // Pass the teamDescription
        ),
      ),
    );
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
                prefixIcon: const Icon(Icons.search),
                suffixIcon: searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close),
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

          // Display selected team members at the top
          if (selectedMembers.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                spacing: 8.0,
                children: selectedMembers.map((member) {
                  return Chip(
                    avatar: CircleAvatar(
                      backgroundImage: NetworkImage(
                        member['avatarUrl'] ?? defaultAvatarUrl,
                      ),
                    ),
                    label: Text(member['name']!),
                    onDeleted: () {
                      // Unselect member when the close icon is clicked
                      setState(() {
                        selectedMembers.remove(member);
                      });
                    },
                  );
                }).toList(),
              ),
            ),

          // Display filtered members in the ListView when search is triggered
          if (searchQuery.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: filteredMembers.length,
                itemBuilder: (context, index) {
                  final member = filteredMembers[index];
                  bool isSelected = selectedMembers.contains(member);

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage:
                          NetworkImage(member['avatarUrl'] ?? defaultAvatarUrl),
                    ),
                    title: Text(member['name']!),
                    subtitle: Text('${member['skills']}'),
                    trailing: IconButton(
                      icon: Icon(
                        isSelected ? Icons.check : Icons.add,
                        color: isSelected ? Colors.green : Colors.blue,
                      ),
                      onPressed: () {
                        selectMember(member);
                      },
                    ),
                  );
                },
              ),
            ),

          // Show create team button
          if (selectedMembers.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: navigateToCreateTeam,
                child: Text(
                    'Create Team (${selectedMembers.length + 1}/$_teamSize)'),
              ),
            ),
        ],
      ),
    );
  }
}

class SelectedMembersPage extends StatefulWidget {
  final List<Map<String, dynamic>> selectedMembers;
  final String teamName;
  final String teamDescription;
  final Student student;
  final String teamId;

  SelectedMembersPage(
      {required this.selectedMembers,
      required this.teamName,
      required this.teamDescription,
      required this.student,
      required this.teamId});

  @override
  _SelectedMembersPageState createState() => _SelectedMembersPageState();
}

class _SelectedMembersPageState extends State<SelectedMembersPage> {
  late Student _student;
  String? token;
  final SembastService sembastService = SembastService();
  final Dio _dio = Dio(); // Add Dio instance for making API requests
  late String _teamId;

  @override
  void initState() {
    super.initState();
    _student = widget.student;
    _teamId = widget.teamId;
  }

  Future<void> initializeToken() async {
    token = await sembastService.getToken();
  }

  // Function to invite team members using the generated teamId
  Future<void> inviteTeamMembers(String teamId) async {
    for (var member in widget.selectedMembers) {
      print(member);

      if (member['id'] != null && member['id'] is String) {
        print(teamId);
        try {
          initializeToken();
          print(token);
          final String inviteMemberUrl =
              'https://kcgteamupserver-production.up.railway.app/api/team/inviteToTeam/${member['id']}';
          final response = await _dio.post(
            inviteMemberUrl,
            data: {
              'teamId': _teamId,
            },
            options: Options(
              headers: {'Authorization': 'Bearer $token'},
            ),
          );

          if (response.statusCode == 200 || response.statusCode == 201) {
            print('Invitation sent to ${member['name']}');
          } else {
            print('Failed to invite ${member['name']}');
          }
        } catch (e) {
          print("Error inviting member ${member['name']}: $e");
        }
      } else {
        print(
            'Error: Invalid or missing user ID for member: ${member['name']}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 49, 0, 128),
        title: const Text('Create Team'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display Team Name and Description
            Text(
              'Team Name: ${widget.teamName}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Team Description: ${widget.teamDescription}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 16.0),

            // Selected Members Section
            const Text(
              'Selected Members (including you):',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: widget.selectedMembers.length,
                itemBuilder: (context, index) {
                  final member = widget.selectedMembers[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(member['avatarUrl']),
                    ),
                    title: Text(member['name']),
                    subtitle: Text(member['skills']),
                  );
                },
              ),
            ),
            const SizedBox(height: 16.0),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  if (_teamId != null) {
                    // Invite team members using the teamId
                    await inviteTeamMembers(_teamId);

                    // Navigate to TeamDetailsPage
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TeamDetailsPage(
                          student: _student,
                          teamName: widget.teamName,
                          teamDescription: widget.teamDescription,
                          members: widget.selectedMembers,
                        ),
                      ),
                    );
                  }
                },
                child: const Text('Confirm and Create Team'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TeamDetailsPage extends StatefulWidget {
  final String teamName;
  final String teamDescription;
  final List<Map<String, dynamic>> members;
  final Student student; // Assuming a Student object is required

  const TeamDetailsPage({
    super.key,
    required this.teamName,
    required this.teamDescription,
    required this.members,
    required this.student, // Accept Student object in constructor
  });

  @override
  State<TeamDetailsPage> createState() => _TeamDetailsPageState();
}

class _TeamDetailsPageState extends State<TeamDetailsPage> {
  late Student _student;

  @override
  void initState() {
    super.initState();
    _student = widget.student; // Initialize _student using widget.student
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 49, 0, 128),
        title: Text(widget.teamName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Team Name: ${widget.teamName}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Description: ${widget.teamDescription}', // Use widget.teamDescription
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Members:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Expanded(
              child: ListView.builder(
                itemCount: widget.members.length, // Access widget.members
                itemBuilder: (context, index) {
                  final member = widget.members[index];
                  bool hasAccepted =
                      member['accepted'] ?? false; // Check if user accepted

                  return Container(
                    color: hasAccepted
                        ? Colors.transparent
                        : Colors
                            .grey.shade300, // Grey background if not accepted
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(member['avatarUrl']),
                      ),
                      title: Text(member['name']),
                      subtitle: Text(member['skills']),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16.0),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Navigate back to the main screen
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MainScreen(student: _student),
                    ), // Navigate to MainScreen with student object
                    (route) => false, // This clears the stack
                  );
                },
                child: const Text('Go to Main Screen'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
