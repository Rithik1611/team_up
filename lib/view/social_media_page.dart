import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dio/dio.dart';

class SocialMediaPage extends StatefulWidget {
  const SocialMediaPage({Key? key}) : super(key: key);

  @override
  _SocialMediaPageState createState() => _SocialMediaPageState();
}

class _SocialMediaPageState extends State<SocialMediaPage> {
  // Dio instance for handling HTTP requests
  final Dio _dio = Dio();

  // Controllers to capture the input
  final TextEditingController _linkedInController = TextEditingController();
  final TextEditingController _githubController = TextEditingController();
  final TextEditingController _portfolioController = TextEditingController();

  // Variables to store saved URLs and track edit state
  String? _linkedInUrl;
  String? _githubUrl;
  String? _portfolioUrl;
  bool _isEditing = true;
  bool _isLoading = true;

  // Replace with your API URLs
  final String apiUrl = 'https://your-api-endpoint.com/social-media';

  @override
  void initState() {
    super.initState();
    _fetchSocialMediaLinks();
  }

  // Fetch existing social media links (GET request)
  Future<void> _fetchSocialMediaLinks() async {
    try {
      Response response = await _dio.get(apiUrl);
      if (response.statusCode == 200 && response.data != null) {
        if (mounted) {
          setState(() {
            _linkedInUrl = response.data['linkedIn'];
            _githubUrl = response.data['github'];
            _portfolioUrl = response.data['portfolio'];
            _linkedInController.text = _linkedInUrl ?? '';
            _githubController.text = _githubUrl ?? '';
            _portfolioController.text = _portfolioUrl ?? '';
            _isLoading = false;
          });
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to load social media links')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Save social media links (POST request)
  Future<void> _saveSocialMediaLinks() async {
    String linkedIn = _linkedInController.text.trim();
    String github = _githubController.text.trim();
    String portfolio = _portfolioController.text.trim();

    if (linkedIn.isNotEmpty && github.isNotEmpty && portfolio.isNotEmpty) {
      // Data to send to the server
      Map<String, String> data = {
        'linkedIn': linkedIn,
        'github': github,
        'portfolio': portfolio,
      };

      try {
        Response response = await _dio.post(apiUrl, data: data);

        if (response.statusCode == 200) {
          if (mounted) {
            setState(() {
              _linkedInUrl = linkedIn;
              _githubUrl = github;
              _portfolioUrl = portfolio;
              _isEditing = false;
            });

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Social media links saved successfully!')),
            );
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed to save links')),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill in all the fields.')),
        );
      }
    }
  }

  // Function to launch URLs
  Future<void> _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not launch URL')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Social Media Handles'),
        backgroundColor: const Color.fromARGB(255, 49, 0, 128),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Add your social media links below:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),

                  // LinkedIn URL field or link
                  _isEditing
                      ? _buildEditableField(
                          _linkedInController,
                          Icons.link,
                          'LinkedIn URL',
                          'Enter your LinkedIn profile link',
                        )
                      : _buildLinkDisplay(_linkedInUrl!, Icons.link),

                  const SizedBox(height: 20),

                  // GitHub URL field or link
                  _isEditing
                      ? _buildEditableField(
                          _githubController,
                          Icons.code,
                          'GitHub URL',
                          'Enter your GitHub profile link',
                        )
                      : _buildLinkDisplay(_githubUrl!, Icons.code),

                  const SizedBox(height: 20),

                  // Portfolio URL field or link
                  _isEditing
                      ? _buildEditableField(
                          _portfolioController,
                          Icons.web,
                          'Portfolio URL',
                          'Enter your portfolio link',
                        )
                      : _buildLinkDisplay(_portfolioUrl!, Icons.web),

                  const SizedBox(height: 30),

                  // Save or Edit Button
                  Center(
                    child: _isEditing
                        ? GFButton(
                            onPressed: _saveSocialMediaLinks,
                            text: 'Save Changes',
                            color: const Color.fromARGB(255, 49, 0, 128),
                            fullWidthButton: true,
                          )
                        : GFButton(
                            onPressed: () {
                              setState(() {
                                _isEditing = true; // Enable editing mode
                              });
                            },
                            text: 'Edit',
                            color: Colors.grey,
                            fullWidthButton: true,
                          ),
                  ),
                ],
              ),
            ),
    );
  }

  // Widget for displaying the editable text fields
  Widget _buildEditableField(
    TextEditingController controller,
    IconData icon,
    String label,
    String hint,
  ) {
    return Row(
      children: [
        GFIconButton(
          onPressed: () {},
          icon: Icon(icon),
          shape: GFIconButtonShape.circle,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: label,
              hintText: hint,
              border: const OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }

  // Widget for displaying clickable links with actual URL text
  Widget _buildLinkDisplay(String url, IconData icon) {
    return Row(
      children: [
        GFIconButton(
          onPressed: () => _launchUrl(url),
          icon: Icon(icon),
          shape: GFIconButtonShape.circle,
        ),
        const SizedBox(width: 10),
        Flexible(
          child: GestureDetector(
            onTap: () => _launchUrl(url),
            child: Text(
              url,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
              overflow: TextOverflow.ellipsis, // Add ellipsis if it overflows
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _linkedInController.dispose();
    _githubController.dispose();
    _portfolioController.dispose();
    super.dispose();
  }
}
