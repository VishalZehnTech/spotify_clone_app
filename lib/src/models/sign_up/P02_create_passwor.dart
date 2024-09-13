import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/src/log_Bloc/log_bloc.dart';

class P02CreatePasswor extends StatefulWidget {
  const P02CreatePasswor({super.key});

  @override
  State<P02CreatePasswor> createState() => _P02CreatePassworState();
}

class _P02CreatePassworState extends State<P02CreatePasswor> {
  // Focus node for email and password field
  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();

  // Controller for email and password input
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Key for form validation
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  get name => null;

  @override
  void dispose() {
    // Dispose of focus nodes and text controllers to free up resources
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Create account",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white),
        ),
      ),
      body: Form(
        key: formKey, // Key for the form
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Padding(
          // padding: const EdgeInsets.all(8.0),
          padding: const EdgeInsets.only(top: 20.0, left: 15.0, right: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Create a password", style: _commonTextStyleForTitle()),
              const SizedBox(height: 5),
              BlocBuilder<LogBloc, LogState>(
                buildWhen: (previous, current) =>
                    (current.password != previous.password) ||
                    (current.isVisibility != previous.isVisibility),
                builder: (context, state) {
                  return TextFormField(
                    controller: passwordController,
                    focusNode: passwordFocusNode,
                    keyboardType: TextInputType.text,
                    // Hide text based on visibility
                    obscureText: !state.isVisibility,
                    // decoration: InputDecoration(
                    decoration: InputDecoration(
                      // Enables the background fill
                      filled: true,
                      // Background color
                      fillColor: const Color.fromARGB(255, 70, 63, 63),
                      border: OutlineInputBorder(
                        // Rounded corners and No border when not focused
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide.none,
                      ),
                      // ),
                      // border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(state.isVisibility ? Icons.visibility_off : Icons.visibility),
                        onPressed: () {
                          // Dispatch event to toggle password visibility
                          context.read<LogBloc>().add(GetVisibility());
                        },
                      ),
                    ),
                    validator: (value) {
                      // if (value == null || value.isEmpty) {
                      if (value!.length < 10) {
                        return 'Use at least 10 Charactres';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      // Update email in Bloc
                      context.read<LogBloc>().add(GetPassword(password: value));
                    },
                  );
                },
              ),
              const SizedBox(height: 2),
              const Text(
                " Your password needs to be at least 10 charactres long.",
                style: TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 15),
              Center(
                child: SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState?.validate() == true) {
                        // Trigger Log event
                        context.read<LogBloc>().add(LogAPI(
                            email: emailController.text,
                            password: passwordController.text,
                            logFieldStatus: LogFieldStatus.login));
                      }
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                    child: const Text(
                      "Next",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
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
