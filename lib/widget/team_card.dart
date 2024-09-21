import 'package:flutter/material.dart';

class TeamCard extends StatelessWidget {
  final String teamName;
  final VoidCallback onTap;

  const TeamCard({
    Key? key,
    required this.teamName,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.9),
      child: InkWell(
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 8),
                Text(
                  teamName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color.fromARGB(255, 49, 0, 128),
                const Color.fromARGB(255, 7, 3, 3)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(29),
            ),
          ),
          height: 200,
          width: MediaQuery.of(context).size.width * 0.9,
        ),
      ),
    );
  }
}
