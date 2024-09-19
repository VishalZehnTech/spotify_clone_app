part of 'music_bloc.dart';

// Class representing the state of music playback
class MusicState extends Equatable {
  final bool isPlaying; // Indicates if music is currently playing
  final Duration position; // Current playback position
  final Duration duration; // Total duration of the music
  final bool isLoading; // Indicates if the music is currently loading
  final String? errorMessage; // Error message if an error occurs
  final bool isFavoriteAdd; // Indicates if the music item is added to favorites
  final String? playlistErrorMessage; // Error message for playlist operations

  // Constructor for MusicState
  const MusicState({
    required this.isPlaying,
    this.position = Duration.zero, // Default to zero duration
    this.duration = Duration.zero, // Default to zero duration
    this.isLoading = false, // Default to not loading
    this.errorMessage,
    required this.isFavoriteAdd,
    this.playlistErrorMessage, // Initialize with a default value
  });

  // Method to create a copy of the state with updated fields
  MusicState copyWith({
    bool? isPlaying,
    Duration? position,
    Duration? duration,
    bool? isLoading,
    String? errorMessage,
    bool? isFavoriteAdd,
    String? playlistErrorMessage, // Parameter for copying
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
