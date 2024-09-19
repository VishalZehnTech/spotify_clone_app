import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotify/src/models/home/ui/home_nav_bar_page.dart';
import 'package:spotify/src/overrides.dart';
import 'package:spotify/src/widgets/login_signup_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus(); // Check login status when the widget is initialized
  }

  // Checks if the user is logged in and navigates to the appropriate page
  Future<void> _checkLoginStatus() async {
    // Simulate a delay for the splash screen
    await Future.delayed(const Duration(milliseconds: 2050));

    // Retrieve SharedPreferences instance
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Check if the user is logged in based on SharedPreferences value
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    // Navigate to the homepage if logged in, otherwise to the login/signup page
    if (isLoggedIn) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeNavBarPage()),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginSignupPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        // Display the Spotify icon at the center of the splash screen
        child: Image.asset(Overrides.spotify_ICON_PATH, width: 150),
      ),
    );
  }
}
