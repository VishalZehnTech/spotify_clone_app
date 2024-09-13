part of 'log_bloc.dart';

sealed class LogEvent extends Equatable {
  const LogEvent();

  @override
  List<Object> get props => [];
}

// Event to capture and update the email field
class GetEmail extends LogEvent {
  final String email; // The email address to update
  // Constructor to initialize the email
  const GetEmail({required this.email});

  @override
  List<Object> get props => [email];
}

// Event to capture and update the password field
// Also includes whether the password field is focused or not
class GetPassword extends LogEvent {
  // The password to update
  final String password;
  // Constructor to initialize the password and focus status
  const GetPassword({required this.password});

  @override
  List<Object> get props => [password];
}

// Event to capture and update the email field
enum GenderType { male, female, nonBinary, other, preferNotToSay, none }

class GetGender extends LogEvent {
  final GenderType genderType; // The email address to update

  // Constructor to initialize the email
  const GetGender({required this.genderType});

  @override
  List<Object> get props => [genderType];
}

// Event to toggle the visibility of the password field
class GetVisibility extends LogEvent {}

// Event to trigger the login API call
enum LogFieldStatus { login, signup, signInGoogle, signUpGoogle, none }

class LogAPI extends LogEvent {
  final String email;
  final String password;

  final LogFieldStatus logFieldStatus;
  const LogAPI({required this.email, required this.password, required this.logFieldStatus});

  @override
  List<Object> get props => [email, password, logFieldStatus];
}

// Event to trigger the logout API call
class LogOutAPI extends LogEvent {}

class GetUserData extends LogEvent {}
