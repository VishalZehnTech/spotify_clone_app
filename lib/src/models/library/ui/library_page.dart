import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/src/models/drawer/ui/drawer_page.dart';
import 'package:spotify/src/models/library/bloc/library_bloc.dart';
import 'package:spotify/src/models/music/ui/music_player.dart';
import 'package:spotify/src/widgets/common_app_bar_leading.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    // Dispatch GetMusicModel event to fetch music models when the page is initialized
    context.read<LibraryBloc>().add(GetMusicModel());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      // Drawer for the Library page
      drawer: const DrawerPage(),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            pinned: true,
            expandedHeight: 70,
            toolbarHeight: 50,
            leading: CommonAppBarLeading(scaffoldKey: _scaffoldKey),
            title: const Text(
              "Your Library",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            actions: [
              // IconButton for search functionality
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.search,
                  size: 30,
                  color: Colors.white,
                ),
              ),
              // IconButton for adding new items (currently does nothing)
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.add,
                  size: 30,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          BlocBuilder<LibraryBloc, LibraryState>(
            builder: (context, state) {
              if (state is LibraryLoading) {
                // Show a loading indicator while data is being fetched
                return const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                );
              } else if (state is LibraryFailded) {
                // Show error message if fetching the music model failed
                return SliverFillRemaining(
                  child: Center(
                    child: Text(state.message,
                        style: const TextStyle(
                            color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                );
              } else if (state is LibraryLoaded) {
                // Display the list of music items when data is loaded
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      final musicModel = state.musicModel[index];
                      return Padding(
                        padding: const EdgeInsets.only(top: 0.0, left: 10, right: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white,
                              width: .2,
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          child: InkWell(
                            onTap: () {
                              // Navigate to MusicPlayerPage when an item is tapped
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          MusicPlayerPage(musicModel: musicModel))).then((_) {});
                            },
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(0),
                              leading: Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Image.network(musicModel.themePath ?? "URL Missing"),
                              ),
                              title: Text(musicModel.songName ?? "Unknown Song"),
                              subtitle: Text(musicModel.singerName ?? "Unknown Singer"),
                              trailing: IconButton(
                                onPressed: () {
                                  // Dispatch RemoveMusicModel event to remove an item from the playlist
                                  context.read<LibraryBloc>().add(RemoveMusicModel(index));
                                },
                                icon: const Icon(Icons.delete),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    childCount: state.musicModel.length,
                  ),
                );
              } else if (state is LibraryError) {
                // Show error message if there was an error in the library
                return SliverFillRemaining(
                  child: Center(
                    child: Text(state.message),
                  ),
                );
              } else {
                // Handle unknown state
                return const SliverFillRemaining(); // child: Center(child: Text("Unknown state")));
              }
            },
          ),
        ],
      ),
    );
  }
}
