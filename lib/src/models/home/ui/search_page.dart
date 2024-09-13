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

// class GridExample extends StatelessWidget {
//   const GridExample({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return GridView.builder(
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 10, // Number of columns
//         childAspectRatio: 1, // Aspect ratio of each item
//       ),
//       itemCount: 20, // Total number of items (2 rows * 10 columns)
//       itemBuilder: (context, index) {
//         return Container(
//           margin: const EdgeInsets.all(4.0),
//           color: Colors.blue[(index % 9 + 1) * 100], // Just for visual differentiation
//           child: Center(
//             child: Text(
//               '$index',
//               style: const TextStyle(color: Colors.white, fontSize: 16),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

// void main() {
//   runApp(const MaterialApp(
//     home: GridExample(),
//   ));
// }

/*
class StartBrowsingBoxAdapter extends StatelessWidget {
  const StartBrowsingBoxAdapter({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          // color: Colors.amber,
          height: 300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Start browsing",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _broswingCommonContainer(
                      context,
                      titleName: "Music",
                      imagePath:
                          "assets/images/home/favorite_artists/Arjit_Singh.jpg",
                      // "assets/images/home/favorite_artists/Neha_Kakkar.png",
                    ),
                    const SizedBox(width: 10),
                    _broswingCommonContainer(
                      context,
                      titleName: "Podcasts",
                      imagePath:
                          "assets/images/home/favorite_artists/Arjit_Singh.jpg",
                      // "assets/images/home/favorite_artists/Neha_Kakkar.png",
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Container _broswingCommonContainer(BuildContext context,
      {required String titleName, required String imagePath}) {
    return Container(
      height: 70,
      width: MediaQuery.of(context).size.width / 2.2,
      padding: EdgeInsets.only(top: 20),
      color: Colors.green[400],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 35.0, left: 15),
            child: Text(
              titleName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
          // Transform.rotate(
          //   // Angle in radians (e.g., 0.5 radians is about 28.6 degrees)
          //   angle: 0.5,
          //   child: Image.asset(imagePath, height: 100, width: 55),
          // )

          ClipRect(
            child: Align(
              alignment: Alignment.topCenter, // Align to the top
              heightFactor: 0.5, // Only show the top 50% of the image
              child: Image.asset(imagePath),
            ),
          ),
        ],
      ),
    );
  }
}
*/

// class StartBrowsingBoxAdapter extends StatelessWidget {
//   const StartBrowsingBoxAdapter({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return SliverToBoxAdapter(
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Container(
//           // color: Colors.amber,
//           height: 300,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 "Start browsing",
//                 style: TextStyle(
//                   fontSize: 15,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 10),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     _broswingCommonContainer(
//                       context,
//                       titleName: "Music",
//                       imagePath: "assets/images/home/favorite_artists/Arjit_Singh.jpg",
//                       // "assets/images/home/favorite_artists/Neha_Kakkar.png",
//                     ),
//                     const SizedBox(width: 10),
//                     _broswingCommonContainer(
//                       context,
//                       titleName: "Podcasts",
//                       imagePath: "assets/images/home/favorite_artists/Arjit_Singh.jpg",
//                       // "assets/images/home/favorite_artists/Neha_Kakkar.png",
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Container _broswingCommonContainer(
//     BuildContext context, {
//     required String titleName,
//     required String imagePath,
//   }) {
//     return Container(
//       height: 70,
//       width: MediaQuery.of(context).size.width / 2.2,
//       padding: const EdgeInsets.only(top: 20),
//       color: Colors.green[400],
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(bottom: 35.0, left: 15),
//             child: Text(
//               titleName,
//               style: const TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 15,
//               ),
//             ),
//           ),
//           ClipRect(
//             child: Align(
//               alignment: Alignment.topCenter,
//               heightFactor: 0.5, // Only show the top 50% of the image
//               // Ensure the image fits well
//               child: Image.asset(imagePath, fit: BoxFit.cover),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

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
