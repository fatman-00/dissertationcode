import 'package:elderly_people/widget/PredefinedWidgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangePasswordService {
  static validate(
      BuildContext context, String uID, String newPwd, String confPwd) {
    if (newPwd == "") {
      PredefinedWidgets.showMyErrorDialog(
          context, "Error", "New password Textfield is empty");
    } else if (confPwd == "") {
      PredefinedWidgets.showMyErrorDialog(
          context, "Error", "Confirm password Textfield is empty");
    } else if (newPwd != confPwd) {
      PredefinedWidgets.showMyErrorDialog(context, "Mismatch Error",
          "New password and Confirm password is not the same");
    }else if(confPwd.length<6){
      PredefinedWidgets.showMyErrorDialog(context, "Length Error",
          "New password is less than 6");
    } 
    else {
      updatePwd(context, uID, newPwd, confPwd);
    }
  }

  static updatePwd(
      BuildContext context, String uID, String newPwd, String confPwd) async {
    User? user = FirebaseAuth.instance.currentUser;

    try {
      await user!.updatePassword(newPwd).then((value) {
        Get.back();
        PredefinedWidgets.showMySuccessDialog(
            context, "Success", "Password sucessfully changed");
      });
    } catch (e) {
      PredefinedWidgets.showMyErrorDialog(
          context, "Error", "Something when wrong.Please try Login in again");
    }
  }
}

class ChangePassword extends StatelessWidget {
  ChangePassword({super.key});
  TextEditingController newPassword = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Change Password"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 10,
            ),
            PredefinedWidgets.getTextField(
                newPassword, "Enter new password", false),
            const SizedBox(
              height: 10,
            ),
            PredefinedWidgets.getTextField(
                confirmPassword, "Enter new password again", false),
            const SizedBox(
              height: 10,
            ),
            PredefinedWidgets.myButton(context, () {
              ChangePasswordService.validate(
                  context,
                  FirebaseAuth.instance.currentUser!.uid,
                  newPassword.text,
                  confirmPassword.text);
            }, "Submit")
          ],
        ),
      ),
    );
  }
}
