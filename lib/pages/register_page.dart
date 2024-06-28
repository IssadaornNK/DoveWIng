// ignore_for_file: use_build_context_synchronously
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  String _firstName = '';
  String _email = '';
  String _password = '';
  bool _isChecked = false;

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      if (!_isChecked) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Please accept our terms and conditions.')));
      } else {
        _formKey.currentState!.save();
        // Handle form submission
        if (kDebugMode) {
          print('Form Submitted');
          print('First Name: $_firstName');
          print('Email: $_email');
          print('Password: $_password');
        }
        final response = await http.post(
          Uri.parse('http://localhost:3307/api/auth/Register'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'FirstName': _firstName,
            'Email': _email,
            'Password': _password,
          }),
        );

        if (response.statusCode == 200) {
          // Registration successful
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('User registered successfully')));
          Navigator.pushNamed(context, '/login');
        } else {
          // Registration failed
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Failed to registered user, try again')));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // DoveWing Text
              const SizedBox(height: 40),
              Text(
                'DoveWing',
                style: GoogleFonts.inika(
                  fontWeight: FontWeight.bold,
                  fontSize: 36,
                  color: const Color.fromARGB(255, 5, 119, 208),
                ),
              ),
              const SizedBox(height: 40),
              // First Name Input
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'First Name',
                  labelStyle:
                      TextStyle(color: Color.fromARGB(255, 5, 119, 208)),
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: Icon(Icons.person_outline,
                      color: Color.fromARGB(255, 5, 119, 208)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 5, 119, 208)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 5, 119, 208)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 5, 119, 208)),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your first name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _firstName = value!;
                },
              ),
              const SizedBox(height: 30),
              // Email Input
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Email',
                  labelStyle:
                      TextStyle(color: Color.fromARGB(255, 5, 119, 208)),
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: Icon(Icons.email,
                      color: Color.fromARGB(255, 5, 119, 208)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 5, 119, 208)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 5, 119, 208)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 5, 119, 208)),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
                onSaved: (value) {
                  _email = value!;
                },
              ),
              const SizedBox(height: 30),
              // Password Input
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Password',
                  labelStyle:
                      TextStyle(color: Color.fromARGB(255, 5, 119, 208)),
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon:
                      Icon(Icons.key, color: Color.fromARGB(255, 5, 119, 208)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 5, 119, 208)),
                  ),
                  // obscureText: true,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 5, 119, 208)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 5, 119, 208)),
                  ),
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
              const SizedBox(height: 30),
              // Terms and Conditions Checkbox
              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Checkbox(
                  value: _isChecked,
                  activeColor: const Color.fromARGB(
                      255, 5, 119, 208), // Set the active color of the checkbox
                  onChanged: (value) {
                    setState(() {
                      _isChecked = value!;
                    });
                  },
                ),
                RichText(
                  text: const TextSpan(
                    text: 'Agree with ',
                    style: TextStyle(
                        color: Colors.black, fontSize: 16), // Normal text style
                    children: <TextSpan>[
                      TextSpan(
                        text: 'terms & conditions',
                        style: TextStyle(
                          color: Color.fromARGB(255, 5, 119,
                              208), // Blue text color for 'terms & conditions'
                          fontWeight: FontWeight
                              .bold, // Bold text style for 'terms & conditions'
                        ),
                      ),
                    ],
                  ),
                ),
              ]),

              const Spacer(),
              // Sign Up Button
              ElevatedButton(
                onPressed: _register,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  backgroundColor: const Color.fromARGB(255, 5, 119, 208),
                ),
                child: Text(
                  'Sign Up',
                  style: GoogleFonts.inika(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
