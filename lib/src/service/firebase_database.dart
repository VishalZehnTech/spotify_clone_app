import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotify/src/models/music/model/music_model.dart';
import 'package:spotify/src/models/log_in/model/user_model.dart';
import 'package:spotify/src/overrides.dart';

class FirebaseDatabase {
  final FirebaseAuth _auth = FirebaseAuth.instance; // Firebase Authentication instance
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance; // Firestore instance

  // Logs in a user with email and password
  Future<User?> logInWithGmailPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user; // Return the logged-in user
    } on FirebaseAuthException catch (e) {
      // Handle specific FirebaseAuthException cases
      if (e.code == 'user-not-found') {
        debugPrint('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        debugPrint('Wrong password provided for that user.');
      } else {
        debugPrint('Error occurred: ${e.message}');
      }
      return null;
    } catch (e) {
      // Handle general exceptions
      debugPrint('An unexpected error occurred: $e');
      return null;
    }
  }

  // Signs up a new user with email and password
  Future<User?> signUpWithGmailPassword(String email, String password) async {
    try {
      debugPrint("Vishal Soner : 0.1111");
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(email: email, password: password);
      debugPrint("Vishal Soner : 0");

      User? user = userCredential.user;
      debugPrint("Vishal Soner : 1");
      if (user != null) {
        debugPrint("Vishal Soner : 2");
        await user.updateProfile(
            photoURL: Overrides.USER_PHOTO_URL, displayName: email.split('@')[0]);
        await user.reload();
        user = _auth.currentUser;
      }

      debugPrint("Vishal Soner : 3");
      return user;
    } catch (e) {
      debugPrint('Error creating user: $e');
    }
    return null;
  }

  // Signs in a user with Google authentication
  Future<User?> signinWithGoogle() async {
    try {
      final googleUser = await GoogleSignIn().signIn();
      final googleAuth = await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
          idToken: googleAuth?.idToken, accessToken: googleAuth?.accessToken);
      UserCredential userCredential = await _auth.signInWithCredential(credential);

      return userCredential.user; // Return the logged-in user
    } catch (e) {
      debugPrint("Error : $e");
    }
    return null;
  }

  // Signs out the current user and clears related data
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

  // Gets the download URL for a file stored in Firebase Storage
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

  // Fetches music data by category from Firestore
  Future<List<MusicModel>?> fetchMusicDataByCategory(String songCategory) async {
    try {
      QuerySnapshot snapshot = await _firebaseFirestore
          .collection('All_Songs')
          .where('songCategory', isEqualTo: songCategory)
          .get();

      List<MusicModel> musicModel = snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return MusicModel.fromJson(data); // Convert document data to MusicModel
      }).toList();
      return musicModel;
    } catch (e) {
      debugPrint("Error fetching music data: $e");
      return null;
    }
  }

  // Stores user details in Firestore
  Future<void> storeUserDetails({User? user}) async {
    try {
      if (user != null) {
        QuerySnapshot snapshot = await FirebaseFirestore.instance
            .collection('All_Users')
            .where('user_id', isEqualTo: user.uid)
            .get();

        if (snapshot.docs.isNotEmpty) {
          DocumentReference userDocRef = snapshot.docs.first.reference;
          await userDocRef.update({
            'updated_at': FieldValue.serverTimestamp()
          }); // Update the user's last updated timestamp
        } else {
          // If the user doesn't exist, create the document.
          await FirebaseFirestore.instance
              .collection('All_Users')
              .doc("${user.displayName}.${user.uid}")
              .set({
            'name': user.displayName,
            'email': user.email,
            'photo_url': user.photoURL,
            'created_at': FieldValue.serverTimestamp(),
            'user_id': user.uid,
            'playlist': [], // Initialize with an empty playlist
          });
        }
      }
    } catch (e) {
      debugPrint("Error : $e");
    }
  }

  // Updates the user's name in Firestore
  Future<bool> updateUserName({required String newName}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('userId');

      if (userId == null) {
        debugPrint('User Id is Null.');
        return false;
      }
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('All_Users')
          .where('user_id', isEqualTo: userId)
          .get();

      if (snapshot.docs.isNotEmpty) {
        DocumentReference userDocRef = snapshot.docs.first.reference;
        await userDocRef.update({'name': newName}); // Update the user's name
        debugPrint('User name updated successfully.');
        return true;
      }
    } catch (e) {
      debugPrint("Error updating user name: $e");
      return false;
    }
    return false;
  }

  // Retrieves user data from Firestore
  Future<UserModel?> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    if (userId == null) {
      debugPrint('User ID is Null Get User Data.');
      return null;
    }
    QuerySnapshot snapshot =
        await _firebaseFirestore.collection('All_Users').where('user_id', isEqualTo: userId).get();
    try {
      if (snapshot.docs.isNotEmpty) {
        DocumentSnapshot doc = snapshot.docs.first;
        return UserModel.fromMap(
            doc.data() as Map<String, dynamic>, userId); // Convert document data to UserModel
      } else {
        debugPrint('No document found for user_id: $userId');
        return null;
      }
    } catch (e) {
      debugPrint('Error GetUserData : $e');
      return null;
    }
  }

  // Adds an item to the user's playlist in Firestore
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

      // Query Firestore to check if the user exists
      QuerySnapshot snapshot = await _firebaseFirestore
          .collection('All_Users')
          .where('user_id', isEqualTo: userId)
          .get();

      if (snapshot.docs.isNotEmpty) {
        DocumentReference docRef = snapshot.docs.first.reference;

        // Convert MusicModel to a Map
        Map<String, dynamic> musicData = musicModel.toJson();

        // Update the playlist field by adding the new song
        await docRef.update({
          'playlist': FieldValue.arrayUnion([musicData])
        });

        debugPrint("Song added to playlist successfully for user_id: $userId");
        return true;
      } else {
        debugPrint("No user found with user_id: $userId");
        return false;
      }
    } catch (e) {
      debugPrint("Error adding song to playlist: $e");
      return false;
    }
  }

  // Searches for songs by a search term
  Future<List<MusicModel>> getSearcgSongs(String searchTerm) async {
    // Fetch all songs (or a broad subset if applicable)
    QuerySnapshot snapshot = await _firebaseFirestore.collection('All_Songs').get();

    // Filter documents client-side to match the search term
    List<MusicModel> musicModel = snapshot.docs.where((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      String songName = data['songName'].toString().toLowerCase();
      return songName.contains(searchTerm.toLowerCase());
    }).map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return MusicModel.fromJson(data); // Convert document data to MusicModel
    }).toList();

    debugPrint("All Songs With name : $musicModel");
    return musicModel;
  }
}
