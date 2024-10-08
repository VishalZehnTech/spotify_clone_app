import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/src/models/log_in/log_Bloc/log_bloc.dart';
import 'package:spotify/src/models/home/ui/home_nav_bar_page.dart';
import 'package:spotify/src/models/log_in/ui/login_with_email.dart';
import 'package:spotify/src/models/sign_up/sign_up_page.dart';
import 'package:spotify/src/overrides.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        Overrides.spotify_ICON_PATH,
                        width: constraints.maxWidth * .16,
                      ),
                      const SizedBox(height: 20),
                      Text("Log in to spotify",
                          style: _commanTextStyle(), textAlign: TextAlign.center),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 15),
                    Container(
                      height: 50,
                      decoration: _commonButtonBoxDecoration().copyWith(
                        border: Border.all(),
                        color: const Color.fromARGB(255, 64, 192, 68),
                      ),
                      child: _commonButtonTitleAndIcon(
                          titleText: "Continue with email",
                          imagePath: Overrides.EMAIL_IMAGE_PATH,
                          onTapDestination: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginWithEmail(),
                              ),
                            );
                          },
                          colorName: Colors.black),
                    ),
                    const SizedBox(height: 15),
                    BlocListener<LogBloc, LogState>(
                      listener: (BuildContext context, LogState state) {
                        if (state.loginStatus == LoginStatus.success) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomeNavBarPage(),
                            ),
                          );
                        }
                        
                      },
                      child: BlocBuilder<LogBloc, LogState>(
                        builder: (BuildContext context, LogState state) {
                          return Container(
                            height: 50,
                            decoration: _commonButtonBoxDecoration(),
                            child: _commonButtonTitleAndIcon(
                              titleText: "Continue with Google",
                              imagePath: Overrides.GOOGLE_IMAGE_PATH,
                              onTapDestination: () async {
                                context.read<LogBloc>().add(
                                      const LogAPI(
                                        email: "",
                                        password: "",
                                        logFieldStatus: LogFieldStatus.signInGoogle,
                                      ),
                                    );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 30),
                    Center(
                      child: Text(
                        "Don't have an account?",
                        style:
                            _commanTextStyle().copyWith(fontSize: 15, fontWeight: FontWeight.w700),
                      ),
                    ),
                    TextButton(
                      child: const Text(
                        "Sign up",
                        style: TextStyle(
                            color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const SignUpPage()),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  InkWell _commonButtonTitleAndIcon(
      {required String titleText,
      required String imagePath,
      required onTapDestination,
      Color colorName = Colors.white}) {
    return InkWell(
      onTap: onTapDestination,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Image.network(
                imagePath,
                width: 23,
                height: 23,
                // fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: Text(
              titleText,
              style: TextStyle(
                color: colorName,
                fontSize: 16.5,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          // Ensures the text stays centered
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  BoxDecoration _commonButtonBoxDecoration() {
    return BoxDecoration(
      border: Border.all(
        color: Colors.grey,
        width: 0.6,
      ),
      borderRadius: BorderRadius.circular(25),
    );
  }

  TextStyle _commanTextStyle() {
    return const TextStyle(
      color: Colors.white,
      fontSize: 31,
      decoration: TextDecoration.none,
      fontWeight: FontWeight.bold,
    );
  }
}
