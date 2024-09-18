import 'package:flutter/material.dart';

class InterestsList extends StatelessWidget {
  final List<String> interests;

  const InterestsList({Key? key, required this.interests}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      children: interests
          .map(
            (interest) => Chip(
              label: Text(
                interest,
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: const Color.fromARGB(255, 49, 0, 128),
            ),
          )
          .toList(),
    );
  }
}
