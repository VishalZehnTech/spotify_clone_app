import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/src/log_Bloc/log_bloc.dart';
import 'package:spotify/src/models/home/bloc/home_bloc.dart';
import 'package:spotify/src/models/home/ui/home_page.dart';
import 'package:spotify/src/models/library/ui/library_page.dart';
import 'package:spotify/src/models/home/ui/search_page.dart';

class HomeNavBarPage extends StatefulWidget {
  const HomeNavBarPage({super.key});

  @override
  State<HomeNavBarPage> createState() => _HomeNavBarPage();
}

class _HomeNavBarPage extends State<HomeNavBarPage> {
  @override
  void initState() {
    super.initState();
    context.read<LogBloc>().add(GetUserData());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Scaffold(
          extendBody: true,
          body: _pages[state.homePageIndex],
          bottomNavigationBar: Stack(
            children: [
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
              BottomNavigationBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                type: BottomNavigationBarType.fixed,
                currentIndex: state.homePageIndex,
                onTap: (value) {
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

  final List<Widget> _pages = [
    const HomePage(),
    const SearchPage(),
    const LibraryPage(),
  ];
}
