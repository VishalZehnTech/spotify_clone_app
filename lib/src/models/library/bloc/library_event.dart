part of 'library_bloc.dart';

abstract class LibraryEvent extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class GetPlayListLength extends LibraryEvent {}

class GetMusicModel extends LibraryEvent {}

class RemoveMusicModel extends LibraryEvent {
  final int index;

  RemoveMusicModel(this.index);
}
