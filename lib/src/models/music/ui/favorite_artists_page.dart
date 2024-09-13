import 'package:flutter/material.dart';
import 'package:spotify/src/models/music/model/music_model.dart';

class FavoriteArtistsPage extends StatefulWidget {
  final MusicModel musicModel;

  const FavoriteArtistsPage({super.key, required this.musicModel});

  @override
  State<FavoriteArtistsPage> createState() => _FavoriteArtistsPageState();
}

class _FavoriteArtistsPageState extends State<FavoriteArtistsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 70, 63, 63),
              Colors.black,
            ],
          ),
        ),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              automaticallyImplyLeading: false,
              floating: false,
              pinned: true, // Keep the app bar pinned
              backgroundColor: Colors.transparent,
              expandedHeight: 250,
              leading: Container(
                height: 20,
                width: 20,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black38,
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Center(
                    child: Icon(Icons.arrow_back, size: 25, color: Colors.white),
                  ),
                ),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      "${widget.musicModel.themePath}",
                      fit: BoxFit.cover,
                    ),
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.black45, Colors.transparent],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0, // Positioned at the bottom of the SliverAppBar
                      left: 16,
                      child: Align(
                        alignment: Alignment.bottomCenter, // Center the text horizontally
                        child: Text(
                          "${widget.musicModel.singerName}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center, // Center align the text
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "40.7M monthly listeners",
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.white, width: 2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset(
                                  "assets/images/home/favorite_artists/Honey_Singh.jpg",
                                  width: 30,
                                  height: 42,
                                  fit: BoxFit.fitHeight,
                                ),
                              ),
                            ),
                            const SizedBox(width: 25),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                  color: Colors.black,
                                  width: 1,
                                ),
                              ),
                              child: const Padding(
                                padding:
                                    EdgeInsets.only(left: 10.0, right: 10.0, top: 5, bottom: 5),
                                child: Text(
                                  "Following",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.more_vert,
                                  size: 25,
                                  color: Colors.white,
                                )),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(onPressed: () {}, icon: const Icon(Icons.shuffle, size: 25)),
                            IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.play_circle_filled_rounded,
                                  color: Color.fromARGB(255, 4, 255, 12),
                                  size: 55,
                                )),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(left: 18.0, top: 10, bottom: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _commonMusicButton(
                            titleName: "Music",
                            colorName: Colors.white,
                            underColor: const Color.fromARGB(255, 0, 233, 8)),
                        _commonMusicButton(titleName: "Clips", colorName: Colors.grey),
                        _commonMusicButton(titleName: "Events", colorName: Colors.grey),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Popluar",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return ListTile(
                    contentPadding: const EdgeInsets.only(left: 20),
                    title: Row(
                      children: [
                        Text(
                          "${index + 1}",
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(width: 10),
                        Image.asset("assets/images/home/favorite_artists/Arjit_Singh.jpg",
                            height: 50, width: 50),
                        const SizedBox(width: 10),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 220,
                              child: Text(
                                "Name Vishak(From Vishal Soner)",
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text("9302487", style: TextStyle(fontSize: 13)),
                          ],
                        ),
                      ],
                    ),
                    // subtitle: const Text("Yo Yo Honey Singh"),
                    trailing: IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
                  );
                },
                childCount: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container _commonMusicButton(
      {required String titleName,
      required Color colorName,
      Color underColor = const Color.fromARGB(255, 41, 30, 30)}) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: underColor, width: 2)),
      ),
      child: TextButton(
        onPressed: () {},
        child: Text(
          titleName,
          style: TextStyle(color: colorName, fontSize: 16),
        ),
      ),
    );
  }
}
