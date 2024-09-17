part of 'profile_bloc.dart';

class ProfileState extends Equatable {
  final bool isSaveButtonEnabled;
  final bool isImageUploaded;
  final String imageFilePath; // Added for tracking image file path

  const ProfileState({
    this.isSaveButtonEnabled = false,
    this.isImageUploaded = false,
    this.imageFilePath = '', // Initialize with an empty string
  });

  ProfileState copyWith({
    bool? isSaveButtonEnabled,
    bool? isImageUploaded,
    String? imageFilePath, // Added for updating image file path
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

class ProfileLoading extends ProfileState {}

class ProfileSuccess extends ProfileState {
  final String message;
  const ProfileSuccess(this.message);
}

class ProfileFailed extends ProfileState {
  final String message;
  const ProfileFailed(this.message);
}

class ProfileError extends ProfileState {
  final String message;
  const ProfileError(this.message);
}
