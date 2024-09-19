import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotify/src/service/firebase_database.dart';

part 'profile_event.dart';
part 'profile_state.dart';

// Bloc class for handling profile-related events and states
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final FirebaseDatabase _firebaseDatabase; // Service for Firebase operations

  // Constructor for ProfileBloc, initializes with FirebaseDatabase and sets initial state
  ProfileBloc(this._firebaseDatabase) : super(const ProfileState()) {
    // Register event handlers
    on<UpdateUserName>(_updateUserName);
    on<UpdateUserNameField>(_updateUserNameField);
    on<UploadProfileImage>(_uploadProfileImage);
    on<ClearProfileData>(_clearProfileData);
  }

  // Handles the ClearProfileData event to reset profile state
  void _clearProfileData(ClearProfileData event, Emitter<ProfileState> emit) {
    emit(state.copyWith(isSaveButtonEnabled: false, isImageUploaded: false, imageFilePath: ""));
    debugPrint("State Clear Profile Data ImageFilePath: ${state.imageFilePath}");
    debugPrint("State Clear Profile Data isSaveButtonEnabled: ${state.isSaveButtonEnabled}");
    debugPrint("State Clear Profile Data isImageUploaded: ${state.isImageUploaded}");
  }

  // Handles the UpdateUserNameField event to enable or disable the save button
  void _updateUserNameField(UpdateUserNameField event, Emitter<ProfileState> emit) {
    emit(state.copyWith(isSaveButtonEnabled: event.userName.trim().isNotEmpty));
  }

  // Handles the UpdateUserName event to update the user's name in Firebase
  void _updateUserName(UpdateUserName event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      bool result = await _firebaseDatabase.updateUserName(newName: event.userName);

      if (result) {
        emit(const ProfileSuccess("Name Changed Successfully"));
      } else {
        emit(const ProfileFailed("Name change Failed"));
      }
      emit(state.copyWith(isSaveButtonEnabled: false, isImageUploaded: false));
    } catch (e) {
      debugPrint("Error UpdateUserName: $e");
      emit(ProfileError("Error: $e"));
    }
  }

  // Handles the UploadProfileImage event to upload a new profile image
  Future<void> _uploadProfileImage(UploadProfileImage event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      // Get the userId from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('userId');

      if (userId == null) {
        emit(const ProfileFailed("User ID not found"));
        return;
      }

      // Step 1: Fetch the current photoUrl from Firestore
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('All_Users')
          .where('user_id', isEqualTo: userId)
          .get();

      if (snapshot.docs.isNotEmpty) {
        DocumentReference userDocRef = snapshot.docs.first.reference;
        String? oldPhotoUrl = snapshot.docs.first.get('photo_url') as String?;

        // Step 2: Delete the old image from Firebase Storage if it exists and is a valid URL
        if (oldPhotoUrl != null &&
            oldPhotoUrl.startsWith('https://firebasestorage.googleapis.com/')) {
          try {
            final Uri oldPhotoUri = Uri.parse(oldPhotoUrl);
            final storageRef = FirebaseStorage.instance.refFromURL(oldPhotoUri.toString());
            await storageRef.delete();
            debugPrint('Old image deleted successfully');
          } catch (e) {
            debugPrint("Error deleting old image: $e");
          }
        } else {
          debugPrint("User not found.");
          emit(const ProfileFailed("User not found"));
        }

        // Step 3: Compress the image
        final imageFile = event.imageFile;
        final compressedImage = await FlutterImageCompress.compressWithFile(imageFile.path,
            minWidth: 200, minHeight: 200, quality: 40);

        // Create a new file with the compressed image data
        final compressedImageFile = File(imageFile.path)..writeAsBytesSync(compressedImage!);

        // Step 4: Upload the compressed image to Firebase Storage
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('user_photos/${compressedImageFile.path.split('/').last}');
        await storageRef.putFile(compressedImageFile);
        final downloadUrl = await storageRef.getDownloadURL();

        // Step 5: Update Firestore with the new photoUrl
        await userDocRef.update({'photo_url': downloadUrl});
        debugPrint("Uploaded new profile image successfully.");

        emit(state.copyWith(isImageUploaded: true, imageFilePath: event.imageFile.path));
      } else {
        debugPrint("Old photo URL is not a valid Firebase Storage URL or is null");
      }
    } catch (e) {
      debugPrint("Error uploading image: $e");
      emit(ProfileError("Error uploading image: $e"));
    }
  }
}
