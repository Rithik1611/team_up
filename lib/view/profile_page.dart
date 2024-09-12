import 'package:flutter/material.dart';
import 'package:team_up/models/student.dart';
import 'package:team_up/view/edit_page.dart';

import 'social_media_page.dart';
import 'leader_board_page.dart';
import 'honour_score_page.dart';

class ProfilePage extends StatefulWidget {
  final Student student;
  const ProfilePage({super.key, required this.student});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Student _student;

  @override
  void initState() {
    super.initState();
    _student = widget.student; // Initialize the _student variable here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 49, 0, 128),
        title: const Text("Profile"),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final updatedStudent = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditPage(student: _student),
                ),
              );

              if (updatedStudent != null) {
                setState(() {
                  _student = updatedStudent;
                });
              }
            },
          ),
        ],
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
                    backgroundImage: _student.profilePic.path.isNotEmpty
                        ? FileImage(_student.profilePic)
                        : const AssetImage('assets/profile_image.png')
                            as ImageProvider,
                    backgroundColor: const Color.fromARGB(255, 137, 137, 137),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _student.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        '${_student.year} Year',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        _student.department,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        _student.section,
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
                children: _student.skills
                    .map(
                      (skill) => Chip(
                        label: Text(
                          skill,
                          style: const TextStyle(color: Colors.white),
                        ),
                        backgroundColor:
                            const Color.fromARGB(255, 49, 0, 128),
                      ),
                    )
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
                children: _student.interests
                    .map(
                      (interest) => Chip(
                        label: Text(
                          interest,
                          style: const TextStyle(color: Colors.white),
                        ),
                        backgroundColor:
                            const Color.fromARGB(255, 49, 0, 128),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 20),

              // Reports Section
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'My Reports:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Report components in a single column
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10), // Add spacing between ListTiles
                  
                  // Social Media Handles (Navigates to SocialMediaPage)
                  _buildReportTile(
                    icon: Icons.link,
                    title: 'Social-Media Handles',
                    subtitle: "Put in your media handles here",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SocialMediaPage(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 10),

                  // Leader Board Rank (Navigates to LeaderBoardPage)
                  _buildReportTile(
                    icon: Icons.verified_user,
                    title: 'Leader-Board Rank',
                    subtitle:
                        'Rank this month- #7\nRank last month- #5\nPersonal Best- #2',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LeaderBoardPage(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 10),

                  // Honour Score (Navigates to HonourScorePage)
                  _buildReportTile(
                    icon: Icons.favorite,
                    title: 'Honour Score',
                    subtitle:
                        'This Score allows people to rate you for teamwork and ethics.',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HonourScorePage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper function to build clickable report ListTiles
  Widget _buildReportTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        tileColor: Colors.grey[200], // Background color for the tile
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        leading: Icon(icon, size: 30, color: Colors.black), // Leading icon
        trailing: const Icon(Icons.bookmark, color: Colors.black), // Bookmark icon
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
