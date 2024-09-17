import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/src/models/log_in/log_Bloc/log_bloc.dart';
import 'package:spotify/src/models/sign_up/create_password.dart';

class SignupWithEmail extends StatefulWidget {
  const SignupWithEmail({super.key});

  @override
  State<SignupWithEmail> createState() => _SignupWithEmailState();
}

class _SignupWithEmailState extends State<SignupWithEmail> {
  final emailController = TextEditingController();
  final emailFocusNode = FocusNode();
  // final _passwordController = TextEditingController();
  // final _passwordFocusNode = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    emailFocusNode.addListener(() {
      context.read<LogBloc>().add(EmailFocusChanged(hasFocus: emailFocusNode.hasFocus));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Create account",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: _addEmailAddressMethod(context),
      // _createPasswordMethod(context),
    );
  }

  // Method to Add email address
  Form _addEmailAddressMethod(BuildContext context) {
    return Form(
      key: _formKey, // Key for the form
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0, left: 15.0, right: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("What's your email address?", style: _commonTextStyleForTitle()),
            const SizedBox(height: 10),
            BlocBuilder<LogBloc, LogState>(
              buildWhen: (previous, current) =>
                  // (current.email != previous.email) ||
                  (current.isEmailFocused != previous.isEmailFocused),
              builder: (context, state) {
                return TextFormField(
                  controller: emailController,
                  focusNode: emailFocusNode,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: state.isEmailFocused
                        ? Colors.grey[600]
                        : const Color.fromARGB(255, 70, 63, 63),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) {
                    final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
                    if (value == null || value.isEmpty) {
                      return 'Email cannot be empty';
                    } else if (!emailRegex.hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                );
              },
            ),
            const SizedBox(height: 2),
            const Text(
              " You'll need to confirm this email later.",
              style: TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 15),
            Center(
              child: SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // context.read<LogBloc>().add((GetEmail(email: emailController.text.trim())));
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreatePassword(email: emailController.text.trim()),
                        ));
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                  child: const Text("Next", style: TextStyle(fontSize: 18, color: Colors.black)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  TextStyle _commonTextStyleForTitle() {
    return const TextStyle(
      fontSize: 30,
      fontWeight: FontWeight.bold,
    );
  }
}
