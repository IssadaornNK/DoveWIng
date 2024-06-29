import 'package:flutter/material.dart';
import '../models/user_model.dart';  // Update the import path
import '../services/user_service.dart';  // Update the import path

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<User> futureUser;

  @override
  void initState() {
    super.initState();
    futureUser = UserService().fetchUserData();
  }

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
      body: FutureBuilder<User>(
        future: futureUser,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No data available'));
          } else {
            final user = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(user.profilePictureUrl),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Text(
                      user.username,
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
                      itemCount: user.pastDonations.length,
                      itemBuilder: (context, index) {
                        final donation = user.pastDonations[index];
                        return ListTile(
                          title: Text('Amount: ${donation.amount}'),
                          subtitle: Text('Date: ${donation.date} (${donation.type})'),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
