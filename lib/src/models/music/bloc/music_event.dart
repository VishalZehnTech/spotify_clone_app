part of 'music_bloc.dart';

abstract class MusicEvent extends Equatable {
  const MusicEvent();
}

class AddItemToPlaylistInitial extends MusicEvent {
  @override
  List<Object?> get props => [];
}

class AddItemToPlaylistLoading extends MusicEvent {
  @override
  List<Object?> get props => [];
}

class AddItemToPlaylist extends MusicEvent {
  final MusicModel? musicModel;

  const AddItemToPlaylist({this.musicModel});

  @override
  List<Object?> get props => [musicModel];
}

class LoadMusicEvent extends MusicEvent {
  final String songUrl;

  const LoadMusicEvent(this.songUrl);

  @override
  List<Object> get props => [songUrl];
}

class TogglePlayPauseEvent extends MusicEvent {
  @override
  List<Object> get props => [];
}

class SeekEvent extends MusicEvent {
  final Duration position;

  const SeekEvent(this.position);

  @override
  List<Object> get props => [position];
}

class PositionChangedEvent extends MusicEvent {
  final Duration position;

  const PositionChangedEvent(this.position);

  @override
  List<Object> get props => [position];
}
