import 'package:flutter/material.dart';

class TempPage extends StatelessWidget {
  const TempPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("TempPage Page"),
      ),
      body: Column(
        children: [
          const Center(child: Text("Vishal Soner")),
          IconButton(
              onPressed: () {
                // _createRoute();
                // Navigator.of(context)
                //     .push(
                // createRoute(index: 10, onTapDestination: MusicPlayerPage()
                // ));
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => const FavoriteArtistsPage(),
                //   ),
                // );
              },
              icon: const Icon(
                Icons.music_note_outlined,
                size: 100,
              ))
        ],
      ),
    );
  }
}
