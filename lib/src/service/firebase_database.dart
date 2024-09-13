import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotify/src/models/music/model/music_model.dart';
import 'package:spotify/src/log_Bloc/model/user_model.dart';

class FirebaseDatabase {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<User?> logInWithGmailPassword(String email, String password) async {
    try {
      UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } catch (e) {
      debugPrint("Error : $e");
    }
    return null;
  }

  Future<User?> signUpWithGmailPassword(String email, String password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      return user;
    } catch (e) {
      debugPrint("Error : $e");
    }
    return null;
  }

  Future<User?> signinWithGoogle() async {
    try {
      final googleUser = await GoogleSignIn().signIn();
      final googleAuth = await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
          idToken: googleAuth?.idToken, accessToken: googleAuth?.accessToken);
      UserCredential userCredential = await _auth.signInWithCredential(credential);

      return userCredential.user;
    } catch (e) {
      debugPrint("Error : $e");
    }
    return null;
  }

  Future<void> signOut() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', false);
      await prefs.remove('userId');
      await _auth.signOut();
      await GoogleSignIn().signOut();
    } catch (e) {
      debugPrint('Error signing out: $e');
    }
  }

  Future<String?> getAudioDownloadUrl(String gsUrl) async {
    try {
      // Convert gs:// URL to a reference
      final ref = FirebaseStorage.instance.refFromURL(gsUrl);
      // Get the download URL
      final downloadUrl = await ref.getDownloadURL();
      debugPrint("Download URL: $downloadUrl");
      return downloadUrl;
    } catch (e) {
      debugPrint("Error fetching download URL: $e");
      return null;
    }
  }

  Future<List<MusicModel>?> fetchMusicDataByCategory(String songCategory) async {
    try {
      QuerySnapshot snapshot = await _firebaseFirestore
          .collection('All_Songs')
          .where('songCategory', isEqualTo: songCategory)
          .get();

      List<MusicModel> musicModel = snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return MusicModel.fromJson(data);
      }).toList();
      return musicModel;
    } catch (e) {
      debugPrint("Error fetching music data: $e");
      return null;
    }
  }

  // Future<void> storeUserDetails({User? user}) async {
  //   try {
  //     if (user != null) {
  //       await FirebaseFirestore.instance
  //           .collection('All_Users')
  //           .doc("${user.displayName}.${user.uid}")
  //           .set({
  //         'name': user.displayName,
  //         'email': user.email,
  //         'photo_url': user.photoURL,
  //         'created_at': FieldValue.serverTimestamp(),
  //         'user_id': user.uid,
  //       });
  //     }
  //   } catch (e) {
  //     debugPrint("Error : $e");
  //   }
  // }

  Future<void> storeUserDetails({User? user}) async {
    try {
      if (user != null) {
        QuerySnapshot snapshot = await FirebaseFirestore.instance
            .collection('All_Users')
            .where('user_id', isEqualTo: user.uid)
            .get();

        if (snapshot.docs.isNotEmpty) {
          DocumentReference userDocRef = snapshot.docs.first.reference;
          await userDocRef.update({'created_at': FieldValue.serverTimestamp()});
        } else {
          // If the user doesn't exist, create the document.
          await FirebaseFirestore.instance.collection('All_Users').doc().set({
            'name': user.displayName,
            'email': user.email,
            'photo_url': user.photoURL,
            'created_at': FieldValue.serverTimestamp(),
            'user_id': user.uid,
            'playlist': [],
          });
        }
      }
    } catch (e) {
      debugPrint("Error : $e");
    }
  }

  Future<UserModel?> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    QuerySnapshot snapshot =
        await _firebaseFirestore.collection('All_Users').where('user_id', isEqualTo: userId).get();
    if (snapshot.docs.isNotEmpty) {
      DocumentSnapshot doc = snapshot.docs.first;
      return UserModel.fromMap(doc.data() as Map<String, dynamic>, userId!);
    } else {
      debugPrint('No document found for user_id: $userId');
      return null;
    }
  }

  Future<bool> addItemToPlaylist(MusicModel? musicModel) async {
    try {
      if (musicModel == null) {
        debugPrint("MusicModel is null. Cannot add to playlist.");
        return false;
      }

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('userId');

      if (userId == null) {
        debugPrint("User ID is null. Cannot add to playlist.");
        return false;
      }

      // Step 1: Query Firestore to check if the user exists based on 'user_id'
      QuerySnapshot snapshot = await _firebaseFirestore
          .collection('All_Users')
          .where('user_id', isEqualTo: userId)
          .get();

      // Step 2: Check if any documents were returned
      if (snapshot.docs.isNotEmpty) {
        // User exists, proceed to add the song to the playlist
        DocumentReference docRef = snapshot.docs.first.reference;

        // Convert MusicModel to a Map
        Map<String, dynamic> musicData = musicModel.toJson();

        // Step 3: Update the playlist field by adding the new song
        await docRef.update({
          'playlist': FieldValue.arrayUnion([musicData])
        });

        debugPrint("Song added to playlist successfully for user_id: $userId");
        return true;
      } else {
        // User doesn't exist
        debugPrint("No user found with user_id: $userId");
        return false;
      }
    } catch (e) {
      // Handle any errors that occur
      debugPrint("Error adding song to playlist: $e");
      return false;
    }
  }
}
