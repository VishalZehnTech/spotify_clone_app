part of 'music_bloc.dart';

// Abstract class for music events
abstract class MusicEvent extends Equatable {
  const MusicEvent();
}

// Event for initial state of adding item to playlist
class AddItemToPlaylistInitial extends MusicEvent {
  @override
  List<Object?> get props => [];
}

// Event for loading state of adding item to playlist
class AddItemToPlaylistLoading extends MusicEvent {
  @override
  List<Object?> get props => [];
}

// Event for adding an item to the playlist
class AddItemToPlaylist extends MusicEvent {
  final MusicModel? musicModel;

  const AddItemToPlaylist({this.musicModel});

  @override
  List<Object?> get props => [musicModel];
}

// Event for loading music with a given song URL
class LoadMusicEvent extends MusicEvent {
  final String songUrl;

  const LoadMusicEvent(this.songUrl);

  @override
  List<Object> get props => [songUrl];
}

// Event for toggling play/pause state of music
class TogglePlayPauseEvent extends MusicEvent {
  @override
  List<Object> get props => [];
}

// Event for seeking to a specific position in the music
class SeekEvent extends MusicEvent {
  final Duration position;

  const SeekEvent(this.position);

  @override
  List<Object> get props => [position];
}

// Event for updating position when music playback position changes
class PositionChangedEvent extends MusicEvent {
  final Duration position;

  const PositionChangedEvent(this.position);

  @override
  List<Object> get props => [position];
}

// Event for updating music playback state (playing or paused)
class MusicPlaybackStateChangedEvent extends MusicEvent {
  final bool isPlaying;

  const MusicPlaybackStateChangedEvent({required this.isPlaying});

  @override
  List<Object> get props => [isPlaying];
}
