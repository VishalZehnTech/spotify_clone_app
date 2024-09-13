import 'package:flutter/material.dart';
import 'package:spotify/src/app.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyBPAtoiS2yoFJ1hAejCSvRrkmKfSfxfbtM",
          authDomain: "spotify-clone-8b21f.firebaseapp.com",
          databaseURL: "https://spotify-clone-8b21f-default-rtdb.firebaseio.com",
          projectId: "spotify-clone-8b21f",
          storageBucket: "spotify-clone-8b21f.appspot.com",
          messagingSenderId: "515343391096",
          appId: "1:515343391096:web:ea68723f2e93065a17508d",
          measurementId: "G-1LGX6SPBVN"),
    );
    debugPrint('Firebase connected successfully.\n');
  } catch (e) {
    debugPrint("Error : $e");
  }
  runApp(const MyApp());
}
