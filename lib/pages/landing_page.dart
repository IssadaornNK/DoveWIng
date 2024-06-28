import 'package:flutter/material.dart';
//import 'login.dart';

// void main() {
//   runApp(DoveWingApp());
// }


class LandingPage extends StatelessWidget {
  const LandingPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blue,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                radius: 80,
                //backgroundImage: AssetImage('assets/dove.png'), // Ensure you have this image in your assets folder
              ),
              SizedBox(height: 20),
              Text(
                'DoveWing',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Empowering Change.\nTransforming Lives.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 40),
                ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
                style: ElevatedButton.styleFrom(
                  // primary: Colors.white, // background color
                  // onPrimary: Colors.blue, // text color
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                ),
                child: Text(
                  'Start',
                  style: TextStyle(
                    fontSize: 18,
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
