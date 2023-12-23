import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elderly_people/widget/PredefinedWidgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddUserGuide extends StatefulWidget {
  const AddUserGuide({super.key});

  @override
  State<AddUserGuide> createState() => _AddUserGuideState();
}

class AddUserGuideService {
  static void validate(
      BuildContext context, String uID, String title, String desc) {
    if (title.isEmpty) {
      PredefinedWidgets.showMyErrorDialog(context, "Error", "Title is empty");
    } else if (desc.isEmpty) {
      PredefinedWidgets.showMyErrorDialog(
          context, "Error", "Description is empty");
    } else {
      addItemToDB(context, uID, title, desc);
    }
  }

  static void addItemToDB(
      BuildContext context, String uID, String title, String desc) {
    FirebaseFirestore.instance.collection('UserGuide').add({
      "uID": uID,
      "title": title,
      "desc": desc,
    }).then((value) {
      Get.back();
      PredefinedWidgets.showMySuccessDialog(
          context, "Success", "Guide $title has been successfully added");
    }).onError((error, stackTrace) {
      PredefinedWidgets.showMyErrorDialog(context, "Error",
          "Something seems to have gone wrong. Please try again later");
    });
  }
}

class _AddUserGuideState extends State<AddUserGuide> {
  late String uID;
  TextEditingController title = TextEditingController();
  TextEditingController desc = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    uID = FirebaseAuth.instance.currentUser!.uid;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add user guide"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            PredefinedWidgets.getTextField(title, "Enter title", false),
            const SizedBox(
              height: 10,
            ),
            PredefinedWidgets.getTextField(desc, "Enter description", false),
            const SizedBox(
              height: 10,
            ),
            PredefinedWidgets.myButton(context, () {
              AddUserGuideService.validate(context, uID, title.text, desc.text);
            }, "Submit")
          ],
        ),
      ),
    );
  }
}
