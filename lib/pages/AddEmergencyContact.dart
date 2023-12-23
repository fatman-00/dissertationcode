import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elderly_people/Routes.dart';
import 'package:elderly_people/theme/Theme.dart';
import 'package:elderly_people/widget/PredefinedWidgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddEmergencyContact extends StatefulWidget {
  const AddEmergencyContact({super.key});

  @override
  State<AddEmergencyContact> createState() => _AddEmergencyContactState();
}

class AddEmergencyContactService {
  static addContactInfoToDB(
      String uID, String name, String phone, String message) async {
    // late var documentID;
    // QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
    //     .instance
    //     .collection("user")
    //     .where("uid", isEqualTo: uID)
    //     .get();

    // List<QueryDocumentSnapshot<Map<String, dynamic>>> documents = snapshot.docs;

    // for (QueryDocumentSnapshot<Map<String, dynamic>> document in documents) {
    //   documentID = document.id;
    // }
    // String msg = await FirebaseFirestore.instance
    //     .collection('user/$documentID/contactInfo')
    //     .add({
    //   'name': name,
    //   'ContactNumber': phone,
    //   'message': message,
    // }).then((value) {
    //   return "success";
    // }).catchError((error) {
    //   return "error";
    // });
    // return msg;
    String msg =
        await FirebaseFirestore.instance.collection("contactInfo").add({
      "uid": uID,
      'name': name,
      'ContactNumber': phone,
      'message': message,
    }).then((value) {
      return 'success';
    }).catchError((error) {
       return "error";
    });
    return msg;
  }
}

class _AddEmergencyContactState extends State<AddEmergencyContact> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    messageController.text = "I need your immediate assistance.";
    super.initState();
  }

  Future<void> validateTextField() async {
    if (nameController.text.isEmpty) {
      PredefinedWidgets.showMyErrorDialog(
          context, "Name is empty", "Emergency contact's name is empty");
    } else if (phoneController.text.isEmpty) {
      PredefinedWidgets.showMyErrorDialog(
          context, "Phone is empty", "Phone number is empty");
    } else if (messageController.text.isEmpty) {
      PredefinedWidgets.showMyErrorDialog(
          context, "Message is empty", "Emergency contact 1 message is empty");
    } else if ((nameController.text.isEmpty &&
            phoneController.text.isNotEmpty) ||
        (nameController.text.isNotEmpty && phoneController.text.isEmpty)) {
      PredefinedWidgets.showMyErrorDialog(
          context,
          "Only one textfield is filled for contact 1",
          "please fill both fields (name and phone for emergency contact 1)");
    } else if ((nameController.text.isNotEmpty &&
        phoneController.text.isNotEmpty &&
        messageController.text.isNotEmpty)) {
      //getting user ID
      String uID = FirebaseAuth.instance.currentUser!.uid;

      String msg1 = await AddEmergencyContactService.addContactInfoToDB(uID,
          nameController.text, phoneController.text, messageController.text);
      // await FirebaseFirestore.instance
      //     .collection('user/$documentID/contactInfo')
      //     .add({
      //   'name': nameController.text,
      //   'ContactNumber': phoneController.text,
      //   'message': messageController.text,
      // }).then((value) {
      //   PredefinedWidgets.showMySuccessDialog(
      //       context, "Success", "${nameController.text} successfully added");
      // }).catchError((error) {
      //   PredefinedWidgets.showMyErrorDialog(
      //       context, "Error", "Error adding ${nameController.text}");
      // });
      if (msg1 == "success") {
        PredefinedWidgets.showMySuccessDialog(
            context, "Success", "${nameController.text} successfully added");
        Get.offAllNamed(Routes.home);
        //Get.offNamed(Routes.home);
      } else {
        PredefinedWidgets.showMyErrorDialog(
            context, "Error", "Error adding ${nameController.text}");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 15, right: 15, top: 10),
                child: Center(
                    child: Text(
                  "Add Emergency contact",
                  style: CustomTextStyle.heading1,
                )),
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Row(
                  children: [
                    Expanded(
                        child: Column(children: <Widget>[
                      const Text("Emergency contact :",
                          style: CustomTextStyle.heading2),
                      PredefinedWidgets.getTextField(
                          nameController, "Enter name ", false),
                      PredefinedWidgets.getNumberTextField(
                          phoneController, "Enter phone number ", false),
                      PredefinedWidgets.getTextField(
                          messageController, "Enter message", false),
                      SizedBox(height: 4), // Adjust the height as needed
                      const Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'A predefined message has been written',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ])),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Center(
                child: PredefinedWidgets.myButton(
                    context, validateTextField, "Submit"),
              ),
              const SizedBox(
                width: 10,
              )
            ],
          ),
        ),
      ),
    );
  }
}
