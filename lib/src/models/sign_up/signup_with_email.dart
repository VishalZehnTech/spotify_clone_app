import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/src/log_Bloc/log_bloc.dart';
import 'package:spotify/src/models/log_in/ui/log_in_page.dart';

class SignupWithEmail extends StatefulWidget {
  const SignupWithEmail({super.key});

  @override
  State<SignupWithEmail> createState() => _SignupWithEmailState();
}

class _SignupWithEmailState extends State<SignupWithEmail> {
  int _currentIndex = 1;
  final passwordController = TextEditingController();
  final passwordFocusNode = FocusNode();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final emailFocusNode = FocusNode();
  final emailController = TextEditingController();

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
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _addEmailAddressMethod(context),
          _createPasswordMethod(context),
          // _addEmailAddressMethod(context),
          _selectGenderMethod(context),
        ],
      ),
    );
  }

  void _pageChangeMethod() {
    setState(() {
      if (_currentIndex < 3) {
        // Ensure you don't exceed the number of pages
        _currentIndex++;
      } else {
        // Optionally loop back to the first page or perform some other action
        // _currentIndex = 0;
        // Navigator.pushNamed(context, "/TempPage");
        // Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => TempPage()));
        context.read<LogBloc>().add(const LogInPage() as LogEvent);
        // context.read<>()
      }
    });
  }

  // Method to Add email address
  Form _addEmailAddressMethod(BuildContext context) {
    return Form(
      key: formKey, // Key for the form
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0, left: 15.0, right: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("What's your email address?", style: _commonTextStyleForTitle()),
            const SizedBox(height: 10),
            EmailTextFieldWidget(
              emailController: emailController,
              emailFocusNode: emailFocusNode,
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
                    if (formKey.currentState?.validate() == true) {
                      _pageChangeMethod();
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
    );
  }

  // Method to create password
  Form _createPasswordMethod(BuildContext context) {
    return Form(
      key: formKey, // Key for the form
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
                  (current.isVisibility != previous.isVisibility),
              builder: (context, state) {
                return TextFormField(
                  controller: passwordController,
                  focusNode: passwordFocusNode,
                  keyboardType: TextInputType.text,
                  obscureText: !state.isVisibility,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color.fromARGB(255, 70, 63, 63),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(state.isVisibility ? Icons.visibility_off : Icons.visibility),
                      onPressed: () {
                        context.read<LogBloc>().add(GetVisibility());
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value!.length < 10) {
                      return 'Use at least 10 characters';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    context.read<LogBloc>().add(GetPassword(password: value));
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
            Center(
              child: SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState?.validate() == true) {
                      _pageChangeMethod();
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
    );
  }

  // Method to choose Gender
  Padding _selectGenderMethod(BuildContext context) {
    // GenderType? selectedGender;

    List genderList = ["Male", "Female", "Non-binary", "Other", "Prefer not to say"];
    TextStyle commonTextStyleForTitle() {
      return const TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
      );
    }

    return Padding(
      // padding: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.only(top: 20.0, left: 15.0, right: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("What's your gender?", style: commonTextStyleForTitle()),
          GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              // crossAxisSpacing: 15.0,
              // mainAxisSpacing: 15.0,
              childAspectRatio: 4,
            ),
            // itemCount: GenderType.values.length,
            itemCount: genderList.length,
            itemBuilder: (context, index) {
              // final gender = GenderType.values[index];
              // final isSelected = selectedGender == gender;

              return GestureDetector(
                onTap: () {
                  // setState(() {
                  //   selectedGender = gender;
                  // });
                  // print();
                  context.read<LogBloc>().add(GetGender(genderType: GenderType.values[index]));
                  _pageChangeMethod();
                  // Navigator.push(context,
                  //     MaterialPageRoute(builder: (context) => TempPage()));
                },
                child: Container(
                  decoration: BoxDecoration(
                    // color: isSelected ? Colors.teal : Colors.grey[200],
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(
                      // color: isSelected ? Colors.teal : Colors.grey,
                      color: Colors.grey,
                      width: 1,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    genderList[index],
                    style: const TextStyle(
                      color: Colors.white,
                      //  isSelected ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
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

class EmailTextFieldWidget extends StatelessWidget {
  const EmailTextFieldWidget({
    super.key,
    required this.emailController,
    required this.emailFocusNode,
  });

  final TextEditingController emailController;
  final FocusNode emailFocusNode;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LogBloc, LogState>(
      buildWhen: (previous, current) => (current.email != previous.email),
      builder: (context, state) {
        return TextFormField(
          controller: emailController,
          focusNode: emailFocusNode,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color.fromARGB(255, 70, 63, 63),
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
          onChanged: (value) {
            context.read<LogBloc>().add(GetEmail(email: value));
          },
        );
      },
    );
  }
}
