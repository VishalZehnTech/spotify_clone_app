import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotify/src/models/log_in/model/user_model.dart';
import 'package:spotify/src/service/firebase_database.dart';

part 'log_event.dart';
part 'log_state.dart';

// Bloc class for handling login-related events and states
class LogBloc extends Bloc<LogEvent, LogState> {
  final FirebaseDatabase _firebaseDatabase;

  // Constructor for LogBloc, initializes with DbService and sets initial state
  LogBloc(this._firebaseDatabase)
      : super(const LogState(
          isVisibility: false,
          isFormValid: false,
          isEmailFocused: false,
          isPasswordFocused: false,
          isUserFocused: false,
          loginStatus: LoginStatus.init,
        )) {
    // Register event handlers
    on<GetEmail>(_getEmail);
    on<GetPassword>(_getPassword);
    on<EmailFocusChanged>(_gmailFocusChanged);
    on<PasswordFocusChanged>(_passwordFocusChanged);
    on<UserFocusChanged>(_userFocusChanged);
    on<GetVisibility>(_getVisibility);
    on<LogAPI>(_logAPI);
    on<LogOutAPI>(_logOutAPI);
    on<GetUserData>(_getUserData);
    // on<GetChangeFocus>(_getChangeFocus); // Commented out event handler
  }

  // Handles the GetEmail event to update the email in the state
  void _getEmail(GetEmail event, Emitter<LogState> emit) {
    final isFormValid = event.email.isNotEmpty && state.password.isNotEmpty;
    emit(state.copyWith(email: event.email, isFormValid: isFormValid));
  }

  // Handles the GetPassword event to update the password in the state
  void _getPassword(GetPassword event, Emitter<LogState> emit) {
    final isFormValid = state.email.isNotEmpty && event.password.isNotEmpty;
    emit(state.copyWith(password: event.password, isFormValid: isFormValid));
  }

  // Handles the EmailFocusChanged event to update the email focus state
  void _gmailFocusChanged(EmailFocusChanged event, Emitter<LogState> emit) {
    emit(state.copyWith(isEmailFocused: event.hasFocus));
  }

  // Handles the PasswordFocusChanged event to update the password focus state
  void _passwordFocusChanged(PasswordFocusChanged event, Emitter<LogState> emit) {
    emit(state.copyWith(isPasswordFocused: event.hasFocus));
  }

  // Handles the UserFocusChanged event to update the user focus state
  void _userFocusChanged(UserFocusChanged event, Emitter<LogState> emit) {
    emit(state.copyWith(isUserFocused: event.hasFocus));
  }

  // Handles the GetVisibility event to toggle the visibility of the password field
  void _getVisibility(GetVisibility event, Emitter<LogState> emit) {
    emit(state.copyWith(isVisibility: !state.isVisibility));
  }

  // Handles the LogAPI event to perform login and update the login status based on response
  void _logAPI(LogAPI event, Emitter<LogState> emit) async {
    // Set initial login status to indicate login attempt
    emit(state.copyWith(loginStatus: LoginStatus.loading));
    try {
      User? user;
      if (event.logFieldStatus == LogFieldStatus.login) {
        user = await _firebaseDatabase.logInWithGmailPassword(event.email, event.password);
        if (user != null) {
          await _firebaseDatabase.storeUserDetails(user: user);
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isLoggedIn', true);
          await prefs.setString('userId', user.uid);
          await checkUserLogStatus(user, emit);
        }
      } else if (event.logFieldStatus == LogFieldStatus.signup) {
        user = await _firebaseDatabase.signUpWithGmailPassword(event.email, event.password);
        if (user != null) {
          await _firebaseDatabase.storeUserDetails(user: user);
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isLoggedIn', true);
          await prefs.setString('userId', user.uid);
          await checkUserLogStatus(user, emit);
        }
      } else if (event.logFieldStatus == LogFieldStatus.signInGoogle ||
          event.logFieldStatus == LogFieldStatus.signUpGoogle) {
        user = await _firebaseDatabase.signinWithGoogle();
        if (user != null) {
          await _firebaseDatabase.storeUserDetails(user: user);
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isLoggedIn', true);
          await prefs.setString('userId', user.uid);
          await checkUserLogStatus(user, emit);
        }
      } else {
        return;
      }
    } catch (e) {
      debugPrint("Error : $e");
      emit(state.copyWith(loginStatus: LoginStatus.error, message: e.toString()));
    }
  }

  Future<void> checkUserLogStatus(User? user, Emitter<LogState> emit) async {
    if (user != null) {
      debugPrint("Login Successfully");
      emit(state.copyWith(loginStatus: LoginStatus.success, message: "Login Successfully"));
    } else {
      debugPrint("Failed Something went wrong");
      emit(state.copyWith(
          logFieldStatus: LogFieldStatus.none,
          userModel: null,
          loginStatus: LoginStatus.failed,
          message: "User Not Found"));
    }
  }

  // Handles the GetUserData event to fetch and update user data
  void _getUserData(GetUserData event, Emitter<LogState> emit) async {
    UserModel? userModel = await _firebaseDatabase.getUserData();
    debugPrint("Vishal Soner User Data : $userModel");
    emit(state.copyWith(userModel: userModel));
  }

  // Handles the LogOutAPI event to perform logout and reset state
  Future<void> _logOutAPI(LogOutAPI event, Emitter<LogState> emit) async {
    emit(state.copyWith(loginStatus: LoginStatus.loading));

    try {
      await _firebaseDatabase.signOut(); // Calls the signOut method to handle the logout process
      emit(state.copyWith(
        loginStatus: LoginStatus.init,
        logFieldStatus: LogFieldStatus.none,
        userModel: null, // Reset user data
      ));
    } catch (e) {
      emit(state.copyWith(
        loginStatus: LoginStatus.error, // Handle error state if needed
      ));
      debugPrint('Error during logout: $e');
    }
  }
}
