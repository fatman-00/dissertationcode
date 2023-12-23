import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elderly_people/pages/ListMedecinePage.dart';
import 'package:elderly_people/widget/PredefinedWidgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditMedicinePage extends StatefulWidget {
  const EditMedicinePage({super.key});

  @override
  State<EditMedicinePage> createState() => _EditMedicinePageState();
}

class EditMedecineService {
  static validate(String docID,String uID, BuildContext context, String name, String dosage,
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
      updateMedecineToDatabase(docID,uID, context, name, dosage, time);
    }
  }

  static updateMedecineToDatabase(String docID,String uID, BuildContext context, String name,
      String dosage, String time) async {

     await FirebaseFirestore.instance.collection("Medicine").doc(docID).update(
        {"Medicine Name":name,"dosage":dosage,"time":time}).then((value) {
      Get.back();
      PredefinedWidgets.showMySuccessDialog(
          context, "Success", "Medicine  has been successfully updated");
    }).catchError((error) {
      PredefinedWidgets.showMyErrorDialog(context, "Error",
          "Something seems to have gone wrong. Please try again later");
    });
  }
}

class _EditMedicinePageState extends State<EditMedicinePage> {
  TextEditingController medecineName = TextEditingController();

  TextEditingController dosage = TextEditingController();

  TextEditingController type = TextEditingController();

  String initialvalue = "Choose the time for medication";

  MedicineModel med = Get.arguments;

  List<String> listOfTime = <String>[
    "Choose the time for medication",
    "morning",
    "noon",
    "night",
  ];
  late String uID;
  late String docID;
  @override
  void initState() {
    uID = FirebaseAuth.instance.currentUser!.uid;
    medecineName.text = med.medicineName;
    dosage.text = med.dosage;
    initialvalue = med.time;
    docID=med.docID;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Edit Medicine")),
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
                EditMedecineService.validate(med.docID, 
                    uID, context, medecineName.text, dosage.text, initialvalue);
              }, "SUBMIT")
            ],
          ),
        ));
  }
}
