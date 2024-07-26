import 'dart:convert';
import 'dart:developer';
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
    if (token == null || token.isEmpty) {
      setState(() {
        errorMessage = 'No token found';
        isLoading = false;
      });
      return;
    }

    try {
      final userResponse = await http.get(
          Uri.parse('http://localhost:3307/user'),
          headers: {'Authorization': 'Bearer $token'});
      final donationResponse = await http.get(
          Uri.parse('http://localhost:3307/user/donations'),
          headers: {'Authorization': 'Bearer $token'});

      log('token: $token');
      log('User Response status: ${userResponse.statusCode}');
      log('Donation Response status: ${donationResponse.statusCode}');
      log('User Response body: ${userResponse.body}');
      log('Donation Response body: ${donationResponse.body}');

      if (userResponse.statusCode == 200 &&
          donationResponse.statusCode == 200) {
        final userData = jsonDecode(userResponse.body);
        final donationData = jsonDecode(donationResponse.body);
        List<Map<String, dynamic>> formattedDonations =
            List<Map<String, dynamic>>.from(donationData).map((donation) {
          // Parse the date string into a DateTime object
          DateTime originalDate = DateTime.parse(donation['date']);
          // Add one day to the original date
          DateTime newDate = originalDate.add(const Duration(days: 1));
          // Format the new date back to the desired string format
          String formattedDate = DateFormat('yyyy-MM-dd').format(newDate);

          return {...donation, 'date': formattedDate};
        }).toList();

        log('User Data: $userData');
        log('Donation Data: $donationData');

        setState(() {
          username = userData['username'];
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
              Navigator.pushNamedAndRemoveUntil(
                  context, '/home', (route) => false);
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('images/profile/loligirl.png')
                          as ImageProvider,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  username != '' ? username : 'No username found',
                  style: const TextStyle(fontSize: 24, color: Colors.blue),
                ),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Donated Campaign',
                    style: TextStyle(fontSize: 24, color: Colors.blue),
                  ),
                  TextButton(
                    onPressed: () {
                      // Handle "See more" button press
                      
                    },
                    child: const Text(
                      'See more',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  itemCount: pastDonations.length,
                  itemBuilder: (context, index) {
                    final donation = pastDonations[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListTile(
                          leading: SizedBox(
                            height: 50,
                            width: 50,
                            child: Image.asset(
                              donation['imgurl'],
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ),
                          title: Text(donation['name']!),
                          subtitle: Text(
                            '\$${donation['amount']} \nDate: ${donation['date']} (${donation['type']})',
                            style: const TextStyle(height: 1.5),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const Text(
                'FAQ',
                style: TextStyle(fontSize: 24, color: Colors.blue),
              ),
              const SizedBox(height: 16),
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
                      final prefs = await SharedPreferences.getInstance();
                      prefs.remove('token');
                      // ignore: use_build_context_synchronously
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
      ),
    );
  }
}
