import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Example past donations;
  String username = '';
  String errorMessage = '';
  String profilePicturePath =
      'images/profile/loligirl.png';
  bool isLoading = true;
  List<Map<String, dynamic>> pastDonations = [];

  @override
  void initState() {
    super.initState();
    fetchProfileData();
  }

  Future<void> fetchProfileData() async {
  setState(() {
    isLoading = true;
    errorMessage = '';
  });

  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');
  // final donationId = prefs.getInt('donationId');
  if (token == null || token.isEmpty) {
    setState(() {
      errorMessage = 'No token found';
      isLoading = false;
    });
    return;
  }

  try {
    final userResponse = await http.get(Uri.parse('http://localhost:3307/user'),
        headers: {'Authorization': 'Bearer $token'});
    final donationResponse = await http.get(Uri.parse('http://localhost:3307/user/donations'),
        headers: {'Authorization': 'Bearer $token'});
    
    print('token: $token');
    print('User Response status: ${userResponse.statusCode}');
    print('Donation Response status: ${donationResponse.statusCode}');
    print('User Response body: ${userResponse.body}');
    print('Donation Response body: ${donationResponse.body}');

    if (userResponse.statusCode == 200 && donationResponse.statusCode == 200) {
      final userData = jsonDecode(userResponse.body);
      final donationData = jsonDecode(donationResponse.body);
      List<Map<String, dynamic>> formattedDonations = List<Map<String, dynamic>>.from(donationData).map((donation) {
        return {
          ...donation,
          'date': DateFormat('yyyy-mm-dd').format(DateTime.parse(donation['date'])),
        };
      }).toList();

      print('User Data: $userData');
      print('Donation Data: $donationData');

      setState(() {
        username = userData['email'];
        pastDonations = formattedDonations;
        isLoading = false;
      });
    } else {
      final errorUserData = jsonDecode(userResponse.body);
      setState(() {
        errorMessage = 'Failed to load email: ${errorUserData['message']}';
        isLoading = false;
      });
    }
  } catch (e) {
    setState(() {
      errorMessage = 'Error: ${e.toString()}';
      isLoading = false;
    });
  }
}

  void _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    // await prefs.remove('donationId');
    Navigator.pop(context);
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      return false;
    },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.blue),
          title: const Text(
            'Profile',
            style: TextStyle(color: Colors.blue),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
            },
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
                backgroundImage: NetworkImage(profilePicturePath),
                onBackgroundImageError: (error, stackTrace) {
                  print('Error loading image: $error');
                  setState(() {
                    profilePicturePath =
                        'images/profile/user.jpg'; // Fallback image 
                  });
                },
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
                    title: Text('${donation['name']} \$${donation['amount']}'),
                    subtitle:
                        Text('Date: ${donation['date']} (${donation['type']})'),
                  );
                },
              ),
            ),
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
                  onPressed: () async {
                    Navigator.pushNamed(context, '/login');
                  },
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
          ],
        ),
      ),
    ), );
    
  }
}
