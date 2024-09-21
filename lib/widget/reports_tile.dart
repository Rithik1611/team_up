import 'package:flutter/material.dart';

class ReportTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const ReportTile({
    Key? key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        tileColor: Colors.grey[200],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        leading: Icon(icon, size: 30, color: Colors.black),
        trailing: const Icon(Icons.bookmark, color: Colors.black),
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
