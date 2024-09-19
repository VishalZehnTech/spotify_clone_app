import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/src/models/log_in/log_Bloc/log_bloc.dart';

// This widget provides a leading icon for the AppBar, which displays
// a user profile image or a placeholder if the image is not available.
class CommonAppBarLeading extends StatelessWidget {
  // Constructor for CommonAppBarLeading widget. Takes a GlobalKey<ScaffoldState> for opening the drawer.
  const CommonAppBarLeading({
    super.key,
    required GlobalKey<ScaffoldState> scaffoldKey,
  }) : _scaffoldKey = scaffoldKey;

  final GlobalKey<ScaffoldState> _scaffoldKey;

  @override
  Widget build(BuildContext context) {
    // Using BlocBuilder to rebuild the widget based on the LogBloc state.
    return BlocBuilder<LogBloc, LogState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(left: 10.0), // Add padding to the left of the icon
          child: IconButton(
            // Action to open the drawer when the icon is pressed
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            },
            icon: ClipRRect(
              borderRadius: BorderRadius.circular(50.0), // Make the image circular
              child: state.userModel?.photoUrl == null
                  // Show a placeholder if the photoUrl is null
                  ? Container(
                      color: Colors.black, // Background color of the placeholder
                      height: 50, // Height of the placeholder
                      width: 50, // Width of the placeholder (same as height for a circle)
                      child: const CircularProgressIndicator(
                        color: Colors.white, // Color of the loading indicator
                      ))
                  // Show the user's profile image if available
                  : Image.network(
                      "${state.userModel?.photoUrl}",
                      height: 50, // Height of the profile image (same as width for a circle)
                      width: 50, // Width of the profile image
                      fit: BoxFit.cover, // Cover the entire area of the circle
                    ),
            ),
          ),
        );
      },
    );
  }
}
