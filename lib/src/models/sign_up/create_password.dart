import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/src/models/home/ui/home_nav_bar_page.dart';
import 'package:spotify/src/models/log_in/log_Bloc/log_bloc.dart';

class CreatePassword extends StatefulWidget {
  final String? email;
  const CreatePassword({super.key, this.email});

  @override
  State<CreatePassword> createState() => _CreatePasswordState();
}

class _CreatePasswordState extends State<CreatePassword> {
  final _passwordFocusNode = FocusNode();
  final _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _passwordFocusNode.addListener(() {
      context.read<LogBloc>().add(PasswordFocusChanged(hasFocus: _passwordFocusNode.hasFocus));
    });
  }

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Create account",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white)),
      ),
      body: _createPasswordMethod(context),
    );
  }

  // Method to create password
  Form _createPasswordMethod(BuildContext context) {
    return Form(
      key: _formKey, // Key for the form
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0, left: 15.0, right: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Create a password", style: _commonTextStyleForTitle()),
            const SizedBox(height: 5),
            BlocBuilder<LogBloc, LogState>(
              buildWhen: (previous, current) =>
                  (current.password != previous.password) ||
                  (current.isPasswordFocused != previous.isPasswordFocused) ||
                  (current.isVisibility != previous.isVisibility),
              builder: (context, state) {
                return TextFormField(
                  controller: _passwordController,
                  focusNode: _passwordFocusNode,
                  keyboardType: TextInputType.text,
                  obscureText: !state.isVisibility,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: state.isPasswordFocused
                        ? Colors.grey[600]
                        : const Color.fromARGB(255, 70, 63, 63),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        state.isVisibility ? Icons.visibility_off : Icons.visibility,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        context.read<LogBloc>().add(GetVisibility());
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value!.length < 6) {
                      return 'Use at least 6 characters';
                    }
                    return null;
                  },
                );
              },
            ),
            const SizedBox(height: 2),
            const Text(
              " Your password needs to be at least 10 characters long.",
              style: TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 15),
            BlocListener<LogBloc, LogState>(
              listener: (BuildContext context, LogState state) {
                if (state.loginStatus == LoginStatus.success) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeNavBarPage()),
                  );
                } else if (state.loginStatus == LoginStatus.failed) {
                  debugPrint("\nFailed\n");
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Incorrect Password, Try again Error')),
                  );
                } else if (state.loginStatus == LoginStatus.error) {
                  debugPrint("\nError\n");
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                    // const SnackBar(content: Text('Incorrect Password, Try again Error')),
                  );
                }
              },
              child: BlocBuilder<LogBloc, LogState>(
                builder: (context, state) {
                  return Center(
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<LogBloc>().add(LogAPI(
                                email: "${widget.email}",
                                password: _passwordController.text.trim(),
                                logFieldStatus: LogFieldStatus.signup,
                              ));
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                        child: const Text(
                          "Next",
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ),
                      ),
                    ),
                  );
                },
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
