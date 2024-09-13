import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/src/models/drawer/ui/drawer_page.dart';
import 'package:spotify/src/models/library/bloc/library_bloc.dart';
import 'package:spotify/src/models/music/ui/music_player.dart';
// import 'package:spotify/src/blocs/library/library_bloc.dart';
import 'package:spotify/src/widgets/common_app_bar_leading.dart';

class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LibraryBloc(FirebaseFirestore.instance)
        ..add(LoadMusicModel()), // Load music when the page is created
      child: Scaffold(
        key: GlobalKey<ScaffoldState>(),
        drawer: const DrawerPage(),
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              pinned: true,
              expandedHeight: 70,
              leading: CommonAppBarLeading(scaffoldKey: GlobalKey<ScaffoldState>()),
              title: const Text(
                "Your Library",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.search,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
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
                  return const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else if (state is LibraryLoaded) {
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
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MusicPlayerPage(musicModel: musicModel),
                                    ));
                              },
                              child: ListTile(
                                leading: Image.network(musicModel.themePath ?? "URL Missing"),
                                title: Text(musicModel.songName ?? "Unknown Song"),
                                subtitle: Text(musicModel.singerName ?? "Unknown Singer"),
                              ),
                            ),
                          ),
                        );
                      },
                      childCount: state.musicModel.length,
                    ),
                  );
                } else if (state is LibraryError) {
                  return SliverFillRemaining(
                    child: Center(child: Text(state.message)),
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
