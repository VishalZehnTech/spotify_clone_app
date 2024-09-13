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
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    // Simulate splash screen delay
    await Future.delayed(const Duration(milliseconds: 2050));

    // Check if user is logged in
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    // Navigate to homepage if logged in, otherwise to login/signup page
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
        // child: Image.network(Overrides.spotify_ICON_PATH, width: 150),
        child: Image.asset(Overrides.spotify_ICON_PATH, width: 150),
      ),
    );
  }
}
