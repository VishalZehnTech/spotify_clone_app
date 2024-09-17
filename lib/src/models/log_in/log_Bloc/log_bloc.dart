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
    // on<GetChangeFocus>(_getChangeFocus);
  }

  // Handles the GetEmail event to update the email in the state
  void _getEmail(GetEmail event, Emitter<LogState> emit) {
    final isFormValid = event.email.isNotEmpty && state.password.isNotEmpty;
    print("Vishal Soner is Valid Email :  $isFormValid");
    emit(state.copyWith(email: event.email, isFormValid: isFormValid));
  }

  // Handles the GetPassword event to update the password in the state
  void _getPassword(GetPassword event, Emitter<LogState> emit) {
    final isFormValid = state.email.isNotEmpty && event.password.isNotEmpty;
    print("Vishal Soner is Valid password :  $isFormValid");
    emit(state.copyWith(password: event.password, isFormValid: isFormValid));
  }

  // Handles the GetEmail event to update the email in the state
  void _gmailFocusChanged(EmailFocusChanged event, Emitter<LogState> emit) {
    emit(state.copyWith(isEmailFocused: event.hasFocus));
  }

  // Handles the GetPassword event to update the password in the state
  void _passwordFocusChanged(PasswordFocusChanged event, Emitter<LogState> emit) {
    emit(state.copyWith(isPasswordFocused: event.hasFocus));
  }

  // Handles the User name event to update the password in the state
  void _userFocusChanged(UserFocusChanged event, Emitter<LogState> emit) {
    emit(state.copyWith(isUserFocused: event.hasFocus));
  }

  // Handles the GetVisibility event to toggle the visibility of the password field
  void _getVisibility(GetVisibility event, Emitter<LogState> emit) {
    emit(state.copyWith(isVisibility: !state.isVisibility));
  }

  // Handles the LoginAPI event to perform login and update the login status based on response
  void _logAPI(LogAPI event, Emitter<LogState> emit) async {
    // Set initial login status to indicate login attempt
    emit(state.copyWith(loginStatus: LoginStatus.loading));
    try {
      if (event.logFieldStatus == LogFieldStatus.login) {
        User? user = await _firebaseDatabase.logInWithGmailPassword(event.email, event.password);
        await _firebaseDatabase.storeUserDetails(user: user);
        checkUserDetails(user, emit);
      }
      //
      else if (event.logFieldStatus == LogFieldStatus.signup) {
        debugPrint("Email : ${event.email},  Password : ${event.password}");
        User? user = await _firebaseDatabase.signUpWithGmailPassword(event.email, event.password);

        debugPrint("User : ${user?.email},  Password : ${user?.photoURL}");
        await _firebaseDatabase.storeUserDetails(user: user);
        checkUserDetails(user, emit);
      }
      //
      else if (event.logFieldStatus == LogFieldStatus.signInGoogle ||
          event.logFieldStatus == LogFieldStatus.signUpGoogle) {
        User? user = await _firebaseDatabase.signinWithGoogle();
        await _firebaseDatabase.storeUserDetails(user: user);
        checkUserDetails(user, emit);
      }
    }
    // Print error and update state with error message
    catch (e) {
      debugPrint("Error : $e");
      emit(state.copyWith(loginStatus: LoginStatus.error, message: e.toString()));
      return;
    }
  }

  Future<void> checkUserDetails(User? user, Emitter<LogState> emit) async {
    if (user != null) {
      debugPrint("Login Successfully");
      emit(state.copyWith(loginStatus: LoginStatus.success, message: "Login Successfully"));
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('userId', user.uid);
    } else {
      debugPrint("Failed Something went wrong");
      emit(state.copyWith(loginStatus: LoginStatus.failed, message: "User Not Found"));
    }
  }

  // Handles the LogOutAPI event to reset the login status
  Future<void> _logOutAPI(LogOutAPI event, Emitter<LogState> emit) async {
    emit(state.copyWith(loginStatus: LoginStatus.loading));
    _firebaseDatabase.signOut();
    emit(state.copyWith(
      loginStatus: LoginStatus.init,
      logFieldStatus: LogFieldStatus.none,
      userModel: UserModel(),
    ));
  }

  void _getUserData(GetUserData event, Emitter<LogState> emit) async {
    UserModel? userModel = await _firebaseDatabase.getUserData();
    debugPrint("Vishal Soner User Data : $userModel");
    emit(state.copyWith(userModel: userModel));
  }
}
