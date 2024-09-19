part of 'library_bloc.dart';

// Base class for all library-related events
abstract class LibraryEvent extends Equatable {
  // Default implementation of props method from Equatable
  @override
  List<Object?> get props => throw UnimplementedError();
}

// Event to request the length of the playlist
class GetPlayListLength extends LibraryEvent {}

// Event to request fetching of music models
class GetMusicModel extends LibraryEvent {}

// Event to request removal of a music model from the playlist
class RemoveMusicModel extends LibraryEvent {
  // Index of the music model to be removed
  final int index;

  RemoveMusicModel(this.index);
}
