// ignore_for_file: use_build_context_synchronously
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  String _username = '';
  String _password = '';
  String errorMessage = '';

  void _login() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Handle form submission
      if (kDebugMode) {
        print('Form Submitted');
        print('Username: $_username');
        print('Password: $_password');
      }

      final response = await http.post(
        Uri.parse('http://localhost:3307/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'Email': _username,
          'Password': _password,
        }),
      );

      if (response.statusCode == 200) {
        // Login successful
        final data = jsonDecode(response.body);
        final token = data['token'] ?? '';
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User logged in successfully')));
        Navigator.pushNamed(context, '/home');
      } else {
        // Login failed
        setState(() {
          errorMessage = 'Invalid credentials';
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Failed to logged in user, try again')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // First part with white background and centered text
          Container(
            color: Colors.white,
            width: double.infinity,
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'DoveWing',
                  style: GoogleFonts.inika(
                    fontWeight: FontWeight.bold,
                    fontSize: 36,
                    color: const Color.fromARGB(255, 5, 119, 208),
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  'Hi there!',
                  style: GoogleFonts.inika(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: const Color.fromARGB(255, 5, 119, 208),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Let's get started",
                  style: GoogleFonts.inika(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: const Color.fromARGB(255, 5, 119, 208),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          // Second part with blue background and rounded borders
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFF45A5FD),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      // Username TextField
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(
                              color: Color.fromARGB(255, 5, 119, 208)),
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: Icon(Icons.person_outlined,
                              color: Color.fromARGB(255, 5, 119, 208)),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.0)),
                              borderSide: BorderSide(
                                color: Color.fromARGB(255, 5, 119, 208),
                                width: 1.0,
                              )),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your username';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _username = value!;
                        },
                      ),
                      const SizedBox(height: 16),
                      // Password TextField
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(
                              color: Color.fromARGB(255, 5, 119, 208)),
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: Icon(Icons.key,
                              color: Color.fromARGB(255, 5, 119, 208)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide.none,
                          ),
                          // obscureText: true,
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (!RegExp(
                                  r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&_*~]).{8,}$')
                              .hasMatch(value)) {
                            return 'Password must contain at least one uppercase letter, one lowercase letter, one number, one special character, and the lenght should at least be 8';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _password = value!;
                        },
                      ),
                      const SizedBox(height: 40),
                      // Login Button
                      ElevatedButton(
                        onPressed: _login,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 16),
                          backgroundColor: Colors.white,
                        ),
                        child: Text(
                          'Login',
                          style: GoogleFonts.inika(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: const Color.fromARGB(255, 5, 119, 208),
                          ),
                        ),
                      ),
                      if (errorMessage.isNotEmpty) ...[
                        const SizedBox(height: 20),
                        Text(
                          errorMessage,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ],
                      const SizedBox(height: 20),

                      // OR separator
                      const Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: Colors.black,
                              thickness: 1,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              'Or',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: Colors.black,
                              thickness: 1,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Create an Account Button
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/register');
                        },
                        style: ElevatedButton.styleFrom(
                          side: const BorderSide(color: Colors.white, width: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 16),
                          backgroundColor: const Color(0xFF45A5FD),
                        ),
                        child: Text(
                          'Create Account',
                          style: GoogleFonts.inika(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
