import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/src/models/log_in/log_Bloc/log_bloc.dart';
import 'package:spotify/src/models/profile/bloc/profile_bloc.dart';
import 'package:spotify/src/models/profile/ui/edit_profile_page.dart';
import 'package:spotify/src/models/profile/ui/my_playlist_page.dart';
import 'package:spotify/src/models/library/bloc/library_bloc.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    // context.read<LogBloc>().add(GetUserData());
    context.read<LibraryBloc>().add(GetPlayListLength());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileSuccess) {
            context.read<LogBloc>().add(GetUserData());
          }
        },
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.center,
              colors: [
                Color.fromARGB(255, 33, 151, 248),
                Color.fromARGB(255, 19, 40, 58),
                Colors.black,
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.arrow_back, size: 30, color: Colors.white)),
                  ],
                ),
              ),
              BlocBuilder<LogBloc, LogState>(builder: (context, state) {
                return Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: state.userModel?.photoUrl == null
                            ? const CircleAvatar(backgroundColor: Colors.black)
                            : Image.network(
                                state.userModel?.photoUrl ??
                                    "https://imgs.search.brave.com/Tso5b-lOgqvrXcfgrknvzs0lqGmW_rXIwHjY3nkCBFI/rs:fit:500:0:0:0/g:ce/aHR0cHM6Ly9mcmVl/c3ZnLm9yZy9pbWcv/YWJzdHJhY3QtdXNl/ci1mbGF0LTQucG5n",
                                height: 110,
                                width: 110,
                                fit: BoxFit.cover),
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
                );
              }),
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
                      style:
                          TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25.0, top: 10),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => const MyPlaylistPage()));
                  },
                  child: Row(
                    children: [
                      Image.network("https://cdn-icons-png.flaticon.com/128/14807/14807181.png",
                          height: 45, width: 45),
                      const SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "My playlist #1",
                            style: TextStyle(
                                color: Colors.white, fontSize: 17, fontWeight: FontWeight.w400),
                          ),
                          BlocBuilder<LibraryBloc, LibraryState>(
                            builder: (context, state) {
                              return Text("${state.playListLength} saves");
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
