part of 'library_bloc.dart';

class LibraryState {}

class LibraryInitial extends LibraryState {}

class LibraryLoading extends LibraryState {}

class PlaylistSuccess extends LibraryState {
  final String message;

  PlaylistSuccess(this.message);
}

class PlaylistError extends LibraryState {
  final String message;

  PlaylistError(this.message);
}

class LibraryLoaded extends LibraryState {
  final List<MusicModel> musicModel;

  LibraryLoaded(this.musicModel);
}

class LibraryError extends LibraryState {
  final String message;

  LibraryError(this.message);
}
