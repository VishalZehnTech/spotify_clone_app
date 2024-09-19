part of 'library_bloc.dart';

// Base class for all library-related states
class LibraryState extends Equatable {
  // Optional length of the playlist
  final int? playListLength;

  const LibraryState({this.playListLength = 0});

  // Create a new instance with updated values
  LibraryState copyWith({int? playListLength}) {
    return LibraryState(playListLength: playListLength ?? this.playListLength);
  }

  // List of properties used for equality comparison
  @override
  List<Object?> get props => [playListLength];
}

// State when the library is in its initial state
class LibraryInitial extends LibraryState {}

// State when there is a failure in library operations
class LibraryFailded extends LibraryState {
  // Error message describing the failure
  final String message;

  const LibraryFailded(this.message);
}

// State when the library is loading data
class LibraryLoading extends LibraryState {}

// State indicating a successful playlist operation
class PlaylistSuccess extends LibraryState {
  // Success message
  final String message;

  const PlaylistSuccess(this.message);
}

// State indicating an error in playlist operation
class PlaylistError extends LibraryState {
  // Error message describing the issue
  final String message;

  const PlaylistError(this.message);
}

// State when the library has successfully loaded data
class LibraryLoaded extends LibraryState {
  // List of music models
  final List<MusicModel> musicModel;

  const LibraryLoaded(this.musicModel);
}

// State when there is an error in library operations
class LibraryError extends LibraryState {
  // Error message describing the issue
  final String message;

  const LibraryError(this.message);
}
