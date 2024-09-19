import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:spotify/src/models/music/model/music_model.dart';
import 'package:spotify/src/service/firebase_database.dart';

part 'search_event.dart';
part 'search_state.dart';

// Bloc class for handling search-related events and states
class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final FirebaseDatabase _firebaseDatabase; // Service for interacting with Firebase

  // Constructor initializes the bloc with the FirebaseDatabase instance and sets the initial state
  SearchBloc(this._firebaseDatabase) : super(const SearchState()) {
    // Register event handlers
    on<SearchSongs>(_searchSongs);
    on<ClearSearch>(_clearSearch);
  }

  // Handles the ClearSearch event to reset the search state
  void _clearSearch(ClearSearch event, Emitter<SearchState> emit) {
    emit(SearchInitial()); // Reset the state when clearing the search
  }

  // Handles the SearchSongs event to perform a song search
  void _searchSongs(SearchSongs event, Emitter<SearchState> emit) async {
    emit(SearchLoading()); // Emit loading state while searching

    try {
      // Fetch songs matching the search criteria from the Firebase database
      List<MusicModel> musicModels = await _firebaseDatabase.getSearcgSongs(event.songName);
      emit(SearchLoaded(musicModels)); // Emit loaded state with search results
    } catch (e) {
      emit(SearchError(e.toString())); // Emit error state if an exception occurs
    }
  }
}
