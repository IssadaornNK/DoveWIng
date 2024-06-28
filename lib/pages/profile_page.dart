// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:dove_wings/server/services/api_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ApiService apiService = ApiService();
  String email = '';
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchEmail();
  }

   Future<void> fetchEmail() async {
    try {
      final fetchedEmail = await apiService.getEmail();
      setState(() {
        email = fetchedEmail;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });
    }
  }

  void _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    Navigator.pop(context);
    Navigator.pushNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: const Color.fromARGB(255, 5, 119, 208),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'DoveWing',
          style: GoogleFonts.inika(
            textStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 5, 119, 208),
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Color.fromARGB(255, 5, 119, 208),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage(
                      'images/pic1'), // Replace with your image asset
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: isLoading
                    ? const CircularProgressIndicator()
                    : errorMessage.isNotEmpty
                        ? Text(
                            'Error: $errorMessage',
                            style: const TextStyle(color: Colors.red),
                          )
                        : Text(
                            email,
                            style: GoogleFonts.inika(
                              textStyle: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 5, 119, 208),
                              ),
                            ),
                          ),
              ),
              const SizedBox(height: 20),
              const Divider(
                color: Color.fromARGB(255, 5, 119, 208),
                thickness: 0,
              ),
              const SizedBox(height: 10),
              Text(
                'Badges',
                style: GoogleFonts.inika(
                  textStyle: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 5, 119, 208),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: List.generate(3, (index) {
                  return CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.grey.shade300,
                    child: Text(
                      'B${index + 1}',
                      style: GoogleFonts.inika(
                        textStyle: const TextStyle(
                          color: Color.fromARGB(255, 5, 119, 208),
                        ),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Donated Campaign',
                    style: GoogleFonts.inika(
                      textStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 5, 119, 208),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/donated');
                    },
                    child: Text(
                      'See more',
                      style: GoogleFonts.inika(
                        textStyle: const TextStyle(
                          fontSize: 14,
                          color: Color.fromARGB(255, 5, 119, 208),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Image(
                      image: AssetImage(
                          'images/campaign.jpg'), // Replace with your campaign image asset
                      height: 100,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Campaign Name',
                      style: GoogleFonts.inika(
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 5, 119, 208),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Details about the donated campaign go here.',
                      style: GoogleFonts.inika(
                        textStyle: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'FAQ',
                style: GoogleFonts.inika(
                  textStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 5, 119, 208),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(
                          255, 5, 119, 208), // background color
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: _logout,
                    child: Text(
                      'Logout',
                      style: GoogleFonts.inika(
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
