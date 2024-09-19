import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/src/models/drawer/ui/drawer_page.dart';
import 'package:spotify/src/models/music/model/music_model.dart';
import 'package:spotify/src/models/music/ui/music_player.dart';
import 'package:spotify/src/models/search/bloc/search_bloc.dart';
import 'package:spotify/src/widgets/common_app_bar_leading.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<SearchBloc, SearchState>(
      listener: (context, state) {
        // Handle any state changes if necessary
      },
      child: Scaffold(
        key: _scaffoldKey,
        drawer: const DrawerPage(),
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              pinned: false,
              expandedHeight: 50,
              toolbarHeight: 50,
              leading: CommonAppBarLeading(scaffoldKey: _scaffoldKey),
              title:
                  const Text("Search", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.camera_alt_outlined,
                    size: 25,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: SearchBarDelegate(),
            ),
            BlocBuilder<SearchBloc, SearchState>(
              builder: (context, state) {
                if (state is SearchLoading) {
                  return const SliverToBoxAdapter(
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else if (state is SearchLoaded) {
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        MusicModel data = state.musicModels[index];
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MusicPlayerPage(musicModel: data)));
                          },
                          child: ListTile(
                            leading: Image.network(data.themePath ?? "Url missing",
                                height: 60, width: 60),
                            title: Text(data.songName ?? "Unknown Song"),
                            subtitle: Text(data.singerName ?? "Unknown Artist"),
                          ),
                        );
                      },
                      childCount: state.musicModels.length,
                    ),
                  );
                } else {
                  return const SliverToBoxAdapter(
                      //   child: Center(child: Text("Search Songs")),
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

class SearchBarDelegate extends SliverPersistentHeaderDelegate {
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.all(8.0),
      child: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          return TextField(
            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              prefixIcon: const Icon(
                Icons.search,
                color: Colors.black,
              ),
              hintText: 'What do you want to listen to?',
              hintStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              border: const OutlineInputBorder(
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey[200],
            ),
            onChanged: (value) {
              if (value.isNotEmpty) {
                context.read<SearchBloc>().add(SearchSongs(songName: value));
              } else {
                context.read<SearchBloc>().add(ClearSearch());
              }
            },
          );
        },
      ),
    );
  }

  @override
  double get maxExtent => 60.0;

  @override
  double get minExtent => 60.0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
