import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';

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
  String profileImageUrl = '';

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
          DateTime newDate = originalDate.add(Duration(days: 1));
          // Format the new date back to the desired string format
          String formattedDate = DateFormat('yyyy-MM-dd').format(newDate);

          return {...donation, 'date': formattedDate};
        }).toList();

        log('User Data: $userData');
        log('Donation Data: $donationData');

        setState(() {
          username = userData['username'];
          pastDonations = formattedDonations;
          profileImageUrl =
              userData['profileImageUrl'] ?? 'images/profile/user.jpg';
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

  Future<void> uploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return;

    final file = File(pickedFile.path);
    final fileName = pickedFile.name;
    final storageRef =
        FirebaseStorage.instance.ref().child('profile_images/$fileName');

    try {
      await storageRef.putFile(file);
      final downloadUrl = await storageRef.getDownloadURL();

      setState(() {
        profileImageUrl = downloadUrl;
      });

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token != null) {
        final response = await http.put(
          Uri.parse('http://localhost:3307/user/profile-image'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token'},
          body: jsonEncode({'profileImageUrl': downloadUrl}),
        );
        if (response.statusCode == 200) {
          log('Profile image updated successfully');
        } else {
          log('Failed to update profile image: ${response.body}');
        }
      }
    } catch (e) {
      log('Failed to upload image: $e');
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
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: profileImageUrl.isNotEmpty
                          ? NetworkImage(profileImageUrl)
                          : const AssetImage('images/profile/loligirl.png')
                              as ImageProvider,
                    ),
                    Positioned(
                        child: IconButton(
                      icon: const Icon(Icons.camera_alt, color: Colors.blue),
                      onPressed: uploadImage,
                    ))
                  ],
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
                      title:
                          Text('${donation['name']} \$${donation['amount']}'),
                      subtitle: Text(
                          'Date: ${donation['date']} (${donation['type']})'),
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
      ),
    );
  }
}
