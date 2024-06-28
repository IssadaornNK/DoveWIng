import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 5, 119, 208),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo and "DoveWing"
            Container(
              width: 150,
              height: 150,
              decoration: const BoxDecoration(
    color: Colors.transparent, // Example color for the logo square
    shape: BoxShape.circle, // Set the shape to circle
  ),
              child: Center(
                child: ClipOval(child: Image.asset(
                  'images/pic1.jpg', // Path to your sample image
                  width: 217,
                  height: 217,
                  fit: BoxFit.cover,
                ),),
              ),
            ),
           const SizedBox(height: 20), // Space between logo and description
            // "DoveWing" text
            Text(
              'DoveWing',
              style: GoogleFonts.inika(
                fontWeight: FontWeight.bold,
                fontSize: 30,
                color: Colors.white,
              ),
            ),
           const SizedBox(height: 40), // Optional space between text and description
            // Description
            Text(
              'Empowering change.\nTransforming Lives.',
              style: GoogleFonts.inika(
               // fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
           const SizedBox(height: 120), // Space between description and button
            // Start Button
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding:const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
               // primary: Colors.white,
              ),
              child: Text(
                'Start',
                style: GoogleFonts.inika(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: const Color.fromARGB(255, 5, 119, 208),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
