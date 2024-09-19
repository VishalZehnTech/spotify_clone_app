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
    on<GetMusicModel>(_getMusicModel);
    on<RemoveMusicModel>(_removeMusicModel);
    on<GetPlayListLength>(_getPlayListLength);
  }

  Future<void> _getMusicModel(GetMusicModel event, Emitter<LibraryState> emit) async {
    emit(LibraryLoading()); // Emit loading state
    try {
      // Fetch the user ID from shared preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('userId');

      if (userId == null) {
        emit(const LibraryError("No user ID found")); // Emit error if user ID is not found
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
          emit(const LibraryFailded("Playlist is empty")); // Emit failure if playlist is empty
          return;
        }
        // Convert the playlist data to a list of MusicModel objects
        List<MusicModel> musicModels = playlistData.map((data) {
          return MusicModel.fromJson(data as Map<String, dynamic>);
        }).toList();

        emit(LibraryLoaded(musicModels)); // Emit loaded state with music models
        // emit(state.copyWith(playListLength: playlistData.length)); // Optional: update playlist length
      } else {
        emit(const LibraryError("User not found")); // Emit error if user is not found
      }
    } catch (e) {
      emit(LibraryError("Failed to load playlist: $e")); // Emit error if fetching fails
    }
  }

  Future<void> _removeMusicModel(RemoveMusicModel event, Emitter<LibraryState> emit) async {
    emit(LibraryLoading()); // Emit loading state
    try {
      // Fetch the user ID from shared preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('userId');

      if (userId == null) {
        emit(const LibraryError("No user ID found")); // Emit error if user ID is not found
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
          emit(const LibraryFailded("No data in playlist")); // Emit failure if playlist is empty
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
            emit(const LibraryFailded("Playlist is empty")); // Emit failure if playlist is empty
            return;
          }
          emit(LibraryLoaded(musicModels)); // Emit loaded state with updated music models
        }
      } else {
        emit(const LibraryError("User not found")); // Emit error if user is not found
      }
    } catch (e) {
      emit(LibraryError("Failed to remove playlist item: $e")); // Emit error if removal fails
    }
  }

  Future<void> _getPlayListLength(GetPlayListLength event, Emitter<LibraryState> emit) async {
    emit(LibraryLoading()); // Emit loading state
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');

    if (userId == null) {
      emit(const LibraryError("No user ID found")); // Emit error if user ID is not found
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

      emit(
          state.copyWith(playListLength: playlistData.length)); // Update state with playlist length
    } else {
      // emit(const LibraryError("User not found")); // Optionally emit error if user not found
    }
  }
}
