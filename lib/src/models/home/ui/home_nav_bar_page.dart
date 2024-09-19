import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/src/models/home/bloc/home_bloc.dart';
import 'package:spotify/src/models/home/ui/home_page.dart';
import 'package:spotify/src/models/library/ui/library_page.dart';
import 'package:spotify/src/models/log_in/log_Bloc/log_bloc.dart';
import 'package:spotify/src/models/search/ui/search_page.dart';

// HomeNavBarPage is a stateful widget that manages the navigation between the Home, Search, and Library pages.
class HomeNavBarPage extends StatefulWidget {
  const HomeNavBarPage({super.key});

  @override
  State<HomeNavBarPage> createState() => _HomeNavBarPage();
}

class _HomeNavBarPage extends State<HomeNavBarPage> {
  @override
  void initState() {
    super.initState();
    // Triggers fetching of song details when the widget is first created.
    context.read<HomeBloc>().add(GetSongDetails());

    // Only call GetUserData if userModel is not already set
    if (context.read<LogBloc>().state.userModel == null) {
      context.read<LogBloc>().add(GetUserData());
    }
  }

  @override
  Widget build(BuildContext context) {
    // BlocBuilder listens to the state of HomeBloc and rebuilds the UI accordingly.
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Scaffold(
          extendBody: true,
          // Displays the current page based on the homePageIndex from the HomeState.
          body: _pages[state.homePageIndex],
          bottomNavigationBar: Stack(
            children: [
              // Background gradient for the bottom navigation bar.
              Container(
                height: 60,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black12,
                      Colors.black,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              // BottomNavigationBar allows switching between different pages.
              BottomNavigationBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                type: BottomNavigationBarType.fixed,
                currentIndex: state.homePageIndex, // Sets the selected tab.
                onTap: (value) {
                  // Updates the selected page index in HomeBloc.
                  context.read<HomeBloc>().add(GetNavBarIndex(homePageIndex: value));
                },
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.search),
                    label: 'Search',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.library_music),
                    label: 'Library',
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // List of pages to navigate between using the bottom navigation bar.
  final List<Widget> _pages = [
    const HomePage(),
    const SearchPage(),
    const LibraryPage(),
  ];
}
