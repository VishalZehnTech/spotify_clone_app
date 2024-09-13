// library_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotify/src/models/music/model/music_model.dart';

part 'library_event.dart';
part 'library_state.dart';

class LibraryBloc extends Bloc<LibraryEvent, LibraryState> {
  final FirebaseFirestore _firebaseFirestore;

  LibraryBloc(this._firebaseFirestore) : super(LibraryInitial()) {
    on<LoadMusicModel>(_onLoadMusicModel);
  }
/*
  Future<void> _onLoadMusicModel(LoadMusicModel event, Emitter<LibraryState> emit) async {
    emit(LibraryLoading());
    try {
      // Fetch the user ID from shared preferences or other means
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('userId');

      if (userId == null) {
        emit(LibraryError("No user ID found"));
        return;
      }

      // // Query the All_Users collection
      // DocumentSnapshot userDoc = await _firebaseFirestore.collection('All_Users').doc(userId).get();

      // if (userDoc.exists) {
      //   // Extract the playlist field
      //   List<dynamic> playlistData = userDoc.get('playlist') ?? [];

      //   // Convert the playlist data to a list of MusicModel objects
      //   List<MusicModel> musicModels = playlistData.map((data) {
      //     return MusicModel.fromJson(data as Map<String, dynamic>);
      //   }).toList();

      emit(LibraryLoaded(musicModels));
    } catch (e) {
      emit(LibraryError("Failed to load music"));
    }
  }
  */
  Future<void> _onLoadMusicModel(LoadMusicModel event, Emitter<LibraryState> emit) async {
    emit(LibraryLoading());
    try {
      // Fetch the user ID from shared preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('userId');

      if (userId == null) {
        emit(LibraryError("No user ID found"));
        return;
      }

      // Query the All_Users collection based on 'user_id' field
      QuerySnapshot userQuery = await _firebaseFirestore
          .collection('All_Users')
          .where('user_id', isEqualTo: userId)
          .get();

      if (userQuery.docs.isNotEmpty) {
        // Extract the first document from the query
        DocumentSnapshot userDoc = userQuery.docs.first;

        // Extract the playlist field
        List<dynamic> playlistData = userDoc.get('playlist') ?? [];

        // Convert the playlist data to a list of MusicModel objects
        List<MusicModel> musicModels = playlistData.map((data) {
          return MusicModel.fromJson(data as Map<String, dynamic>);
        }).toList();

        emit(LibraryLoaded(musicModels));
      } else {
        emit(LibraryError("User not found"));
      }
    } catch (e) {
      emit(LibraryError("Failed to load playlist: $e"));
    }
  }
}
