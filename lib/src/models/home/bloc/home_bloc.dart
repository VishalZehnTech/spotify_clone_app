import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:spotify/src/models/music/model/music_model.dart';
import 'package:spotify/src/service/firebase_database.dart';

part 'home_event.dart';
part 'home_state.dart';

// HomeBloc is responsible for handling events related to the home screen
// and updating the state of the home screen.
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final FirebaseDatabase _firebaseDatabase;

  // Constructor initializing HomeBloc with an instance of FirebaseDatabase
  HomeBloc(this._firebaseDatabase) : super(const HomeState(musicModel: {})) {
    // Registering event handlers
    on<GetNavBarIndex>(_getNavBarIndex);
    on<GetSongDetails>(_getSongDetails);
  }

  // Event handler to update the navigation bar index
  void _getNavBarIndex(GetNavBarIndex event, Emitter<HomeState> emit) {
    debugPrint("Event : ${event.homePageIndex}");
    emit(state.copyWith(homePageIndex: event.homePageIndex));
  }

  // Event handler to fetch song details
  Future<void> _getSongDetails(GetSongDetails event, Emitter<HomeState> emit) async {
    try {
      // Fetch favorite artist music and update the state
      List<MusicModel?>? favoriteArtistModel =
          await _firebaseDatabase.fetchMusicDataByCategory("favoriteArtist");
      emit(
          state.copyWith(musicModel: {...state.musicModel, "favoriteArtist": favoriteArtistModel}));

      // Fetch recommended music and update the state
      List<MusicModel?>? recommended =
          await _firebaseDatabase.fetchMusicDataByCategory("recommended");
      emit(state.copyWith(musicModel: {...state.musicModel, "recommended": recommended}));

      // Fetch bhajan music and update the state
      List<MusicModel?>? bhajanModel = await _firebaseDatabase.fetchMusicDataByCategory("bhajan");
      emit(state.copyWith(musicModel: {...state.musicModel, "bhajan": bhajanModel}));

      // Fetch hip-hop music and update the state
      List<MusicModel?>? hipHopModel = await _firebaseDatabase.fetchMusicDataByCategory("hiphop");
      emit(state.copyWith(musicModel: {...state.musicModel, "hiphop": hipHopModel}));
    } catch (e) {
      // Print error if fetching music details fails
      debugPrint("Error fetching music details: $e");
    }
  }
}
