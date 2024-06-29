import 'package:flutter/material.dart';
import 'pages/landing_page.dart';
import 'pages/login.dart';
import 'pages/homepage.dart';
import 'pages/register.dart';
import 'pages/profile.dart';

void main() {
  runApp(const DoveWingApp());
}

class DoveWingApp extends StatelessWidget {
  const DoveWingApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DoveWing',
      theme: ThemeData(
        primarySwatch: Colors.blue,
         elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue, // Set the button's background color to blue
            foregroundColor: Colors.white, // Set the button's text color to white
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LandingPage(),
        '/login':(context) => const LoginPage(),
        '/register':(context) => const RegisterPage(),
        '/home':(context) => const HomePage(),
        '/campaign': (context) => const CampaignPage(),
        '/profile':(context) => const ProfilePage(),
        }
    );
  }
}

