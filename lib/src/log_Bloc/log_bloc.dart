import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotify/src/log_Bloc/model/user_model.dart';
import 'package:spotify/src/service/firebase_database.dart';

part 'log_event.dart';
part 'log_state.dart';

// Bloc class for handling login-related events and states
class LogBloc extends Bloc<LogEvent, LogState> {
  final FirebaseDatabase _firebaseDatabase;

  // Constructor for LogBloc, initializes with DbService and sets initial state
  LogBloc(this._firebaseDatabase) : super(const LogState(isVisibility: false)) {
    // Register event handlers
    on<GetEmail>(_getEmail);
    on<GetPassword>(_getPassword);
    on<GetVisibility>(_getVisibility);
    // on<GetGender>(_getGender);
    on<LogAPI>(_logAPI);
    on<LogOutAPI>(_logOutAPI);
    on<GetUserData>(_getUserData);
    // on<GetChangeFocus>(_getChangeFocus);
  }

  // Handles the GetEmail event to update the email in the state
  void _getEmail(GetEmail event, Emitter<LogState> emit) async {
    emit(state.copyWith(email: event.email));
  }

  // Handles the GetPassword event to update the password in the state
  void _getPassword(GetPassword event, Emitter<LogState> emit) async {
    emit(state.copyWith(password: event.password));
  }

  // Handles the GetVisibility event to toggle the visibility of the password field
  void _getVisibility(GetVisibility event, Emitter<LogState> emit) {
    emit(state.copyWith(isVisibility: !state.isVisibility));
  }

  // void _getGender(GetGender event, Emitter<LogState> emit) async {
  //   debugPrint("Gender : ${state.genderType}");
  //   emit(state.copyWith(genderType: event.genderType));
  // }

  // Handles the LoginAPI event to perform login and update the login status based on response
  void _logAPI(LogAPI event, Emitter<LogState> emit) async {
    // Set initial login status to indicate login attempt
    emit(state.copyWith(
      email: event.email,
      password: event.password,
      loginStatus: LoginStatus.init,
      logFieldStatus: event.logFieldStatus,
    ));
    try {
      if (state.logFieldStatus == LogFieldStatus.login) {
        User? user = await _firebaseDatabase.logInWithGmailPassword(state.email, state.password);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('userId', user!.uid);
        await _firebaseDatabase.storeUserDetails(user: user);

        checkUserDetails(user, emit);
      }
      //
      else if (state.logFieldStatus == LogFieldStatus.signup) {
        User? user = await _firebaseDatabase.signUpWithGmailPassword(state.email, state.password);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('userId', user!.uid);
        await _firebaseDatabase.storeUserDetails(user: user);
        checkUserDetails(user, emit);
      }
      //
      else if (state.logFieldStatus == LogFieldStatus.signInGoogle ||
          state.logFieldStatus == LogFieldStatus.signUpGoogle) {
        User? user = await _firebaseDatabase.signinWithGoogle();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('userId', user!.uid);
        await _firebaseDatabase.storeUserDetails(user: user);
        checkUserDetails(user, emit);
      }
    }
    // Print error and update state with error message
    catch (e) {
      debugPrint("Error : $e");
      emit(
        state.copyWith(loginStatus: LoginStatus.error, message: e.toString()),
      );
    }
  }

  void checkUserDetails(User? user, Emitter<LogState> emit) async {
    if (user != null) {
      try {
        debugPrint("Login Successfully");
        // await _firebaseDatabase.storeUserDetails(user: user);

        emit(state.copyWith(loginStatus: LoginStatus.success, message: "Login Successfully"));
      } catch (e) {
        emit(state.copyWith(loginStatus: LoginStatus.error, message: "Error : $e"));
      }
    } else {
      debugPrint("Something went wrong");
      emit(state.copyWith(loginStatus: LoginStatus.failed, message: "Something went wrong"));
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

  // void _logOutAPI(LogOutAPI event, Emitter<LogState> emit) async {
  // }

  void _getUserData(GetUserData event, Emitter<LogState> emit) async {
    UserModel? userModel = await _firebaseDatabase.getUserData();
    debugPrint("Vishal Soner User Data : $userModel");
    emit(state.copyWith(userModel: userModel));
  }
}
