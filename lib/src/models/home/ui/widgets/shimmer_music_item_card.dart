import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerMusicItemCard extends StatelessWidget {
  const ShimmerMusicItemCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!, // Base color of the shimmer effect
      highlightColor: Colors.grey[100]!, // Highlight color of the shimmer effect
      child: SizedBox(
        height: 240, // Height of the shimmer effect container
        child: ListView.builder(
          scrollDirection: Axis.horizontal, // Horizontal scroll direction
          itemCount: 5, // Number of shimmer items to display
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(left: 10.0), // Padding for left side
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // Align items to the start
                children: [
                  Container(
                    width: 180, // Width of the shimmer image placeholder
                    height: 180, // Height of the shimmer image placeholder
                    color: Colors.white, // Color of the shimmer image placeholder
                  ),
                  const SizedBox(height: 10), // Space between image and text
                  Container(
                    width: 180, // Width of the shimmer text placeholder
                    height: 20, // Height of the shimmer text placeholder
                    color: Colors.white, // Color of the shimmer text placeholder
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
