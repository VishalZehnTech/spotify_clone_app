import 'package:flutter/material.dart';
import 'package:spotify/src/models/drawer/ui/drawer_page.dart';
import 'package:spotify/src/widgets/common_app_bar_leading.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const DrawerPage(),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            pinned: false,
            expandedHeight: 50,
            leading: CommonAppBarLeading(scaffoldKey: _scaffoldKey),
            title:
                const Text("Search", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.camera_alt_outlined,
                  size: 25,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SliverPersistentHeader(
            pinned: true, // This ensures the search bar stays pinned at the top
            delegate: SearchBarDelegate(),
          ),
          // const StartBrowsingBoxAdapter(),
        ],
      ),
    );
  }
}

class SearchBarDelegate extends SliverPersistentHeaderDelegate {
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.search,
            color: Colors.black,
          ),
          hintText: 'What do you want to listen to?',
          hintStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          border: const OutlineInputBorder(
            // borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey[200],
        ),
      ),
    );
  }

  @override
  double get maxExtent => 60.0;

  @override
  double get minExtent => 60.0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
