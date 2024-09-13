import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/src/log_Bloc/log_bloc.dart';
import 'package:spotify/src/models/Temp/Temp_Page.dart';

class P03GenderPage extends StatefulWidget {
  const P03GenderPage({super.key});

  @override
  State<P03GenderPage> createState() => _P03GenderPageState();
}

class _P03GenderPageState extends State<P03GenderPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  GenderType? selectedGender;
  List genderList = ["Male", "Female", "Non-binary", "Other", "Prefer not to say"];

  @override
  void dispose() {
    super.dispose();
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
      body: Padding(
        // padding: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.only(top: 20.0, left: 15.0, right: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("What's your gender?", style: _commonTextStyleForTitle()),
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
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => const TempPage()));
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
