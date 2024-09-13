import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/src/log_Bloc/log_bloc.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close, size: 30)),
        backgroundColor: Colors.black,
        title: const Text(
          "Edit profile",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          TextButton(
              onPressed: () {},
              child: const Text(
                "Save",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ))
        ],
      ),
      body: BlocBuilder<LogBloc, LogState>(
        builder: (context, state) {
          return Container(
            color: Colors.black,
            // width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10.0, bottom: 10),
                        child: Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: state.userModel?.photoUrl == null
                                ? const CircleAvatar(backgroundColor: Colors.black)
                                : Image.network("${state.userModel?.photoUrl}",
                                    height: 130, width: 130, fit: BoxFit.cover),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, top: 10, bottom: 0),
                  child: Row(
                    children: [
                      const Text(
                        "Name",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 30),
                      Expanded(
                        child: TextFormField(
                          decoration: const InputDecoration(
                            hintText: "Your name",
                            hintStyle: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15),
                  child: Container(
                    height: 1,
                    decoration: const BoxDecoration(color: Colors.white),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
