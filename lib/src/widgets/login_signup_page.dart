import 'package:flutter/material.dart';
import 'package:spotify/src/models/log_in/ui/log_in_page.dart';
import 'package:spotify/src/models/sign_up/sign_up_page.dart';
import 'package:spotify/src/overrides.dart';

class LoginSignupPage extends StatefulWidget {
  const LoginSignupPage({super.key});

  @override
  State<LoginSignupPage> createState() => _LoginSignupPageState();
}

class _LoginSignupPageState extends State<LoginSignupPage> {
  void pageNavigator(
      // onTapDestination,
      ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SignUpPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    Overrides.spotify_ICON_PATH,
                    width: 65,
                  ),
                  const SizedBox(height: 15),
                  Text(
                    "Millions of songs.\nFree on spotify.",
                    style: _commanTextStyle(),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  decoration: _commanBoxDecoration().copyWith(
                      color: const Color.fromARGB(255, 64, 192, 68), border: Border.all()),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignUpPage(),
                        ),
                      );
                    },
                    child: Text(
                      "Sign up free",
                      style: _textStyleForButton().copyWith(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: _commanBoxDecoration(),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LogInPage(),
                        ),
                      );
                    },
                    // onPressed: pageNavigator,
                    child: Text(
                      "Log in",
                      style: _textStyleForButton(),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
              ],
            ),
          ],
        ),
      ),
    );
  }

  TextStyle _textStyleForButton() {
    return const TextStyle(
      color: Colors.white,
      fontSize: 17,
      fontWeight: FontWeight.bold,
    );
  }

  BoxDecoration _commanBoxDecoration() {
    return BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white, width: .5));
  }

  TextStyle _commanTextStyle() {
    return const TextStyle(
      color: Colors.white,
      fontSize: 30,
      decoration: TextDecoration.none,
      fontWeight: FontWeight.bold,
    );
  }
}
