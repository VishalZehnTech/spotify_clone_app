// library_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotify/src/models/music/model/music_model.dart';

part 'library_event.dart';
part 'library_state.dart';

class LibraryBloc extends Bloc<LibraryEvent, LibraryState> {
  final FirebaseFirestore _firebaseFirestore;

  LibraryBloc(this._firebaseFirestore) : super(LibraryInitial()) {
    on<GetMusicModel>(_addMusicModel);
    on<RemoveMusicModel>(_removeMusicModel);
    on<GetPlayListLength>(_getPlayListLength);
  }

  Future<void> _addMusicModel(GetMusicModel event, Emitter<LibraryState> emit) async {
    // emit(LibraryLoading());
    try {
      // Fetch the user ID from shared preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('userId');

      if (userId == null) {
        emit(const LibraryError("No user ID found"));
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

        if (playlistData.isEmpty) {
          emit(const LibraryFailded("Playlist is empty"));
          return;
        }
        // Convert the playlist data to a list of MusicModel objects
        List<MusicModel> musicModels = playlistData.map((data) {
          return MusicModel.fromJson(data as Map<String, dynamic>);
        }).toList();

        emit(LibraryLoaded(musicModels));
        // emit(state.copyWith(playListLength: playlistData.length));
      } else {
        emit(const LibraryError("User not found"));
      }
    } catch (e) {
      emit(LibraryError("Failed to load playlist: $e"));
    }
  }

  Future<void> _removeMusicModel(RemoveMusicModel event, Emitter<LibraryState> emit) async {
    emit(LibraryLoading());
    try {
      // Fetch the user ID from shared preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('userId');

      if (userId == null) {
        emit(const LibraryError("No user ID found"));
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

        // Check if the playlist is empty
        if (playlistData.isEmpty) {
          emit(const LibraryFailded("No data in playlist"));
          return;
        }

        // Check if the index is valid
        if (event.index >= 0 && event.index < playlistData.length) {
          // Remove the item at the given index
          playlistData.removeAt(event.index);

          // Update Firestore with the new playlist
          await _firebaseFirestore
              .collection('All_Users')
              .doc(userDoc.id)
              .update({'playlist': playlistData});

          // Convert the updated playlist to a list of MusicModel objects
          List<MusicModel> musicModels = playlistData.map((data) {
            return MusicModel.fromJson(data as Map<String, dynamic>);
          }).toList();

          if (playlistData.length == event.index && playlistData.isEmpty) {
            emit(const LibraryFailded("Playlist is empty"));
            return;
          }
          emit(LibraryLoaded(musicModels));
        }
      } else {
        emit(const LibraryError("User not found"));
      }
    } catch (e) {
      emit(LibraryError("Failed to remove playlist item: $e"));
    }
  }

  Future<void> _getPlayListLength(GetPlayListLength event, Emitter<LibraryState> emit) async {
    emit(LibraryLoading());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');

    if (userId == null) {
      emit(const LibraryError("No user ID found"));
      return;
    }

    // Query the All_Users collection based on 'user_id' field
    QuerySnapshot userQuery =
        await _firebaseFirestore.collection('All_Users').where('user_id', isEqualTo: userId).get();

    if (userQuery.docs.isNotEmpty) {
      // Extract the first document from the query
      DocumentSnapshot userDoc = userQuery.docs.first;

      // Extract the playlist field
      List<dynamic> playlistData = userDoc.get('playlist') ?? [];

      emit(state.copyWith(playListLength: playlistData.length));
    } else {
      // emit(const LibraryError("User not found"));
    }
  }
}
