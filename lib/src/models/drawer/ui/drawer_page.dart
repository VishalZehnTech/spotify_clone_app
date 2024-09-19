import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/src/models/log_in/log_Bloc/log_bloc.dart';
import 'package:spotify/src/models/profile/ui/profile_page.dart';
import 'package:spotify/src/models/drawer/ui/setting_privacy_page.dart';

// DrawerPage is a stateful widget that displays a navigation drawer with various options.
class DrawerPage extends StatefulWidget {
  const DrawerPage({super.key});

  @override
  State<DrawerPage> createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  // Map containing icons and their corresponding labels for the drawer items.
  final Map<IconData, String> iconStringMap = {
    Icons.add: "Add account",
    Icons.bolt_rounded: "What's new",
    Icons.history_toggle_off_rounded: "Listening history",
    Icons.settings_outlined: "Settings and privacy",
  };

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // DrawerHeader containing user profile info
          SizedBox(
            height: 110,
            child: DrawerHeader(
              padding: EdgeInsets.zero,
              margin: EdgeInsets.zero,
              decoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              child: BlocBuilder<LogBloc, LogState>(
                builder: (context, state) {
                  return ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(30.0),
                      // Display a default avatar if photoUrl is null
                      child: state.userModel?.photoUrl == null
                          ? const CircleAvatar(backgroundColor: Colors.black)
                          : Image.network(
                              state.userModel!.photoUrl!,
                              height: 45,
                              width: 45,
                              fit: BoxFit.cover,
                            ),
                    ),
                    title: Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Display user name and "View profile" text
                          Text(
                            state.userModel?.name ?? '',
                            style: const TextStyle(fontSize: 25),
                          ),
                          const Text(
                            'View profile',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    // Navigate to ProfilePage when tapped
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ProfilePage()),
                      );
                    },
                  );
                },
              ),
            ),
          ),
          // ListView.builder to dynamically create drawer items
          SizedBox(
            height: MediaQuery.of(context).size.height - 150,
            child: ListView.builder(
              itemCount: iconStringMap.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.only(left: 18.0, bottom: 20),
                  child: InkWell(
                    // Navigate to SettingPrivacyPage when the "Settings and privacy" option is tapped
                    onTap: () {
                      if (index == 3) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SettingPrivacyPage()),
                        );
                      }
                    },
                    child: Row(
                      children: [
                        // Display the icon for each drawer item
                        Icon(
                          iconStringMap.keys.elementAt(index),
                          size: 30,
                        ),
                        const SizedBox(width: 10),
                        // Display the label for each drawer item
                        Text(
                          iconStringMap.values.elementAt(index),
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 17,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
