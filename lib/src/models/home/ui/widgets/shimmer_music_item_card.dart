import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerMusicItemCard extends StatelessWidget {
  const ShimmerMusicItemCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: SizedBox(
        height: 240,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 5, // Number of shimmer items to display
          itemBuilder: (context, index) {
            // return _shimmerMusicItemCard(); // Shimmer effect
            return Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 180,
                    height: 180,
                    color: Colors.white, // Placeholder for the shimmer effect
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: 180,
                    height: 20,
                    color: Colors.white, // Placeholder for text shimmer
                  ),
                  // const SizedBox(height: 5),
                  // Container(
                  //   width: 150,
                  //   height: 20,
                  //   color: Colors.white, // Placeholder for singer name shimmer
                  // ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
