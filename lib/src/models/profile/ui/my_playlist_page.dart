import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/src/models/log_in/log_Bloc/log_bloc.dart';
import 'package:spotify/src/models/library/bloc/library_bloc.dart';
import 'package:spotify/src/models/music/ui/music_player.dart';

class MyPlaylistPage extends StatefulWidget {
  const MyPlaylistPage({super.key});

  @override
  State<MyPlaylistPage> createState() => _MyPlaylistPageState();
}

class _MyPlaylistPageState extends State<MyPlaylistPage> {
  @override
  void initState() {
    super.initState();
    context.read<LibraryBloc>().add(GetMusicModel());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 129, 114, 114),
              Colors.black,
            ],
          ),
        ),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              automaticallyImplyLeading: false,
              backgroundColor:
                  // const Color.fromARGB(255, 94, 80, 80),
                  const Color.fromARGB(255, 73, 69, 69),

              floating: false,
              pinned: false, // Keep the app bar pinned when collapsed
              expandedHeight: 300, // Set the maximum expanded height
              flexibleSpace: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  var maxHeight = constraints.biggest.height;
                  var minHeight = kToolbarHeight;
                  var shrinkFactor = (maxHeight - minHeight) / (300 - minHeight);

                  // Scale the image based on shrinkFactor (clamp ensures value stays within range)
                  var imageHeight = (250 * shrinkFactor).clamp(0.0, 250.0);
                  var opacity = shrinkFactor.clamp(0.0, 1.0); // Adjust opacity as it shrinks

                  return Stack(
                    children: [
                      Positioned(
                        top: (maxHeight / 2) - (imageHeight / 2.15), // Center the image vertically
                        left: MediaQuery.of(context).size.width / 2 -
                            (imageHeight / 2.0), // Center horizontally
                        child: Opacity(
                          opacity: opacity, // Make the image disappear smoothly
                          child: Image.network(
                            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTx7FFDj-v33JeL6WouATSburUEsbSuD9G5ug&s",
                            height: imageHeight, // Dynamically scale the height
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        // Align the back button at the top
                        top: MediaQuery.of(context).padding.top,
                        left: 0,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back, size: 30),
                          onPressed: () {
                            context.read<LibraryBloc>().add(GetPlayListLength());
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            BlocBuilder<LogBloc, LogState>(
              builder: (context, state) {
                return SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0, top: 15),
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "My playlist #1",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 10, // Set the radius of the CircleAvatar
                              child: ClipOval(
                                child: Image.network(
                                  "${state.userModel?.photoUrl}",
                                  width: 100, // Adjust the width as necessary
                                  height: 100, // Adjust the height as necessary
                                  fit: BoxFit.cover,
                                  // Ensure the image fills the CircleAvatar properly
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "${state.userModel?.name}",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Text("Album • 2024"),
                        // const SizedBox(height: 10),
                        SizedBox(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                      onPressed: () {},
                                      icon: const Icon(Icons.person_add_outlined, size: 30)),
                                  const SizedBox(width: 10),
                                  IconButton(
                                      onPressed: () {},
                                      icon: const Icon(Icons.share_outlined, size: 30)),
                                  IconButton(
                                      onPressed: () {},
                                      icon: const Icon(Icons.more_vert, size: 30)),
                                ],
                              ),
                              Row(
                                children: [
                                  IconButton(
                                      onPressed: () {}, icon: const Icon(Icons.shuffle, size: 25)),
                                  IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.play_circle_filled_rounded,
                                      color: Color.fromARGB(255, 4, 255, 12),
                                      size: 55,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {},
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 15.0),
                            child: Row(
                              children: [
                                Container(
                                  height: 45,
                                  width: 45,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: const Color.fromARGB(255, 61, 58, 58),
                                  ),
                                  child: const Icon(Icons.add, color: Colors.grey, size: 35),
                                ),
                                const SizedBox(width: 10),
                                const Text(
                                  "Add to this playlist",
                                  style: TextStyle(fontSize: 18, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
            BlocBuilder<LibraryBloc, LibraryState>(
              builder: (context, state) {
                if (state is LibraryLoading) {
                  return const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else if (state is LibraryFailded) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Text(state.message,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                  );
                } else if (state is LibraryLoaded) {
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        final musicModel = state.musicModel[index];
                        return Column(
                          children: [
                            ListTile(
                              contentPadding: const EdgeInsets.only(left: 20),
                              title: Column(
                                children: [
                                  Row(
                                    children: [
                                      Image.network(musicModel.themePath ?? "URL Missing",
                                          height: 50, width: 50),
                                      const SizedBox(width: 10),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            musicModel.songName ?? "Unknown Song",
                                            style: const TextStyle(
                                                color: Colors.white, fontWeight: FontWeight.bold),
                                          ),
                                          Text(musicModel.singerName ?? "Unknown Singer",
                                              style: const TextStyle(color: Colors.grey)),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width - 10,
                                    child: const Text(
                                      "Title : Check the Widget Tree: Identify the parent and child widgets around where the error is happening and make sure the layout rules are being followed.",
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 13, color: Colors.grey),
                                    ),
                                  ),
                                ],
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 10.0, bottom: 5, right: 15),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    // const Text("Yo Yo Honey Singh"),
                                    const Row(
                                      children: [
                                        Icon(Icons.download_for_offline_outlined, size: 30),
                                        SizedBox(width: 15),
                                        Icon(Icons.share_outlined, size: 30),
                                        SizedBox(width: 15),
                                        Icon(Icons.more_vert, size: 30),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.play_circle, size: 39),
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        MusicPlayerPage(musicModel: musicModel)));
                                          },
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 12.0, right: 12),
                              child: Divider(
                                color: Color.fromARGB(255, 102, 93, 93),
                                thickness: .5,
                              ),
                            ),
                          ],
                        );
                      },
                      childCount: state.musicModel.length,
                    ),
                  );
                } else if (state is LibraryError) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Text(state.message),
                    ),
                  );
                } else {
                  return const SliverFillRemaining(
                    child: Center(child: Text("Unknown state")),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
