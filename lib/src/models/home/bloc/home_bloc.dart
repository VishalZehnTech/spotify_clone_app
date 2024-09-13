import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:spotify/src/models/music/model/music_model.dart';
import 'package:spotify/src/service/firebase_database.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final FirebaseDatabase _firebaseDatabase;

  HomeBloc(this._firebaseDatabase) : super(const HomeState(musicModel: {})) {
    on<GetNavBarIndex>(_getNavBarIndex);
    on<GetSongDetails>(_getRecommendedDetails);
  }

  void _getNavBarIndex(GetNavBarIndex event, Emitter<HomeState> emit) {
    debugPrint("Event : ${event.homePageIndex}");
    emit(state.copyWith(homePageIndex: event.homePageIndex));
  }

  Future<void> _getRecommendedDetails(GetSongDetails event, Emitter<HomeState> emit) async {
    try {
      // Fetch favorite artist music and update UI after fetching
      List<MusicModel?>? favoriteArtistModel =
          await _firebaseDatabase.fetchMusicDataByCategory("favoriteArtist");
      emit(
          state.copyWith(musicModel: {...state.musicModel, "favoriteArtist": favoriteArtistModel}));

      // Fetch recommended music and update UI immediately
      List<MusicModel?>? recommended =
          await _firebaseDatabase.fetchMusicDataByCategory("recommended");
      emit(state.copyWith(musicModel: {...state.musicModel, "recommended": recommended}));

      // Fetch bhajan music and update UI after fetching
      List<MusicModel?>? bhajanModel = await _firebaseDatabase.fetchMusicDataByCategory("bhajan");
      emit(state.copyWith(musicModel: {...state.musicModel, "bhajan": bhajanModel}));
      //
      List<MusicModel?>? hipHopModel = await _firebaseDatabase.fetchMusicDataByCategory("hiphop");
      emit(state.copyWith(musicModel: {...state.musicModel, "hiphop": hipHopModel}));
      //
    } catch (e) {
      debugPrint("Error fetching music details: $e");
    }
  }
}
