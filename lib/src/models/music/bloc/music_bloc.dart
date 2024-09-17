import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:spotify/src/models/music/model/music_model.dart';
import 'package:spotify/src/service/firebase_database.dart';

part 'music_event.dart';
part 'music_state.dart';

class MusicBloc extends Bloc<MusicEvent, MusicState> {
  final FirebaseDatabase _firebaseDatabase;
  final AudioPlayer _audioPlayer;

  MusicBloc(this._firebaseDatabase, this._audioPlayer)
      : super(const MusicState(isPlaying: false, isFavoriteAdd: false)) {
    on<LoadMusicEvent>(_loadMusic);
    on<TogglePlayPauseEvent>(_togglePlayPause);
    on<SeekEvent>(_seek);
    on<PositionChangedEvent>(_positionChanged);
    on<AddItemToPlaylist>(_addItemToPlaylist);
    on<MusicPlaybackStateChangedEvent>(_musicPlaybackStateChanged);

    _audioPlayer.positionStream.listen((position) {
      add(PositionChangedEvent(position));
    });
  }

  Future<void> _addItemToPlaylist(AddItemToPlaylist event, Emitter<MusicState> emit) async {
    try {
      debugPrint("Adding song to playlist: ${event.musicModel}");

      // Assume addItemToPlaylist is updated to return a result or throw an exception on failure
      bool result = await _firebaseDatabase.addItemToPlaylist(event.musicModel);

      if (result) {
        emit(state.copyWith(isFavoriteAdd: !state.isFavoriteAdd));
      } else {
        emit(state.copyWith(
          playlistErrorMessage: 'Failed to add song to playlist.',
        ));
      }
    } catch (e) {
      debugPrint("Error adding item to playlist: $e");
      emit(state.copyWith(
        playlistErrorMessage: 'Error adding item to playlist: $e',
      ));
    }
  }

  Future<void> _loadMusic(LoadMusicEvent event, Emitter<MusicState> emit) async {
    try {
      emit(state.copyWith(isLoading: true));
      final downloadUrl = await _firebaseDatabase.getAudioDownloadUrl(event.songUrl);

      if (downloadUrl == null) {
        emit(state.copyWith(errorMessage: "Failed to fetch download URL.", isLoading: false));
        return;
      }

      await _audioPlayer.setUrl(downloadUrl);
      final duration = _audioPlayer.duration ?? Duration.zero;
      emit(state.copyWith(duration: duration, isLoading: false));
    } catch (e) {
      debugPrint("Error loading music: $e");
      emit(state.copyWith(errorMessage: "Error loading music: $e", isLoading: false));
    }
  }

  Future<void> _togglePlayPause(TogglePlayPauseEvent event, Emitter<MusicState> emit) async {
    try {
      if (_audioPlayer.playing) {
        emit(state.copyWith(isPlaying: false));
        await _audioPlayer.pause();
      } else {
        emit(state.copyWith(isPlaying: true));
        await _audioPlayer.play();
      }
    } catch (e) {
      debugPrint("Error toggling play/pause: $e");
    }
  }

  Future<void> _seek(SeekEvent event, Emitter<MusicState> emit) async {
    try {
      await _audioPlayer.seek(event.position);
      emit(state.copyWith(position: event.position));
    } catch (e) {
      debugPrint("Error seeking: $e");
      emit(state.copyWith(errorMessage: "Error seeking: $e"));
    }
  }

  void _positionChanged(PositionChangedEvent event, Emitter<MusicState> emit) {
    emit(state.copyWith(position: event.position));
  }

  void _musicPlaybackStateChanged(MusicPlaybackStateChangedEvent event, Emitter<MusicState> emit) {
    emit(state.copyWith(isPlaying: event.isPlaying));
  }
}
