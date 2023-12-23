// ignore_for_file: prefer_typing_uninitialized_variables, non_constant_identifier_names, camel_case_types, empty_constructor_bodies, unnecessary_const, prefer_const_constructors, prefer_const_literals_to_create_immutables, use_function_type_syntax_for_parameters, avoid_print, invalid_return_type_for_catch_error

import 'package:elderly_people/Routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widget/PredefinedWidgets.dart';

//add sign in page
class login_page extends StatefulWidget {
  //String error_message;
  const login_page({super.key
  //, this.error_message = ""
  });

  @override
  State<login_page> createState() => _login_pageState();
}

class _login_pageState extends State<login_page> {
  final usernamecontroller = TextEditingController();
  final pwdcontroller = TextEditingController();

  //This part for the log in part
  void SignUserIn() async {
    // showDialog(
    //   context: context,
    //   builder: (context) {
    //     return const Center(
    //       child: CircularProgressIndicator(),
    //     );
    //   },
    // );
    //This part of code is the authtication part
    try {
      //if an error is registered on the sign in part
      if (usernamecontroller.text == "") {
        PredefinedWidgets.showMyErrorDialog(context, "Email is empty",
            "Email textfield is empty.\n Please try again");
      }else if (!usernamecontroller.text.trim().isEmail) {
        PredefinedWidgets.showMyErrorDialog(context, "Email is incorrect",
            "Email is in incorrect format .Please try again");
      } else if (pwdcontroller.text == "") {
        PredefinedWidgets.showMyErrorDialog(context, "Password is empty",
            "Password textfield is empty.\n Please try again");
      } else if ((pwdcontroller.text).length < 6) {
        PredefinedWidgets.showMyErrorDialog(
            context,
            "Password is of incorrect length",
            "Password should be more than 6 letter. \n Please try again");
      } else {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: usernamecontroller.text.trim(),
          password: pwdcontroller.text,
        );
      }

      // debugPrint(usernamecontroller.text);
      // debugPrint(pwdcontroller.text);
      // debugPrint(FirebaseAuth.instance.currentUser!.email);
      // AuthPage();
      // Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      //catch is used to catch what type of error
      if (e.code == 'user-not-found') {
        //debugPrint('No user found for this email');
        PredefinedWidgets.showMyErrorDialog(context, "No user found",
            "No user was found with this email.\nPlease try again");
      }
      if (e.code == 'wrong-password') {
        //debugPrint('wrong password');
        PredefinedWidgets.showMyErrorDialog(context, "Wrong password",
            "Wrong password has been used.\nPlease try again");
      }
      if (e.code == 'invalid-email') {
        //debugPrint('wrong password');
        PredefinedWidgets.showMyErrorDialog(
            context, "Invalid email", "Input correct email.\nPlease try again");
      } else if (e.code != 'user-not-found' &&
          e.code != 'wrong-password' &&
          e.code == 'invalid-email') {
        PredefinedWidgets.showMyErrorDialog(context, e.code, "\nPlease try again");
      }
    }

    //pop up the loading
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color.fromARGB(223, 255, 251, 251),
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 248, 248, 248),
          centerTitle: true,
          title: const Text(
            "LOGIN PAGE",
            style: TextStyle(
              color: Colors.black54,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //LOGO / AVATAR IMAGE
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Icon(
                      Icons.account_circle_rounded,
                      size: 150,
                    ),
                  ),
                  //SMALL MESSAGE TO USER
                  Text(
                    "Welcome to our app",
                    style: TextStyle(fontSize: 20),
                  ),
                  //TEXTFIELD1
                  SizedBox(height: 10),
                  PredefinedWidgets.getTextField(
                      usernamecontroller, "Email", false),

                  SizedBox(height: 10),
                  PredefinedWidgets.getTextField(
                      pwdcontroller, "Password", true),

                  //TEXTFIELD2
                  //CONTAINER FOR BUTTON SIGN UP AND LOG IN
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          //TRYING BUTTON
                          PredefinedWidgets.myButton(
                              context, SignUserIn, "LOG IN"),
                          SizedBox(width: 20),
                          PredefinedWidgets.myButton(context, () {
                            // Navigator.push(
                            //         context,
                            //         MaterialPageRoute(
                            //             builder: (context) =>
                            //                 RegistrationPage()),
                            //       );
                            Get.toNamed(Routes.registrationPage);
                          }, "SIGN UP")
                          // SizedBox(
                          //   width: 150,
                          //   height: 50,
                          //   child: ElevatedButton(
                          //       onPressed: () {
                          //         // Navigator.push(
                          //         //   context,
                          //         //   MaterialPageRoute(
                          //         //       builder: (context) =>
                          //         //           RegistrationPage()),
                          //         // );
                          //       },
                          //       style: ElevatedButton.styleFrom(
                          //         backgroundColor:
                          //             Colors.black, // Background color
                          //       ),
                          //       child: Text("SIGN UP")),
                          // ),
                        ],
                      ),
                    ),
                  ),
                  //Text(widget.error_message),
                  //IT SHOULD BE A ROW WITH PADDING IN THE  SHOULD BE SAME SIZE WITH THE TEXTFIELD
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
