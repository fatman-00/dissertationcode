import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elderly_people/Routes.dart';
import 'package:elderly_people/widget/PredefinedWidgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../theme/Theme.dart';

class RegistrationPage extends StatefulWidget {
  RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class RegistrationPageService {
  final _user = FirebaseAuth.instance.currentUser!;
  //---------------------------------------------------------------------------ADD USER TO AUTH TABLE
  static Future<String> addUserToAuthTable(String email, String pwd) async {
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: email.trim(), password: pwd.trim());
    return userCredential.user!.uid;
  }

  static Future addToDoListItem(
      String uid, String title, bool check, String dueDate) async {
    await FirebaseFirestore.instance
        .collection("ToDotaks")
        .add({'uid': uid, 'title': title, 'check': check, 'dueDate': dueDate});
  }

  //---------------------------------------------------------------------------ADD USER TO 'USER' TABLE
  static Future addUserDetail(String userId, String fName, String lName) async {
    await FirebaseFirestore.instance
        .collection("user")
        .add({'uid': userId, 'fname': fName, 'lname': lName});
  }

  static createDatabaseInstance(String uid) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref(uid);
    await ref.set({
      "RELAY": {
        "RELAY1":0,
        "RELAY2":0,
        "RELAY3":0,
        "RELAY4":0,
      },
      "SENSORS":{
        "FLAME_SENSOR":1,
        "Humidity":0,
        "MOTION_SENSOR":0,
        "Temperature":0
      },
      "Reminder":{
        "Msg":"",
        "val":"0"
      },
      "Routine":{
        "Msg":"",
        "val":"0"
      }
      ,
      "Medecine":{
        "Msg":"",
        "val":"0"
      },
      "cameraImage":"gs://elderly-people-8d142.appspot.com/images/creation.png",
    });
    await FirebaseFirestore.instance
        .collection("MedicationTime")
        .add({'morning': '8:00', 'noon': '12:00', 'night': '20:00','uid': uid});
  }

  String getUserID() {
    return _user.uid;
  }

  String getUserDetails() {
    return "";
  }

  //-----------------------------------------------------------LOG OUT OF ACCOUNT
  static void logOut() {
    FirebaseAuth.instance.signOut();
  }
}

class _RegistrationPageState extends State<RegistrationPage> {
  final fnamecontroller = TextEditingController();
  final lnamecontroller = TextEditingController();
  final emailcontroller = TextEditingController();
  final pwdcontroller = TextEditingController();
  final retypepwdcontroller = TextEditingController();
  //FIREBASE FOR SIGN UP
  void signUp() async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });

    //---------------------------------------------------------------------------------SIGN UP WITH FIREBASE
    try {
      if (fnamecontroller.text.isEmpty) {
        navigator!.pop(context);
        PredefinedWidgets.showMyErrorDialog(
            context, "first name is empty", "Please fill in first name");
      } else if (lnamecontroller.text.isEmpty) {
        navigator?.pop();
        PredefinedWidgets.showMyErrorDialog(
            context, "Last name is empty", "Please fill in last name");
      } else if (emailcontroller.text.isEmpty) {
        navigator?.pop();
        PredefinedWidgets.showMyErrorDialog(
            context, "Email is empty", "Please fill in email");
      } else if (pwdcontroller.text.isEmpty) {
        navigator?.pop();
        PredefinedWidgets.showMyErrorDialog(
            context, "Password is empty", "Please fill in password ");
      } else if (retypepwdcontroller.text.isEmpty) {
        navigator?.pop();
        PredefinedWidgets.showMyErrorDialog(
            context,
            "Confirm password is empty is empty",
            "Please retype your password");
      } else if (!emailcontroller.text.isEmail) {
        navigator?.pop();
        PredefinedWidgets.showMyErrorDialog(context, "Email incorrect",
            "Email is in incorrect format.Please retype password");
      } else if (pwdcontroller.text == retypepwdcontroller.text) {
        String userId = await RegistrationPageService.addUserToAuthTable(
            emailcontroller.text, pwdcontroller.text);
        print(userId);

        //FirebaseAuth.instance.currentUser!.uid;

        ////-------------------------------------------------------------------------------------ADD USER TO FIRESTORE
        RegistrationPageService.createDatabaseInstance(userId);
        RegistrationPageService.addUserDetail(
                userId, fnamecontroller.text, lnamecontroller.text)
            .then((value) {
          Navigator.pop(context);
          PredefinedWidgets.showMyDialog(
              context, "Success", "You have successfully registered");
        });

        Future.delayed(const Duration(seconds: 2), () {
          Get.offAllNamed(Routes.addEmergencyContact);
        });
      } else {
        //debugPrint("Wrong password");
        Navigator.pop(context);
        PredefinedWidgets.showMyErrorDialog(context, "Password doesn't match",
            "The password you've entered does match with the above one.Please try again");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        Navigator.pop(context);
        PredefinedWidgets.showMyErrorDialog(context, "Email already in use",
            "The email you've is already in use.Please try again");
      }
      if (e.code == 'weak-password') {
        Navigator.pop(context);
        PredefinedWidgets.showMyErrorDialog(context, "Password is weak",
            "The password you've entered is weak.The pass word should be at least 6 characters.Please try again");
      } else {
        PredefinedWidgets.showMyErrorDialog(
            context, e.code, e.message as String);
      }
    }
    ;
  } //END OF SIGN UP

//---------------------------------------------------------------------------------------ALERT MESSAGE DIALOG

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Feature for scrollable VI
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text("Sign up page"),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                //LOGO / AVATAR IMAGE
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.account_box_rounded,
                    size: 100,
                  ),
                ),
                const Text(
                  "Please fill in your details.",
                  style: TextStyle(fontSize: 20),
                ),
                // FIRST NAME TEXTFIELD
                PredefinedWidgets.getTextField(
                  fnamecontroller,
                  "FIRST NAME",
                  false,
                ),
                //LAST NAME TEXTFIELD
                PredefinedWidgets.getTextField(
                  lnamecontroller,
                  "LAST NAME",
                  false,
                ),
                //EMAIL TEXT FIELD
                PredefinedWidgets.getTextField(
                  emailcontroller,
                  "EMAIL",
                  false,
                ),
                //PASSWORD TEXTFIELD
                PredefinedWidgets.getTextField(
                  pwdcontroller,
                  "PASSWORD",
                  true,
                ),
                //RETYPE TEXTFIELD
                PredefinedWidgets.getTextField(
                  retypepwdcontroller,
                  "RE-TYPE PASSWORD",
                  true,
                ),
                //
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 50,
                      width: 150,
                      child: ElevatedButton.icon(
                        onPressed: () => signUp(),
                        icon: const Icon(
                          Icons.check,
                          color: Colors.white,
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black, // Background color
                        ),
                        label: const Text("CONFIRM",
                            style: CustomTextStyle.buttonText),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                      height: 60,
                    ),
                    SizedBox(
                      height: 50,
                      width: 150,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Get.offNamed(Routes.authPage);
                        },
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red, // Background color
                        ),
                        label: const Text("CANCEL",
                            style: CustomTextStyle.buttonText),
                      ),
                    ),
                  ],
                )

                //SMALL MESSAGE TO USER
              ],
            ),
          ),
        ),
      ),
    );
  }
}
