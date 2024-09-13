import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/src/log_Bloc/log_bloc.dart';
import 'package:spotify/src/widgets/Splash_Screen.dart';

class SettingPrivacyPage extends StatelessWidget {
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
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.search))],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: settingItem.length + 1,
              itemBuilder: (context, index) {
                if (index < settingItem.length) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 20.0, top: 20, bottom: 15),
                    child: Text(
                      settingItem[index],
                      style: const TextStyle(
                          fontSize: 17, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  );
                } else {
                  return BlocListener<LogBloc, LogState>(
                    listener: (context, state) {
                      if (state.loginStatus == LoginStatus.init) {
                        Navigator.pushReplacement(
                            context, MaterialPageRoute(builder: (context) => const SplashPage()));
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 40),
                      child: TextButton(
                        onPressed: () {
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
