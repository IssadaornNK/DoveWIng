// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:dove_wings/server/services/api_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';

class ProfilePage extends StatelessWidget {
  final String username = 'User123'; // Example username
  final String profilePictureUrl = 'https://via.placeholder.com/150'; // Example profile picture URL
  final List<Map<String, dynamic>> pastDonations = [
    {'date': '2023-01-01', 'amount': '\$2.59', 'type': 'One-time'},
    {'date': '2023-02-01', 'amount': '\$0.49', 'type': 'Monthly'},
    {'date': '2023-03-01', 'amount': '\$0.49', 'type': 'Monthly'},
  ]; // Example past donations

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.blue),
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.blue),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(profilePictureUrl),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                username,
                style: const TextStyle(fontSize: 24, color: Colors.blue),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Past Donations',
              style: TextStyle(fontSize: 18, color: Colors.blue),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: pastDonations.length,
                itemBuilder: (context, index) {
                  final donation = pastDonations[index];
                  return ListTile(
                    title: Text('Amount: ${donation['amount']}'),
                    subtitle: Text('Date: ${donation['date']} (${donation['type']})'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
