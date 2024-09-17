import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:spotify/src/models/music/bloc/music_bloc.dart';
import 'package:spotify/src/models/music/model/music_model.dart';
import 'package:spotify/src/service/firebase_database.dart';

class MusicPlayerPage extends StatefulWidget {
  final MusicModel musicModel;

  const MusicPlayerPage({super.key, required this.musicModel});

  @override
  _MusicPlayerPageState createState() => _MusicPlayerPageState();
}

class _MusicPlayerPageState extends State<MusicPlayerPage> {
  late MusicBloc _musicBloc;
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _musicBloc = MusicBloc(FirebaseDatabase(), _audioPlayer)
      ..add(LoadMusicEvent("${widget.musicModel.songUrl}"));
  }

  @override
  void dispose() {
    _audioPlayer.stop();
    _audioPlayer.dispose();
    _musicBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return BlocProvider(
      create: (_) => _musicBloc,
      child: BlocConsumer<MusicBloc, MusicState>(
        listener: (context, state) {
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage!)),
            );
          }
        },
        builder: (context, state) {
          if (state.isLoading) {
            return Scaffold(
              appBar: AppBar(
                toolbarHeight: 0,
                automaticallyImplyLeading: false,
              ),
              body: const Center(child: CircularProgressIndicator()),
            );
          }

          return Scaffold(
            appBar: AppBar(
              toolbarHeight: 0,
              automaticallyImplyLeading: false,
            ),
            body: Container(
              height: screenHeight,
              width: screenWidth,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromARGB(255, 124, 116, 116),
                    Color.fromARGB(255, 73, 73, 73),
                    Colors.black,
                  ],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildTopBar(context, screenWidth),
                  const Spacer(),
                  _buildAlbumArt(context, screenWidth),
                  const Spacer(),
                  _buildSongInfo(context, screenWidth, state),
                  const SizedBox(height: 10),
                  _buildSlider(context, state, screenWidth),
                  _buildControls(context, state, screenWidth),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, double screenWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.keyboard_arrow_down_sharp, size: 30),
        ),
        Column(
          children: [
            const Text(
              "PLAYING FROM ARTIST",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            Text(
              "${widget.musicModel.singerName}",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ],
        ),
        IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
      ],
    );
  }

  Widget _buildAlbumArt(BuildContext context, double screenWidth) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: NetworkImage("${widget.musicModel.themePath}"),
            fit: BoxFit.cover,
          ),
        ),
        height: screenWidth * 0.8, // Keep the album art in the center with responsive size
      ),
    );
  }

  Widget _buildSongInfo(BuildContext context, double screenWidth, MusicState state) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${widget.musicModel.songName}",
                style: TextStyle(fontSize: screenWidth * 0.055, fontWeight: FontWeight.bold),
              ),
              Text(
                "Single • ${widget.musicModel.singerName}",
                style: TextStyle(fontSize: screenWidth * 0.038, color: Colors.grey),
              ),
            ],
          ),
          BlocListener<MusicBloc, MusicState>(
            listener: (context, state) {
              if (state.playlistErrorMessage != null) {
                // Show a Snackbar with an error message if playlistErrorMessage is not null
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.playlistErrorMessage!), backgroundColor: Colors.red),
                );
              } else if (state.isFavoriteAdd) {
                // Show a Snackbar with a success message if isFavoriteAdd is true
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Song added to playlist!'), backgroundColor: Colors.green),
                );
              }
            },
            child: IconButton(
                onPressed: () {
                  context.read<MusicBloc>().add(AddItemToPlaylist(musicModel: widget.musicModel));
                },
                icon: const Icon(Icons.add_circle_outline, size: 30, color: Colors.white)),
          )
        ],
      ),
    );
  }

  Widget _buildSlider(BuildContext context, MusicState state, double screenWidth) {
    return state.duration != Duration.zero
        ? Column(
            children: [
              Slider(
                value: state.position.inMilliseconds.toDouble(),
                min: 0,
                max: state.duration.inMilliseconds.toDouble(),
                onChanged: (value) {
                  context.read<MusicBloc>().add(
                        SeekEvent(Duration(milliseconds: value.toInt())),
                      );
                },
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(state.position.toString().split('.').first),
                    Text(state.duration.toString().split('.').first),
                  ],
                ),
              ),
            ],
          )
        : const SizedBox.shrink();
  }

  Widget _buildControls(BuildContext context, MusicState state, double screenWidth) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
              onPressed: () {}, icon: const Icon(Icons.shuffle, size: 20, color: Colors.white)),
          IconButton(
              onPressed: () {},
              icon: const Icon(Icons.skip_previous_sharp, size: 35, color: Colors.white)),
          IconButton(
            onPressed: () {
              context.read<MusicBloc>().add(TogglePlayPauseEvent());
            },
            icon: Icon(
                state.isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill_outlined,
                color: Colors.white,
                size: 55),
          ),
          IconButton(
              onPressed: () {},
              icon: const Icon(Icons.skip_next_sharp, size: 35, color: Colors.white)),
          IconButton(
              onPressed: () {}, icon: const Icon(Icons.repeat_one, size: 20, color: Colors.white)),
        ],
      ),
    );
  }
}
