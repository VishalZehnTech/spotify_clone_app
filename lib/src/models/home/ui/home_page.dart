import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/src/models/drawer/ui/drawer_page.dart';
import 'package:spotify/src/models/home/bloc/home_bloc.dart';
import 'package:spotify/src/models/home/ui/widgets/shimmer_music_item_card.dart';
import 'package:spotify/src/models/music/model/music_model.dart';
import 'package:spotify/src/models/music/ui/favorite_artists_page.dart';
import 'package:spotify/src/models/music/ui/music_player.dart';
import 'package:spotify/src/widgets/common_app_bar_leading.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    // context.read<LogBloc>().add(GetUserData());
    context.read<HomeBloc>().add(GetSongDetails());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
          backgroundColor: Colors.black,
          toolbarHeight: 50,
          leading: CommonAppBarLeading(scaffoldKey: _scaffoldKey)),
      drawer: const DrawerPage(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 10.0, top: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder<HomeBloc, HomeState>(
                builder: (context, state) {
                  List<MusicModel?>? favoriteArtist = state.musicModel["favoriteArtist"];
                  if (favoriteArtist == null || favoriteArtist.isEmpty) {
                    return const ShimmerMusicItemCard();
                  } else {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Your favorite artists",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                        ),
                        SizedBox(
                          height: 215,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: favoriteArtist.length,
                            itemBuilder: (context, index) {
                              MusicModel favoriteArtistModel = favoriteArtist[index]!;
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(top: 10, left: 10.0, bottom: 10.0),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => FavoriteArtistsPage(
                                                  musicModel: favoriteArtistModel)),
                                        );
                                      },
                                      child: CircleAvatar(
                                        radius: 85,
                                        backgroundImage: NetworkImage(
                                          // favoriteArtistsAndPath.values.elementAt(index),
                                          "${favoriteArtistModel.themePath}",
                                        ),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    // favoriteArtistsAndPath.keys.elementAt(index),
                                    "${favoriteArtistModel.singerName}",
                                    style:
                                        const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
              const SizedBox(height: 15),
              _commonTitleWithMusicItemCard(
                titleName: "Recommended for today",
                modelName: "recommended",
              ),
              const SizedBox(height: 15),
              _commonTitleWithMusicItemCard(
                titleName: "Bhajan Songs",
                modelName: "bhajan",
              ),
              const SizedBox(height: 25),
              _commonTitleWithMusicItemCard(
                titleName: "Hit Hop Songs",
                modelName: "hiphop",
              ),
            ],
          ),
        ),
      ),
    );
  }

  BlocBuilder<HomeBloc, HomeState> _commonTitleWithMusicItemCard(
      {required String titleName, required String modelName}) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        List<MusicModel?>? recommendedMusic = state.musicModel[modelName];
        if (recommendedMusic == null || recommendedMusic.isEmpty) {
          return const ShimmerMusicItemCard();
        } else {
          return Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                titleName,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 240,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: recommendedMusic.length,
                  itemBuilder: (context, index) {
                    return _commonMusicItemCard(context, recommendedMusic[index]!);
                  },
                ),
              ),
            ],
          );
        }
      },
    );
  }

  Padding _commonMusicItemCard(BuildContext context, MusicModel musicModel) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              Navigator.of(context).push(createRoute(
                onTapDestination: MusicPlayerPage(musicModel: musicModel),
              ));
            },
            child: Image.network(
              "${musicModel.themePath}",
              height: 180,
              width: 180,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            width: 180,
            child: Text(
              "${musicModel.songName}",
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(
            width: 180,
            child: Text(
              "Single ${musicModel.singerName}",
              style: const TextStyle(fontSize: 13),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

Route createRoute({required Widget onTapDestination}) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => onTapDestination,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;
      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
