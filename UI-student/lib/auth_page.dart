import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool _isSignIn = true;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _affiliationController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  void _toggleForm() {
    setState(() {
      _isSignIn = !_isSignIn;
    });
  }

  Future<void> _signIn() async {
    final response = await http.post(
      Uri.parse('http://localhost:8082/api/student/signin'),
      body: {
        'email': _emailController.text,
        'password': _passwordController.text,
      },
    );

    print('Sign In Response: ${response.body}');
  }

  Future<void> _signUp() async {
    final Map<String, String> data = {
      'name': _nameController.text,
      'email': _emailController.text,
      'password': _passwordController.text,
      'affiliation': _affiliationController.text,
      'bio': _bioController.text,
    };

    final response = await http.post(
      Uri.parse('http://localhost:8082/api/student/signup'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );

    print('Sign Up Response: ${response.body}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 200),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Center(child: Text('Student authentication', style: TextStyle(fontSize: 42),)),
              const SizedBox(height: 15),
              if (!_isSignIn) ...[
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'name'),
                ),
                const SizedBox(height: 15),
              ],
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              const SizedBox(height: 15),
              if (!_isSignIn) ...[
                TextField(
                  controller: _affiliationController,
                  decoration: const InputDecoration(labelText: 'affiliation'),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: _bioController,
                  decoration: const InputDecoration(labelText: 'bio'),
                ),
                const SizedBox(height: 15),
              ],
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: _isSignIn ? _signIn : _signUp,
                child: Text(_isSignIn ? 'Sign In' : 'Sign Up'),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: _toggleForm,
                child: Text(_isSignIn
                    ? 'Do not have an account ? Create a new account'
                    : 'Already have an account ? Login to an existing account'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
