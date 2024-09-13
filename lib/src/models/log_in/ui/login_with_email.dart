import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/src/log_Bloc/log_bloc.dart';
import 'package:spotify/src/models/home/ui/home_nav_bar_page.dart';

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
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

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
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 15.0),
        child: Form(
          key: formKey, // Key for the form
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Email or username", style: _commonTextStyleForTitle()),
              const SizedBox(height: 10),
              BlocBuilder<LogBloc, LogState>(
                buildWhen: (previous, current) => (current.email != previous.email),
                builder: (context, state) {
                  return TextFormField(
                    controller: emailController,
                    focusNode: emailFocusNode,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Color.fromARGB(255, 70, 63, 63),
                      border: OutlineInputBorder(
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
                    // onChanged: (value) {
                    //   // Update email in Bloc
                    //   context.read<LoginBloc>().add(GetEmail(email: value));
                    // },
                  );
                },
              ),
              const SizedBox(height: 15),
              Text("Password", style: _commonTextStyleForTitle()),
              const SizedBox(height: 10),
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
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color.fromARGB(255, 70, 63, 63),
                      border: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          state.isVisibility ? Icons.visibility : Icons.visibility_off,
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
                    // onChanged: (value) {
                    //   // Update email in Bloc
                    //   context
                    //       .read<LoginBloc>()
                    //       .add(GetPassword(password: value));
                    // },
                  );
                },
              ),
              const SizedBox(height: 20),
              BlocConsumer<LogBloc, LogState>(
                // Rebuilds only when state changes
                buildWhen: (previous, current) => false,
                listener: (context, state) {
                  if (state.loginStatus == LoginStatus.success) {
                    // Clear input fields and navigate to HomePage on successful login
                    emailController.clear();
                    passwordController.clear();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomeNavBarPage(),
                      ),
                    );
                  } else if (state.loginStatus == LoginStatus.failed) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Incorrect Password, Try again'),
                      ),
                    );
                  } else if (state.loginStatus == LoginStatus.error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message.toString()),
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  return Center(
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState?.validate() == true) {
                            // Trigger login event
                            context.read<LogBloc>().add(LogAPI(
                                email: emailController.text,
                                password: passwordController.text,
                                logFieldStatus: LogFieldStatus.login));
                          }
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                        child: const Text(
                          "Log in",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  );
                },
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
