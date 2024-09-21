import 'package:flutter/material.dart';
import 'package:team_up/app/app_pallete.dart';
import 'package:team_up/view/edit_social_page.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialMedia extends StatelessWidget {
  final String linkedinUrl = 'https://www.linkedin.com';
  final String githubUrl = 'https://github.com';
  final String portfolioUrl = 'https://yourportfolio.com';

  void _launchURL(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      print('Error launching URL: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch the URL')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppPallete.primary,
        title: Text('Social Media Links'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ListTile(
              tileColor: Colors.grey[200],
              leading: Icon(Icons.link),
              title: Text(
                'LinkedIn',
                style: TextStyle(color: Colors.blue),
              ),
              onTap: () => _launchURL(context, linkedinUrl),
            ),
            ListTile(
              leading: Icon(Icons.code),
              title: Text('GitHub'),
              onTap: () => _launchURL(context, githubUrl),
            ),
            ListTile(
              leading: Icon(Icons.web),
              title: Text('Portfolio'),
              onTap: () => _launchURL(context, portfolioUrl),
            ),
            SizedBox(height: 20), // Space between ListTiles and button
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EditSocialPage(
                            linkedinUrl: linkedinUrl,
                            githubUrl: githubUrl,
                            portfolioUrl: portfolioUrl,
                          )),
                );
              },
              child: Text('Add your Socials'),
            ),
          ],
        ),
      ),
    );
  }
}
