part of 'log_bloc.dart';

// Enum to represent different states of the login process
enum LoginStatus { failed, success, error, loading, init }

class LogState extends Equatable {
  final String email; // The email address entered by the user
  final String password; // The password entered by the user
  final String message; // Message to show status or error messages
  final bool isVisibility; // Indicates if the password field is visible
  final LogFieldStatus logFieldStatus;
  final LoginStatus loginStatus; // The current status of the login process
  final UserModel? userModel;

  // Constructor for initializing the LogState
  const LogState(
      {this.email = '', // Default empty string for email
      this.password = '', // Default empty string for password
      this.message = '', // Default empty string for message
      this.logFieldStatus = LogFieldStatus.none, // Default focus field is none
      required this.isVisibility, // Required visibility status for password field
      this.loginStatus = LoginStatus.init, // Default login status is init
      this.userModel});

  // Method to create a copy of the current state with updated properties
  LogState copyWith({
    String? email, // Optionally update the email
    String? password, // Optionally update the password
    String? message, // Optionally update the message
    bool? isVisibility, // Optionally update the visibility of the password field
    LogFieldStatus? logFieldStatus, // Optionally update the focus field
    LoginStatus? loginStatus, // Optionally update the login status
    UserModel? userModel,
  }) {
    return LogState(
        email: email ?? this.email,
        password: password ?? this.password,
        message: message ?? this.message,
        logFieldStatus: logFieldStatus ?? this.logFieldStatus,
        isVisibility: isVisibility ?? this.isVisibility,
        loginStatus: loginStatus ?? this.loginStatus,
        userModel: userModel ?? this.userModel);
  }

  @override
  // List of properties used for equality comparison
  List<Object?> get props =>
      [email, password, message, logFieldStatus, loginStatus, isVisibility, userModel];
}
