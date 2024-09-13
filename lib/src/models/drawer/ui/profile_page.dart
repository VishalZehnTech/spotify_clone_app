import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/src/log_Bloc/log_bloc.dart';
import 'package:spotify/src/models/drawer/ui/edit_profile_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.center,
            colors: [
              // Color.fromARGB(255, 209, 117, 117),
              Color.fromARGB(255, 33, 151, 248),
              Color.fromARGB(255, 19, 40, 58),
              Colors.black,
            ],
          ),
        ),
        child: BlocBuilder<LogBloc, LogState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  // padding: const EdgeInsets.all(8.0),
                  padding: const EdgeInsets.only(top: 30.0),
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                            // Navigator.pushAndRemoveUntil(context, newRoute, predicate)
                          },
                          icon: const Icon(Icons.arrow_back, size: 30, color: Colors.white)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: state.userModel?.photoUrl == null
                            ? const CircleAvatar(backgroundColor: Colors.black)
                            : Image.network("${state.userModel?.photoUrl}",
                                height: 110, width: 110, fit: BoxFit.cover),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0, bottom: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${state.userModel?.name}",
                              style: const TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width - 160,
                              child: Text(
                                "${state.userModel?.email}",
                                style: const TextStyle(color: Colors.white, fontSize: 16),
                                overflow:
                                    TextOverflow.ellipsis, // Adds ellipsis when text is too long
                                maxLines: 1,
                              ),
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              "0 followers • 15 following",
                              style: TextStyle(color: Colors.white, fontSize: 13),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                // const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0, bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => const EditProfilePage()));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white,
                              width: .5,
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.only(left: 15.0, right: 15, top: 7.0, bottom: 7),
                            child: Text(
                              "Edit",
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 15.0),
                  child: Row(
                    children: [
                      Text(
                        "PlayLists",
                        style: TextStyle(
                            fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0, top: 10),
                  child: Row(
                    children: [
                      Image.network("https://cdn-icons-png.flaticon.com/128/14807/14807181.png",
                          height: 45, width: 45),
                      const SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("My playlist #1",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 17, fontWeight: FontWeight.w400)),
                          // Text("${state.userModel!.playlist?.length} saves"),
                          Text("${state.userModel!.playlist?.length} saves"),
                        ],
                      )
                    ],
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
