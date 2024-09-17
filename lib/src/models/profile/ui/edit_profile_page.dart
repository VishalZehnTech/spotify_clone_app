import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:spotify/src/models/log_in/log_Bloc/log_bloc.dart';
import 'package:spotify/src/models/profile/bloc/profile_bloc.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final userNameController = TextEditingController();

    // Listen to changes in userNameController and add an event to ProfileBloc
    userNameController.addListener(() {
      context.read<ProfileBloc>().add(UpdateUserNameField(userName: userNameController.text));
    });

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.close, size: 30),
        ),
        backgroundColor: Colors.black,
        title: const Text(
          "Edit profile",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
            return TextButton(
              onPressed: state.isImageUploaded || state.isSaveButtonEnabled
                  ? () {
                      if (state.isSaveButtonEnabled) {
                        context
                            .read<ProfileBloc>()
                            .add(UpdateUserName(userName: userNameController.text.trim()));
                      }
                      if (state.isImageUploaded) {
                        context.read<LogBloc>().add(GetUserData());
                      }
                      if (state.isImageUploaded && state.isSaveButtonEnabled) {
                        context
                            .read<ProfileBloc>()
                            .add(UpdateUserName(userName: userNameController.text.trim()));
                        context.read<LogBloc>().add(GetUserData());
                      }
                      Navigator.pop(context, true);
                    }
                  : null,
              child: Text(
                "Save",
                style: TextStyle(
                  fontSize: 16,
                  color: (state.isSaveButtonEnabled || state.isImageUploaded)
                      ? Colors.white
                      : Colors.grey,
                ),
              ),
            );
          }),
        ],
      ),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is ProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          return BlocBuilder<LogBloc, LogState>(
            builder: (context, logState) {
              final imageFile = state.isImageUploaded ? File(state.imageFilePath) : null;
              return Container(
                color: Colors.black,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        final pickedFile =
                            await ImagePicker().pickImage(source: ImageSource.gallery);
                        if (pickedFile != null) {
                          context
                              .read<ProfileBloc>()
                              .add(UploadProfileImage(imageFile: File(pickedFile.path)));
                        }
                      },
                      child: Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: imageFile != null
                              ? Image.file(
                                  imageFile,
                                  height: 130,
                                  width: 130,
                                  fit: BoxFit.cover,
                                )
                              : logState.userModel?.photoUrl == null
                                  ? const CircleAvatar(backgroundColor: Colors.black)
                                  : Image.network(
                                      "${logState.userModel?.photoUrl}",
                                      height: 130,
                                      width: 130,
                                      fit: BoxFit.cover,
                                    ),
                        ),
                      ),
                    ),
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
                              controller: userNameController,
                              decoration: InputDecoration(
                                hintText: logState.userModel?.name,
                                hintStyle: const TextStyle(fontSize: 16, color: Colors.grey),
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 15),
                      child: Container(
                          height: 1, decoration: const BoxDecoration(color: Colors.white)),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
