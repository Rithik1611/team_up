import 'package:flutter/material.dart';

class LeaderBoardPage extends StatelessWidget {
  const LeaderBoardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leader-Board Rank'),
        backgroundColor: const Color.fromARGB(255, 49, 0, 128),
      ),
      body: Center(
        child: Text(
          'SOMETHING IS COOKING, PLEASE WAIT FOR THE NEXT UPDATE',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
