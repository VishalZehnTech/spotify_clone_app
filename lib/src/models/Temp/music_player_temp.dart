import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class MusicPlayerTemp extends StatefulWidget {
  const MusicPlayerTemp({super.key});

  @override
  _MusicPlayerTempState createState() => _MusicPlayerTempState();
}

class _MusicPlayerTempState extends State<MusicPlayerTemp> {
  final player = AudioPlayer();
  String musicUrl = "gs://spotify-clone-8b21f.appspot.com/Millionaire.mp3";

  @override
  void initState() {
    super.initState();
    loadMusic();
  }

  Future<void> loadMusic() async {
    // Get the download URL from Firebase
    String url = await FirebaseStorage.instance.ref('Millionaire.mp3').getDownloadURL();
    setState(() {
      musicUrl = url;
    });
    player.setUrl(musicUrl); // Set the URL in the audio player
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Music Player'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                player.play(); // Play the music
              },
              child: const Text('Play'),
            ),
            ElevatedButton(
              onPressed: () {
                player.pause(); // Pause the music
              },
              child: const Text('Pause'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('musicUrl', musicUrl));
  }
}
