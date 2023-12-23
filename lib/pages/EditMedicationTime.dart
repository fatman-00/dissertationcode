import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elderly_people/utils/TimerRoutines.dart';
import 'package:elderly_people/widget/PredefinedWidgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class EditMedicationTime extends StatefulWidget {
  const EditMedicationTime({super.key});

  @override
  State<EditMedicationTime> createState() => _EditMedicationTimeState();
}

class MedicationTimeModel {
  String morning;
  String noon;
  String night;
  MedicationTimeModel(this.morning, this.noon, this.night);
}

class EditMedicationTimeService {
  static validate(String docID, String uID, BuildContext context,
      String morning, String noon, String night) {
    if (morning.isEmpty) {
      PredefinedWidgets.showMyErrorDialog(context, "Error",
          "Please choosing a time for your morning medications");
    } else if (noon.isEmpty) {
      PredefinedWidgets.showMyErrorDialog(
          context, "Error", "Please choosing a time for your noon medications");
    } else if (night.isEmpty) {
      PredefinedWidgets.showMyErrorDialog(context, "Error",
          "Please choosing a time for your night medications");
    } else {
      updateMedecineToDatabase(docID, uID, context, morning, noon, night);
    }
  }

  static updateMedecineToDatabase(String docID, String uID,
      BuildContext context, String morning, String noon, String night) async {
    await FirebaseFirestore.instance
        .collection("MedicationTime")
        .doc(docID)
        .update({"morning": morning, "noon": noon, "night": night}).then(
            (value) {
      TimerRoutines.timeChange = true;
      Get.back();
      PredefinedWidgets.showMySuccessDialog(
          context, "Success", "Medicine  has been successfully updated");
    }).catchError((error) {
      PredefinedWidgets.showMyErrorDialog(context, "Error",
          "Something seems to have gone wrong. Please try again later");
    });
  }
}

class _EditMedicationTimeState extends State<EditMedicationTime> {
  TextEditingController morning = TextEditingController();
  TextEditingController noon = TextEditingController();
  TextEditingController night = TextEditingController();
  late String uID;
  late MedicationTimeModel med;
  late String docID;
  @override
  void initState() {
    // TODO: implement initState
    uID = FirebaseAuth.instance.currentUser!.uid;
    getMedicationTime(uID);
    super.initState();
  }

  void getMedicationTime(String uID) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('MedicationTime')
        .where('uid', isEqualTo: uID)
        .get();
    if (snapshot.size != 0) {
      //print("No contact list availble");
      for (var document in snapshot.docs) {
        Map<String, dynamic> data = document.data();
        //print(data['morning']);
        docID = document.id;
        morning.text = data['morning'];
        noon.text = data['noon'];
        night.text = data['night'];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Medication Time"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Morning:",
                    style: TextStyle(fontSize: 17),
                  ),
                ),
                Expanded(
                    child: PredefinedWidgets.getTimeTextField(context, morning))
              ],
            ),
            Row(
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Noon:", style: TextStyle(fontSize: 17)),
                ),
                Expanded(
                    child: PredefinedWidgets.getTimeTextField(context, noon))
              ],
            ),
            Row(
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Night:", style: TextStyle(fontSize: 17)),
                ),
                Expanded(
                    child: PredefinedWidgets.getTimeTextField(context, night))
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            PredefinedWidgets.myButton(context, () {
              EditMedicationTimeService.validate(
                  docID, uID, context, morning.text, noon.text, night.text);
            }, "Submit")
          ],
        ),
      ),
    );
  }
}
