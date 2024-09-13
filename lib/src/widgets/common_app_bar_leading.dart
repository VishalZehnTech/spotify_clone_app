import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/src/log_Bloc/log_bloc.dart';

class CommonAppBarLeading extends StatelessWidget {
  const CommonAppBarLeading({
    super.key,
    required GlobalKey<ScaffoldState> scaffoldKey,
  }) : _scaffoldKey = scaffoldKey;

  final GlobalKey<ScaffoldState> _scaffoldKey;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LogBloc, LogState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: IconButton(
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            },
            // icon: ClipOval(
            //   // borderRadius: BorderRadius.circular(50.0), // Set th
            //   child: state.userModel?.photoUrl == null
            //       ? const CircleAvatar(backgroundColor: Colors.black)
            //       : Image.network("${state.userModel?.photoUrl}",
            //           height: 50, width: 65, fit: BoxFit.cover),
            // ),
            icon: ClipRRect(
              borderRadius: BorderRadius.circular(50.0), // Set th
              child: state.userModel?.photoUrl == null
                  ? Container(
                      color: Colors.black,
                      height: 50, // Set height and width to the same value for a perfect circle
                      width: 50,
                      child: const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 30, // Adjust icon size to fit within the circle
                      ),
                    )
                  : Image.network(
                      "${state.userModel?.photoUrl}",
                      height: 50, // Set height and width to the same value for a perfect circle
                      width: 50,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
        );
      },
    );
  }
}
