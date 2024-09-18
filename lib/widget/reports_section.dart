import 'package:flutter/material.dart';
import 'package:team_up/view/social_media_page.dart';
import 'package:team_up/view/leader_board_page.dart';
import 'package:team_up/view/honour_score_page.dart';
import 'package:team_up/widget/reports_tile.dart';

class ReportsSection extends StatelessWidget {
  const ReportsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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

        const SizedBox(height: 10),
        ReportTile(
          icon: Icons.link,
          title: 'Social-Media Handles',
          subtitle: 'Put in your media handles here',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SocialMediaPage()),
            );
          },
        ),
        const SizedBox(height: 10),

        ReportTile(
          icon: Icons.verified_user,
          title: 'Leader-Board Rank',
          subtitle: 'Rank this month- #7\nRank last month- #5\nPersonal Best- #2',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LeaderBoardPage()),
            );
          },
        ),
        const SizedBox(height: 10),

        ReportTile(
          icon: Icons.favorite,
          title: 'Honour Score',
          subtitle: 'This Score allows people to rate you for teamwork and ethics.',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HonourScorePage()),
            );
          },
        ),
      ],
    );
  }
}
