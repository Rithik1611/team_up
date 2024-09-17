import 'package:flutter/material.dart';
import 'package:team_up/models/student.dart';
import 'package:team_up/view/admin_control_page.dart';
import 'package:team_up/view/create_team.dart';
import 'package:team_up/view/get_verified_page.dart';
import 'package:team_up/view/join_team.dart';

class AddPage extends StatefulWidget {
  final Student student;
  const AddPage({super.key, required this.student});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> with TickerProviderStateMixin {
  late Student _student;

  @override
  void initState() {
    super.initState();
    _student = widget.student; // Initialize _student in initState
  }

  @override
  Widget build(BuildContext context) {
    final List<String> buttonNames = [
      'Create a team',
      'Join a Team',
      'Upload',
      'Admin Control'
    ];

    final List<IconData> buttonIcons = [
      Icons.group_add,
      Icons.group,
      Icons.upload_file,
      Icons.admin_panel_settings,
    ];

    final List<Widget> buttonPages = [
      CreateTeam(student: _student),
      const JoinTeam(),
      const Upload(),
      const AdminControl(),
    ];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 49, 0, 128),
        title: const Text('Add'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
          ),
          itemCount: buttonNames.length,
          itemBuilder: (context, index) {
            return _buildAnimatedGridButton(
              context,
              buttonNames[index],
              buttonIcons[index],
              index,
              buttonPages[index],
            );
          },
        ),
      ),
    );
  }

  Widget _buildAnimatedGridButton(
      BuildContext context, String title, IconData icon, int index, Widget page) {
    // Alternate left and right based on index
    bool isFromLeft = index % 2 == 0;

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: isFromLeft ? -500 : 500, end: 0),
      duration: Duration(milliseconds: 600 + (index * 100)), // Staggered animation
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(value, 0), // Horizontal offset
          child: child,
        );
      },
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [const Color.fromARGB(255, 49, 0, 128), const Color.fromARGB(255, 7, 3, 3)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            color: const Color.fromARGB(255, 0, 0, 0),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 40, color: Colors.white),
                const SizedBox(height: 10),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Separate pages for each button
class CreateTeam extends StatefulWidget {
  final Student student;
  const CreateTeam({super.key, required this.student});

  @override
  State<CreateTeam> createState() => _CreateTeamState();
}

class _CreateTeamState extends State<CreateTeam> {
  late Student _student;

  @override
  void initState() {
    super.initState();
    _student = widget.student; // Initialize the _student variable here
  }

  @override
  Widget build(BuildContext context) {
    return TeamInfoPage(student: _student);
  }
}

class JoinTeam extends StatelessWidget {
  const JoinTeam({super.key});

  @override
  Widget build(BuildContext context) {
    return TeamListPage();
  }
}

class Upload extends StatelessWidget {
  const Upload({super.key});

  @override
  Widget build(BuildContext context) {
    return GetVerifiedPage();
  }
}

class AdminControl extends StatelessWidget {
  const AdminControl({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminControlPage();
  }
}
