import 'package:flutter/material.dart';

class TeamDetailPage extends StatelessWidget {
  final Map<String, dynamic> team;

  const TeamDetailPage({Key? key, required this.team}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(team['name'] ?? 'Team Details'),
        backgroundColor: const Color.fromARGB(255, 49, 0, 128),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Team Name: ${team['name'] ?? 'N/A'}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Description: ${team['description'] ?? 'No Description'}',
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 20),
            // Add more fields if available in the API
            // Example:
            Text(
              'Founded Year: ${team['foundedYear'] ?? 'N/A'}',
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
