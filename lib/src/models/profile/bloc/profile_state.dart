part of 'profile_bloc.dart';

// Represents the state of the profile feature
class ProfileState extends Equatable {
  final bool isSaveButtonEnabled; // Indicates if the save button should be enabled
  final bool isImageUploaded; // Indicates if an image has been successfully uploaded
  final String imageFilePath; // Path to the uploaded image file

  const ProfileState({
    this.isSaveButtonEnabled = false, // Default to disabled
    this.isImageUploaded = false, // Default to not uploaded
    this.imageFilePath = '', // Default to empty string
  });

  // Creates a copy of the state with optional modifications
  ProfileState copyWith({
    bool? isSaveButtonEnabled,
    bool? isImageUploaded,
    String? imageFilePath, // Path to the image file that may be updated
  }) {
    return ProfileState(
      isSaveButtonEnabled: isSaveButtonEnabled ?? this.isSaveButtonEnabled,
      isImageUploaded: isImageUploaded ?? this.isImageUploaded,
      imageFilePath: imageFilePath ?? this.imageFilePath,
    );
  }

  @override
  List<Object> get props => [isSaveButtonEnabled, isImageUploaded, imageFilePath];
}

// State indicating that the profile is loading
class ProfileLoading extends ProfileState {}

// State indicating that the profile update was successful
class ProfileSuccess extends ProfileState {
  final String message; // Success message to be displayed
  const ProfileSuccess(this.message);
}

// State indicating that the profile update failed
class ProfileFailed extends ProfileState {
  final String message; // Failure message to be displayed
  const ProfileFailed(this.message);
}

// State indicating that there was an error with the profile update
class ProfileError extends ProfileState {
  final String message; // Error message to be displayed
  const ProfileError(this.message);
}
