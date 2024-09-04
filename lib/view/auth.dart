import 'package:flutter/material.dart';
import 'package:team_up/models/auth_remote.dart';
import 'package:team_up/view/form_page.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _name = '';
  String _email = '';
  String _password = '';

  final AuthViewModel _authViewModel = AuthViewModel();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _signup() async {
    bool isSuccess = await _authViewModel.signup(
      name: _name.trim(),
      email: _email.trim(),
      password: _password.trim(),
    );

    if (isSuccess) {
      // Delay to ensure token is saved before retrieval
      await Future.delayed(Duration(milliseconds: 500));
      final token = await _authViewModel.getToken();
      print('Token after signup: $token');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Signup successful')),
      );
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FormPage(),
          ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Signup failed')),
      );
    }
  }

  Future<void> _login() async {
    bool isSuccess = await _authViewModel.login(
      email: _email.trim(),
      password: _password.trim(),
    );

    if (isSuccess) {
      // Delay to ensure token is saved before retrieval
      await Future.delayed(Duration(milliseconds: 500));
      final token = await _authViewModel.getToken();
      print('Token after login: $token');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login successful')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Auth Page', style: TextStyle(color: Colors.white)),
        
        backgroundColor: Color.fromARGB(255, 49, 0, 128),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: [
            Tab(text: 'Signup'),
            Tab(text: 'Login'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildSignupForm(),
          _buildLoginForm(),
        ],
      ),
    );
  }

  Widget _buildSignupForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            decoration: InputDecoration(
              labelText: 'Name',
              labelStyle: TextStyle(color: Theme.of(context).primaryColor),
            ),
            onChanged: (value) {
              setState(() {
                _name = value;
              });
            },
          ),
          TextField(
            decoration: InputDecoration(
              labelText: 'Email',
              labelStyle: TextStyle(color: Theme.of(context).primaryColor),
            ),
            onChanged: (value) {
              setState(() {
                _email = value;
              });
            },
          ),
          TextField(
            decoration: InputDecoration(
              labelText: 'Password',
              labelStyle: TextStyle(color: Theme.of(context).primaryColor),
            ),
            obscureText: true,
            onChanged: (value) {
              setState(() {
                _password = value;
              });
            },
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _signup,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
            ),
            child: Text('Signup', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            decoration: InputDecoration(
              labelText: 'Email',
              labelStyle: TextStyle(color: Theme.of(context).primaryColor),
            ),
            onChanged: (value) {
              setState(() {
                _email = value;
              });
            },
          ),
          TextField(
            decoration: InputDecoration(
              labelText: 'Password',
              labelStyle: TextStyle(color: Theme.of(context).primaryColor),
            ),
            obscureText: true,
            onChanged: (value) {
              setState(() {
                _password = value;
              });
            },
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _login,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
            ),
            child: Text('Login', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
