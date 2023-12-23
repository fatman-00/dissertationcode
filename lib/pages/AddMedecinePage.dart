import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elderly_people/widget/PredefinedWidgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddMedecinePage extends StatefulWidget {
  const AddMedecinePage({super.key});

  @override
  State<AddMedecinePage> createState() => _AddMedecinePageState();
}

class AddMedecineService {
  static validate(String uID, BuildContext context, String name, String dosage,
      String time) {
    if (name.isEmpty) {
      PredefinedWidgets.showMyErrorDialog(context, "Error",
          "Name cannot be empty.Please enter a name for the medicine");
    } else if (dosage.isEmpty) {
      PredefinedWidgets.showMyErrorDialog(context, "Error",
          "Dosage cannot be empty.Please enter a Dosage for the medicine");
    } else if (time == "Choose the time for medication") {
      PredefinedWidgets.showMyErrorDialog(
          context, "Error", "Please choose a value for time");
    } else {
      addMedecineToDatabase(uID, context, name, dosage, time);
    }
  }

  static addMedecineToDatabase(String uID, BuildContext context, String name,
      String dosage, String time) {
    FirebaseFirestore.instance.collection('Medicine').add({
      "uID": uID,
      "Medicine Name": name,
      "dosage": dosage,
      "time": time,
    }).then((value) {
      Get.back();
      PredefinedWidgets.showMySuccessDialog(
          context, "Success", "Medicine $name has been successfully added");
    }).onError((error, stackTrace) {
      PredefinedWidgets.showMyErrorDialog(context, "Error",
          "Something seems to have gone wrong. Please try again later");
    });
  }
}

class _AddMedecinePageState extends State<AddMedecinePage> {
  TextEditingController medecineName = TextEditingController();

  TextEditingController dosage = TextEditingController();

  TextEditingController type = TextEditingController();

  String initialvalue = "Choose the time for medication";

  List<String> listOfTime = <String>[
    "Choose the time for medication",
    "morning",
    "noon",
    "night",
  ];
  late String uID;
  @override
  void initState() {
    uID = FirebaseAuth.instance.currentUser!.uid;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Add Medicine")),
        body: Center(
          child: Column(
            children: <Widget>[
              PredefinedWidgets.getTextField(
                  medecineName, "Enter The name of your medicine", false),
              const SizedBox(
                height: 10,
              ),
              PredefinedWidgets.getNumberTextField(
                  dosage, "Enter The name of your Dosage", false),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: DropdownButton<String>(
                    value: initialvalue,
                    items: listOfTime
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        initialvalue = newValue!;
                      });
                    }),
              ),
              PredefinedWidgets.myButton(context, () {
                AddMedecineService.validate(
                    uID, context, medecineName.text, dosage.text, initialvalue);
              }, "SUBMIT")
            ],
          ),
        ));
  }
}
