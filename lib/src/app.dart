import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:spotify/src/log_Bloc/log_bloc.dart';
import 'package:spotify/src/models/home/bloc/home_bloc.dart';
import 'package:spotify/src/models/music/bloc/music_bloc.dart';
import 'package:spotify/src/service/firebase_database.dart';
import 'package:spotify/src/widgets/Splash_Screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => LogBloc(FirebaseDatabase())),
        BlocProvider(create: (_) => HomeBloc(FirebaseDatabase())),
        BlocProvider(create: (_) => MusicBloc(FirebaseDatabase(), AudioPlayer())),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(),
        home: const SplashPage(),
      ),
    );
  }
}
