import 'package:flutter/material.dart';
import 'package:spotify/src/models/log_in/ui/log_in_page.dart';
import 'package:spotify/src/models/sign_up/sign_up_page.dart';
import 'package:spotify/src/overrides.dart';

// This page provides options to either log in or sign up for the app.
class LoginSignupPage extends StatefulWidget {
  const LoginSignupPage({super.key});

  @override
  State<LoginSignupPage> createState() => _LoginSignupPageState();
}

class _LoginSignupPageState extends State<LoginSignupPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Set background color to black
      body: Padding(
        padding: const EdgeInsets.all(25.0), // Add padding around the content
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Distribute space evenly
          crossAxisAlignment:
              CrossAxisAlignment.stretch, // Stretch children to fill available width
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, // Center the content vertically
                children: [
                  Image.asset(
                    Overrides.spotify_ICON_PATH, // Load the Spotify icon
                    width: 65, // Set width of the icon
                  ),
                  const SizedBox(height: 15), // Add spacing between icon and text
                  Text(
                    "Millions of songs.\nFree on spotify.", // Main text of the page
                    style: _commanTextStyle(), // Apply text style
                    textAlign: TextAlign.center, // Center align the text
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch, // Stretch buttons to fill width
              children: [
                Container(
                  decoration: _commanBoxDecoration().copyWith(
                      color: const Color.fromARGB(255, 64, 192, 68), // Set background color
                      border: Border.all()), // Add border
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignUpPage(), // Navigate to SignUpPage
                        ),
                      );
                    },
                    child: Text(
                      "Sign up free", // Button text
                      style: _textStyleForButton().copyWith(
                        color: Colors.black, // Set text color to black
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20), // Add spacing between buttons
                Container(
                  decoration: _commanBoxDecoration(), // Apply common decoration
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LogInPage(), // Navigate to LogInPage
                        ),
                      );
                    },
                    child: Text(
                      "Log in", // Button text
                      style: _textStyleForButton(), // Apply text style
                    ),
                  ),
                ),
                const SizedBox(height: 25), // Add spacing at the bottom
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Text style for buttons with white color and bold font
  TextStyle _textStyleForButton() {
    return const TextStyle(
      color: Colors.white,
      fontSize: 17,
      fontWeight: FontWeight.bold,
    );
  }

  // Common box decoration for buttons with rounded corners and border
  BoxDecoration _commanBoxDecoration() {
    return BoxDecoration(
        borderRadius: BorderRadius.circular(30), // Rounded corners
        border: Border.all(color: Colors.white, width: .5)); // Border color and width
  }

  // Common text style with white color and bold font
  TextStyle _commanTextStyle() {
    return const TextStyle(
      color: Colors.white,
      fontSize: 30,
      decoration: TextDecoration.none, // No text decoration
      fontWeight: FontWeight.bold,
    );
  }
}
