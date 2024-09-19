part of 'profile_bloc.dart';

// Base class for profile-related events
sealed class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

// Event to update the user's name
class UpdateUserName extends ProfileEvent {
  final String userName; // New user name to be updated
  const UpdateUserName({required this.userName});
}

// Event to update the user name field's state (e.g., enable/disable save button)
class UpdateUserNameField extends ProfileEvent {
  final String userName; // Updated user name field value

  const UpdateUserNameField({required this.userName});
}

// Event to upload a new profile image
class UploadProfileImage extends ProfileEvent {
  final File imageFile; // Image file to be uploaded
  const UploadProfileImage({required this.imageFile});
}

// Event to clear profile data (e.g., reset fields)
class ClearProfileData extends ProfileEvent {}
