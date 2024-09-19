import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:spotify/src/models/music/model/music_model.dart';
import 'package:spotify/src/service/firebase_database.dart';

part 'music_event.dart';
part 'music_state.dart';

class MusicBloc extends Bloc<MusicEvent, MusicState> {
  final FirebaseDatabase _firebaseDatabase; // Service for interacting with Firebase
  final AudioPlayer _audioPlayer; // Audio player instance for music playback

  // Constructor initializes with FirebaseDatabase and AudioPlayer, sets initial state
  MusicBloc(this._firebaseDatabase, this._audioPlayer)
      : super(const MusicState(isPlaying: false, isFavoriteAdd: false)) {
    // Register event handlers
    on<LoadMusicEvent>(_loadMusic);
    on<TogglePlayPauseEvent>(_togglePlayPause);
    on<SeekEvent>(_seek);
    on<PositionChangedEvent>(_positionChanged);
    on<AddItemToPlaylist>(_addItemToPlaylist);
    on<MusicPlaybackStateChangedEvent>(_musicPlaybackStateChanged);

    // Listen to audio player's position stream and add PositionChangedEvent when position changes
    _audioPlayer.positionStream.listen((position) {
      add(PositionChangedEvent(position));
    });
  }

  // Handles AddItemToPlaylist event: adds the music item to the playlist
  Future<void> _addItemToPlaylist(AddItemToPlaylist event, Emitter<MusicState> emit) async {
    try {
      debugPrint("Adding song to playlist: ${event.musicModel}");

      // Add item to playlist and check result
      bool result = await _firebaseDatabase.addItemToPlaylist(event.musicModel);

      if (result) {
        emit(state.copyWith(isFavoriteAdd: !state.isFavoriteAdd)); // Update state if successful
      } else {
        emit(state.copyWith(
          playlistErrorMessage: 'Failed to add song to playlist.', // Error message if failed
        ));
      }
    } catch (e) {
      debugPrint("Error adding item to playlist: $e");
      emit(state.copyWith(
        playlistErrorMessage:
            'Error adding item to playlist: $e', // Error message if exception occurs
      ));
    }
  }

  // Handles LoadMusicEvent: loads music by setting URL and updating state with duration
  Future<void> _loadMusic(LoadMusicEvent event, Emitter<MusicState> emit) async {
    try {
      emit(state.copyWith(isLoading: true)); // Set loading state
      final downloadUrl = await _firebaseDatabase.getAudioDownloadUrl(event.songUrl);

      if (downloadUrl == null) {
        emit(state.copyWith(errorMessage: "Failed to fetch download URL.", isLoading: false));
        return;
      }

      await _audioPlayer.setUrl(downloadUrl); // Set audio URL for playback
      final duration = _audioPlayer.duration ?? Duration.zero; // Get duration of the audio
      emit(state.copyWith(duration: duration, isLoading: false)); // Update state with duration
    } catch (e) {
      debugPrint("Error loading music: $e");
      emit(state.copyWith(errorMessage: "Error loading music: $e", isLoading: false));
    }
  }

  // Handles TogglePlayPauseEvent: toggles between play and pause
  Future<void> _togglePlayPause(TogglePlayPauseEvent event, Emitter<MusicState> emit) async {
    try {
      if (_audioPlayer.playing) {
        emit(state.copyWith(isPlaying: false)); // Update state to not playing
        await _audioPlayer.pause(); // Pause the audio
      } else {
        emit(state.copyWith(isPlaying: true)); // Update state to playing
        await _audioPlayer.play(); // Start playing the audio
      }
    } catch (e) {
      debugPrint("Error toggling play/pause: $e");
    }
  }

  // Handles SeekEvent: seeks to a specific position in the audio
  Future<void> _seek(SeekEvent event, Emitter<MusicState> emit) async {
    try {
      await _audioPlayer.seek(event.position); // Seek to the specified position
      emit(state.copyWith(position: event.position)); // Update state with new position
    } catch (e) {
      debugPrint("Error seeking: $e");
      emit(state.copyWith(errorMessage: "Error seeking: $e")); // Error message if exception occurs
    }
  }

  // Handles PositionChangedEvent: updates the current playback position in state
  void _positionChanged(PositionChangedEvent event, Emitter<MusicState> emit) {
    emit(state.copyWith(position: event.position)); // Update state with current position
  }

  // Handles MusicPlaybackStateChangedEvent: updates the playback state in the state
  void _musicPlaybackStateChanged(MusicPlaybackStateChangedEvent event, Emitter<MusicState> emit) {
    emit(state.copyWith(isPlaying: event.isPlaying)); // Update state with playback status
  }
}
