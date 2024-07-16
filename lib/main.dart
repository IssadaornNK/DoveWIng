import 'package:dove_wings/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'pages/landing_page.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/home_page.dart';
import 'pages/donated_page.dart';
import 'pages/payment_page.dart' as payment_page;
import 'pages/payment_method_page.dart' as payment_method_page;
import 'pages/payment_success_page.dart';
import 'pages/profile_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const DovewingApp());
}

class DovewingApp extends StatelessWidget {
  const DovewingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dovewing',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.inikaTextTheme(
          Theme.of(context).textTheme,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            textStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white, // Default text color for buttons
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LandingPage(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) => HomePage(),
        '/donated': (context) => const DonatedPage(),
        '/payment': (context) => const payment_page.PaymentPage(),
        '/payment_method': (context) => const payment_method_page.PaymentMethodPage(),
        '/payment_success': (context) => const PaymentSuccessPage(),
        '/profile': (context) => const ProfilePage(),
        '/campaign': (context) => const CampaignPage(),
      },
    );
  }
}
