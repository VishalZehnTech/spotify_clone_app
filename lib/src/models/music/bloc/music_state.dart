part of 'music_bloc.dart';

class MusicState extends Equatable {
  final bool isPlaying;
  final Duration position;
  final Duration duration;
  final bool isLoading;
  final String? errorMessage;
  final bool isFavoriteAdd;
  final String? playlistErrorMessage; // Add this field for playlist error message

  const MusicState({
    required this.isPlaying,
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.isLoading = false,
    this.errorMessage,
    required this.isFavoriteAdd,
    this.playlistErrorMessage, // Initialize with a default value
  });

  MusicState copyWith({
    bool? isPlaying,
    Duration? position,
    Duration? duration,
    bool? isLoading,
    String? errorMessage,
    bool? isFavoriteAdd,
    String? playlistErrorMessage, // Add this parameter for copying
  }) {
    return MusicState(
      isPlaying: isPlaying ?? this.isPlaying,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      isFavoriteAdd: isFavoriteAdd ?? this.isFavoriteAdd,
      playlistErrorMessage: playlistErrorMessage ?? this.playlistErrorMessage,
    );
  }

  @override
  List<Object?> get props =>
      [isPlaying, position, duration, isLoading, errorMessage, isFavoriteAdd, playlistErrorMessage];
}
