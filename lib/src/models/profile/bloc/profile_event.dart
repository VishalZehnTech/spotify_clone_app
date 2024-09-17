part of 'profile_bloc.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class UpdateUserName extends ProfileEvent {
  final String userName;
  const UpdateUserName({required this.userName});
}

class UpdateUserNameField extends ProfileEvent {
  final String userName;

  const UpdateUserNameField({required this.userName});
}

class UploadProfileImage extends ProfileEvent {
  final File imageFile;
  const UploadProfileImage({required this.imageFile});
}
