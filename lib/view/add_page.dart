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

class _AddPageState extends State<AddPage> {
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

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 49, 0, 128),
        title: const Text('Add'),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
        ),
        itemCount: buttonNames.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              switch (index) {
                case 0:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateTeam(student: _student),
                    ),
                  );
                  break;
                case 1:
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const JoinTeam()),
                  );
                  break;
                case 2:
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Upload()),
                  );
                  break;
                case 3:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AdminControl()),
                  );
                  break;
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 49, 0, 128),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Center(
                child: Text(
                  buttonNames[index],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        },
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
