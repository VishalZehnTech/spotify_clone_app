import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/src/models/log_in/log_Bloc/log_bloc.dart';
import 'package:spotify/src/widgets/Splash_Screen.dart';

// SettingPrivacyPage is a stateless widget that displays various setting options and a logout button.
class SettingPrivacyPage extends StatelessWidget {
  // List of setting items to be displayed in the settings menu.
  final List<String> settingItem = [
    "Account",
    "Content and display",
    "Playback",
    "Devices",
    "Navigation & other apps",
    "Car",
    "Privacy and social",
    "Notification",
    "Local files",
    "Data-saving and offline",
    "Media quality",
    "Advertisements",
    "About"
  ];

  SettingPrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 61, 58, 58),
        centerTitle: true,
        title: const Text(
          "Settings",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
        ),
        // Search icon button in the AppBar
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.search))],
      ),
      body: Column(
        children: [
          // Expanded ListView to display the list of settings
          Expanded(
            child: ListView.builder(
              itemCount: settingItem.length + 1, // Add one for the logout button
              itemBuilder: (context, index) {
                if (index < settingItem.length) {
                  // Display each setting item
                  return Padding(
                    padding: const EdgeInsets.only(left: 20.0, top: 20, bottom: 15),
                    child: Text(
                      settingItem[index],
                      style: const TextStyle(
                          fontSize: 17, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  );
                } else {
                  // BlocListener for logout action
                  return BlocListener<LogBloc, LogState>(
                    listener: (context, state) {
                      if (state.logFieldStatus == LogFieldStatus.none) {
                        // Navigate to SplashPage and remove all previous routes
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const SplashPage()),
                          // This condition removes all previous routes
                          (Route<dynamic> route) => false,
                        );
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 40),
                      // Logout button
                      child: TextButton(
                        onPressed: () {
                          // Trigger logout event
                          context.read<LogBloc>().add(LogOutAPI());
                        },
                        child: Container(
                          height: 32,
                          width: 80,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: const Center(
                            child: Text("Log out",
                                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
