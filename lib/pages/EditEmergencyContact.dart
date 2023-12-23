import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elderly_people/widget/PredefinedWidgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/EmergencyContactModel.dart';

class EditEmergencyContact extends StatefulWidget {
  const EditEmergencyContact({super.key});

  @override
  State<EditEmergencyContact> createState() => _EditEmergencyContactState();
}

class EditEmergencyContactService {
  static validate(String docID,String uID, BuildContext context, String name, String phone,
      String message) {
    if (name.isEmpty) {
      PredefinedWidgets.showMyErrorDialog(
          context, "Name is empty", "Please put a name ");
    } else if (phone.isEmpty) {
       PredefinedWidgets.showMyErrorDialog(
          context, "Phone is empty", " Please put a phone number");
    } else if (message.isEmpty) {
       PredefinedWidgets.showMyErrorDialog(
          context, "Message is empty", "Please put a message");
    } else {
      updateContactInfoToDB(docID,uID, context, name, phone,message);
    }
  }

  static updateContactInfoToDB(String docID, String uID,BuildContext context, String name, String phone,
      String message) async {
    
    await FirebaseFirestore.instance
        .collection('contactInfo')
        .doc(docID)
        .update({'name': name,
      'ContactNumber': phone,
      'message': message,}).then((value) {
      Get.back();
      PredefinedWidgets.showMySuccessDialog(
          context, "Success", "Contact  has been successfully updated");
    }).catchError((error) {
      PredefinedWidgets.showMyErrorDialog(context, "Error",
          "Something seems to have gone wrong. Please try again later");
    });
  }
}

class _EditEmergencyContactState extends State<EditEmergencyContact> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController messageController = TextEditingController();
  late EmergencyContactModel contact;
  String uid=FirebaseAuth.instance.currentUser!.uid;
  @override
  void initState() {
    // TODO: implement initState
    contact = Get.arguments;
    nameController.text = contact.name;
    phoneController.text = contact.contactNum;
    messageController.text = contact.msg;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit emergency contact"),),
      body:
      Center(
          child: Column(
            children: <Widget>[
              PredefinedWidgets.getTextField(
                          nameController, "Enter name ", false),
              const SizedBox(
                height: 10,
              ),
              PredefinedWidgets.getNumberTextField(
                          phoneController, "Enter phone number ", false),
              const SizedBox(
                height: 10,
              ),
               PredefinedWidgets.getTextField(
                          messageController, "Enter message", false),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
      width: 150,
      height: 50,
      child: ElevatedButton(
          onPressed: () {
            showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Are you sure?'),
                        content: const Text(
                            "please make sure you've entered the correct value. if you wish to proceed press 'yes' "),
                        actions: [
                          TextButton(
                            onPressed: () {
                              // Cancel the timer when a button is pressed
                              Navigator.of(context).pop();
                              EditEmergencyContactService.validate(contact.docID,uid,context,nameController.text,phoneController.text,messageController.text);
                              
                            },
                            child: const Text('Yes'),
                          ),
                          TextButton(
                            onPressed: () {
                              // Cancel the timer when a button is pressed
                              Navigator.of(context).pop();
                            },
                            child: const Text('No'),
                          ),
                        ],
                      );
                    },
                  );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black, // Background color
          ),
          child:const Text("Submit",
          style:TextStyle(color: Colors.white),)),
    ),
              
            ],
          ),
        )
      
      /* 
      
      
      
      
      SafeArea(
    
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Row(
                  children: [
                    Expanded(
                        child: Column(children: <Widget>[
                      const Text("Emergency contact 1:",
                          style: CustomTextStyle.heading2),
                      PredefinedWidgets.getTextField(
                          nameController, "Enter name ", false),
                      PredefinedWidgets.getTextField(
                          phoneController, "Enter phone number ", false),
                      PredefinedWidgets.getTextField(
                          messageController, "Enter message", false),
                      const SizedBox(height: 4), // Adjust the height as needed
                      
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

                    context, EditEmergencyContactService.validate(contact.docID,uid,context,nameController.text,phoneController.text,messageController.text), "Submit"),
              ),
              const SizedBox(
                width: 10,
              )
            ],
          ),
        ),
      ),*/
    );
  }
}
