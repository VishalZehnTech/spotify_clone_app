part of 'library_bloc.dart';

class LibraryState extends Equatable {
  final int? playListLength;
  const LibraryState({this.playListLength = 0});

  LibraryState copyWith({int? playListLength}) {
    return LibraryState(playListLength: playListLength ?? playListLength);
  }

  @override
  List<Object?> get props => [];
}

class LibraryInitial extends LibraryState {}

class LibraryFailded extends LibraryState {
  final String message;

  const LibraryFailded(this.message);
}

class LibraryLoading extends LibraryState {}

class PlaylistSuccess extends LibraryState {
  final String message;

  const PlaylistSuccess(this.message);
}

class PlaylistError extends LibraryState {
  final String message;

  const PlaylistError(this.message);
}

class LibraryLoaded extends LibraryState {
  final List<MusicModel> musicModel;

  const LibraryLoaded(this.musicModel);
}

class LibraryError extends LibraryState {
  final String message;

  const LibraryError(this.message);
}
