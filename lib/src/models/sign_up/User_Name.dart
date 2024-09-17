// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:spotify/src/log_Bloc/log_bloc.dart';
// import 'package:spotify/src/models/drawer_profile/bloc/profile_bloc.dart';
// import 'package:spotify/src/models/home/ui/home_nav_bar_page.dart';

// class UserNamePage extends StatefulWidget {
//   const UserNamePage({super.key});

//   @override
//   State<UserNamePage> createState() => _UserNamePageState();
// }

// class _UserNamePageState extends State<UserNamePage> {
//   final _userController = TextEditingController();
//   final _userFocusNode = FocusNode();
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//   @override
//   void initState() {
//     super.initState();
//     _userFocusNode.addListener(() {
//       context.read<LogBloc>().add(UserFocusChanged(hasFocus: _userFocusNode.hasFocus));
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: const Text(
//           "Create account",
//           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//         ),
//       ),
//       body: _add_userAddressMethod(context),
//     );
//   }

//   // Method to Add _user address
//   Form _add_userAddressMethod(BuildContext context) {
//     return Form(
//       key: _formKey,
//       autovalidateMode: AutovalidateMode.onUserInteraction,
//       child: Padding(
//         padding: const EdgeInsets.only(top: 20.0, left: 15.0, right: 15.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text("Enter user name", style: _commonTextStyleForTitle()),
//             const SizedBox(height: 10),
//             BlocBuilder<LogBloc, LogState>(
//               buildWhen: (previous, current) =>
//                   (current.userName != previous.userName) ||
//                   (current.isUserFocused != previous.isUserFocused),
//               builder: (context, state) {
//                 return TextFormField(
//                   controller: _userController,
//                   focusNode: _userFocusNode,
//                   keyboardType: TextInputType.text,
//                   decoration: InputDecoration(
//                     filled: true,
//                     fillColor: state.isUserFocused
//                         ? Colors.grey[600]
//                         : const Color.fromARGB(255, 70, 63, 63),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(8.0),
//                       borderSide: BorderSide.none,
//                     ),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter a username';
//                     }
//                     return null;
//                   },
//                 );
//               },
//             ),
//             const SizedBox(height: 15),
//             BlocConsumer<ProfileBloc, ProfileState>(
//               listener: (BuildContext context, ProfileState state) {
//                 if (state is ProfileSuccess) {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => const HomeNavBarPage(),
//                     ),
//                   );
//                 } else if (state is ProfileError) {
//                   ScaffoldMessenger.of(context)
//                       .showSnackBar(SnackBar(content: Text(state.message)));
//                 }
//               },
//               builder: (context, state) {
//                 return Center(
//                   child: SizedBox(
//                     height: 50,
//                     child: ElevatedButton(
//                       onPressed: () {
//                         if (_formKey.currentState?.validate() ?? false) {
//                           context
//                               .read<ProfileBloc>()
//                               .add(UpdateUserName(userName: _userController.text.trim()));
//                         }
//                       },
//                       style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
//                       child:
//                           const Text("Next", style: TextStyle(fontSize: 18, color: Colors.black)),
//                     ),
//                   ),
//                 );
//               },
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   TextStyle _commonTextStyleForTitle() {
//     return const TextStyle(
//       fontSize: 30,
//       fontWeight: FontWeight.bold,
//     );
//   }
// }
