import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/src/models/log_in/log_Bloc/log_bloc.dart';
import 'package:spotify/src/models/home/ui/home_nav_bar_page.dart';
import 'package:spotify/src/service/firebase_database.dart';

class LoginWithEmail extends StatefulWidget {
  const LoginWithEmail({super.key});

  @override
  State<LoginWithEmail> createState() => _LoginWithEmailState();
}

class _LoginWithEmailState extends State<LoginWithEmail> {
  // Focus node for email and password field
  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();

  // Controller for email and password input
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Key for form validation
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

  @override
  void initState() {
    super.initState();
    emailFocusNode.addListener(() {
      context.read<LogBloc>().add(EmailFocusChanged(hasFocus: emailFocusNode.hasFocus));
    });

    passwordFocusNode.addListener(() {
      context.read<LogBloc>().add(PasswordFocusChanged(hasFocus: passwordFocusNode.hasFocus));
    });
  }

  //
  @override
  void dispose() {
    // Dispose of focus nodes and text controllers to free up resources
    emailFocusNode.removeListener(() {
      context.read<LogBloc>().add(EmailFocusChanged(hasFocus: emailFocusNode.hasFocus));
    });
    passwordFocusNode.removeListener(() {
      context.read<LogBloc>().add(PasswordFocusChanged(hasFocus: passwordFocusNode.hasFocus));
    });
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 15.0),
        child: Form(
          key: _formKey, // Key for the form
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Email or username", style: _commonTextStyleForTitle()),
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
                      border: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email or username can\'t be empty';
                      }
                      // Uncomment and use if email validation is needed
                      else if (!emailRegex.hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      if (value.length == 1) {
                        context.read<LogBloc>().add(GetEmail(email: value));
                      }
                    },
                  );
                },
              ),
              const SizedBox(height: 15),
              Text("Password", style: _commonTextStyleForTitle()),
              const SizedBox(height: 10),
              BlocBuilder<LogBloc, LogState>(
                buildWhen: (previous, current) =>
                    (current.isVisibility != previous.isVisibility) ||
                    (current.password != previous.password) ||
                    (current.isFormValid != previous.isFormValid) ||
                    (current.isPasswordFocused != previous.isPasswordFocused),
                builder: (context, state) {
                  return TextFormField(
                    controller: passwordController,
                    focusNode: passwordFocusNode,
                    keyboardType: TextInputType.text,
                    // Hide text based on visibility
                    obscureText: !state.isVisibility,
                    decoration: InputDecoration(
                      filled: true,
                      // fillColor: const Color.fromARGB(255, 70, 63, 63),
                      fillColor: state.isPasswordFocused
                          ? Colors.grey[600]
                          : const Color.fromARGB(255, 70, 63, 63),
                      border: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          state.isVisibility ? Icons.visibility : Icons.visibility_off,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          // Dispatch event to toggle password visibility
                          context.read<LogBloc>().add(GetVisibility());
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password can\'t be empty';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      if (value.length == 1) {
                        context.read<LogBloc>().add(GetPassword(password: value));
                      }
                    },
                  );
                },
              ),
              const SizedBox(height: 20),
              BlocListener<LogBloc, LogState>(
                listener: (context, state) {
                  if (state.loginStatus == LoginStatus.success) {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => const HomeNavBarPage()));
                  } else if (state.loginStatus == LoginStatus.failed ||
                      state.loginStatus == LoginStatus.error) {
                    // ScaffoldMessenger.of(context).showSnackBar(
                    //   SnackBar(
                    //     content: Text(state.message.toString()),
                    //     backgroundColor: Colors.red,
                    //   ),
                    // );
                  }
                },
                child: BlocBuilder<LogBloc, LogState>(
                  buildWhen: (previous, current) => (current.isFormValid != previous.isFormValid),
                  builder: (context, state) {
                    return Center(
                      child: SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: state.isFormValid
                              ? () {
                                  if (_formKey.currentState?.validate() == true) {
                                    context.read<LogBloc>().add(LogAPI(
                                        email: emailController.text.trim(),
                                        password: passwordController.text.trim(),
                                        logFieldStatus: LogFieldStatus.login));
                                  }
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: state.isFormValid ? Colors.white : Colors.grey,
                          ),
                          child: const Text("Log in",
                              style: TextStyle(fontSize: 18, color: Colors.black)),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: InkWell(
                  onTap: () {},
                  child: Container(
                    // Optional padding inside the border
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      // Set the border color and width
                      border: Border.all(color: Colors.white, width: .15),
                      // Optional: Add rounded corners
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: const Text(
                      "Log in without password",
                      style:
                          TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextStyle _commonTextStyleForTitle() {
    return const TextStyle(
      fontSize: 25,
      fontWeight: FontWeight.bold,
    );
  }
}
