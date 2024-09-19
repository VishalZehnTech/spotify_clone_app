import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:spotify/src/models/log_in/log_Bloc/log_bloc.dart';
import 'package:spotify/src/models/profile/bloc/profile_bloc.dart';
import 'package:spotify/src/models/home/bloc/home_bloc.dart';
import 'package:spotify/src/models/library/bloc/library_bloc.dart';
import 'package:spotify/src/models/music/bloc/music_bloc.dart';
import 'package:spotify/src/models/search/bloc/search_bloc.dart';
import 'package:spotify/src/service/firebase_database.dart';
import 'package:spotify/src/widgets/Splash_Screen.dart';

class MyApp extends StatelessWidget {
  final FirebaseDatabase _firebaseDatabase = FirebaseDatabase();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      // Provides multiple BLoCs to the widget tree
      providers: [
        BlocProvider(create: (_) => LogBloc(_firebaseDatabase)), // Provides authentication BLoC
        BlocProvider(create: (_) => HomeBloc(_firebaseDatabase)), // Provides home-related BLoC
        BlocProvider(
            create: (_) => MusicBloc(
                _firebaseDatabase, AudioPlayer())), // Provides music BLoC with audio player
        BlocProvider(
            create: (_) => LibraryBloc(FirebaseFirestore.instance)), // Provides library BLoC
        BlocProvider(create: (_) => ProfileBloc(_firebaseDatabase)), // Provides profile BLoC
        BlocProvider(create: (_) => SearchBloc(_firebaseDatabase)), // Provides search BLoC
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false, // Disables the debug banner in the app
        theme: ThemeData.dark(), // Sets the theme to dark mode
        home: const SplashPage(), // Sets the initial screen to the splash page
      ),
    );
  }
}
