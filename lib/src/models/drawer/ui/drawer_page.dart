import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/src/log_Bloc/log_bloc.dart';
import 'package:spotify/src/models/drawer/ui/profile_page.dart';
import 'package:spotify/src/models/drawer/ui/setting_privacy_page.dart';

class DrawerPage extends StatefulWidget {
  const DrawerPage({
    super.key,
  });

  @override
  State<DrawerPage> createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  @override
  void initState() {
    super.initState();
  }

  // Map<Icon, String> drawerItemMap = {};
  final Map<IconData, String> iconStringMap = {
    Icons.add: "Add account",
    Icons.bolt_rounded: "what's new",
    Icons.history_toggle_off_rounded: "Listening history",
    Icons.settings_outlined: "Setting and privacy",
  };

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
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
                      child: state.userModel?.photoUrl == null
                          ? const CircleAvatar(backgroundColor: Colors.black)
                          : Image.network(
                              // "assets/images/home/favorite_artists/Arjit_Singh.jpg",
                              // "https://lh3.googleusercontent.com/a/ACg8ocJWWmqHmhFVM66Smsyk41t5S4daBaz0HEiB3FciipPMtcniwqc7=s96-c",
                              "${state.userModel?.photoUrl}",
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
                          Text(
                            // 'Vishal Soner',
                            "${state.userModel?.name}",
                            // style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                          const Text(
                            'View profile',
                            style: TextStyle(
                              fontSize: 12,
                              // fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      // Navigator.pop(context); // Close the drawer
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ProfilePage()),
                        // (route) => route.isCurrent,
                      );
                    },
                  );
                },
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height - 150,
            child: ListView.builder(
              itemCount: 4,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.only(left: 18.0, bottom: 20),
                  child: InkWell(
                    onTap: () {
                      if (index == 3) {
                        Navigator.push(
                            context, MaterialPageRoute(builder: (context) => SettingPrivacyPage()));
                      }
                    },
                    child: Expanded(
                      child: Row(
                        children: [
                          Icon(
                            iconStringMap.keys.elementAt(index),
                            size: 30,
                            opticalSize: 0.1,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            iconStringMap.values.elementAt(index),
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 17,
                            ),
                          ),
                          // Text("Add account"),
                        ],
                      ),
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
