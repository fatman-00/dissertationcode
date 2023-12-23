import 'package:elderly_people/widget/PredefinedWidgets.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class AddAppliances extends StatefulWidget {
  const AddAppliances({super.key});

  @override
  State<AddAppliances> createState() => _AddAppliancesState();
}

class AddApplianceService {
  //db = FirebaseFirestore.instance;
  static checkDatabaseValue(
      BuildContext context, String applianceName, String relay) async {
    //print("hello");
    var snapshot = await FirebaseFirestore.instance
        .collection('appliances')
        .where("uid", isEqualTo: Get.arguments)
        .get()
        .then((value) {
      int count = 0;
      
      for (var document in value.docs) {
        //print('${document.id} => ${document.data()}');
        if (document.data()['name'] == applianceName) {
          PredefinedWidgets.showMyErrorDialog(
              context,
              "This Appliance name is already taken up",
              "The  name $applianceName is already taken up by another device. Please choose another relay or delete this one");
          count++;
          break;
        } else if (document.data()['relay'] == relay) {
          PredefinedWidgets.showMyErrorDialog(
              context,
              "This Relay is already taken up",
              "The $relay is already taken up by another device. Please choose another relay or delete this one");
          count++;
          break;
        }
      }
      if (count == 0) {
        addApplicanceToDB(context, applianceName, relay);
      }
    });
  }

  static void addApplicanceToDB(
      BuildContext context, String applianceName, String relay) {
    //print("${Get.arguments} $applianceName $relay ");
    FirebaseFirestore.instance.collection("appliances").add({
      "uid": "${Get.arguments}",
      "name": applianceName,
      "relay": relay
    }).then((value) {
      Get.back();
      PredefinedWidgets.showMySuccessDialog(
          context,
          "Appliance Successfully added",
          "The appliance $applianceName which is connected to $relay has been successfully added.");
    }).onError((error, stackTrace) {
      PredefinedWidgets.showMyErrorDialog(
          context, "Error", "Their has been an error when adding item");
    });
  }
}

class _AddAppliancesState extends State<AddAppliances> {
  final nameController = TextEditingController();
  String dropDownvalue = 'Relay1';
  List<String> listOfRelay = <String>['Relay1', 'Relay2', 'Relay3', 'Relay4'];
  @override
  void initState() {
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add appliances"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: nameController,
                //obscureText: obscuretext,
                decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade400)),
                  fillColor: Colors.grey.shade200,
                  filled: true,
                  hintText: "Appliance name",
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: DropdownButton<String>(
                  value: dropDownvalue,
                  items:
                      listOfRelay.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropDownvalue = newValue!;
                    });
                  }),
            ),
            const SizedBox(
              height: 10,
            ),
            PredefinedWidgets.myButton(context, () {
              if (nameController.text.isEmpty) {
                PredefinedWidgets.showMyErrorDialog(
                    context,
                    "Appliance name is Empty",
                    "The appliance must be named,It cannot be empty");
              } else if (dropDownvalue == "Choose an Relay") {
                PredefinedWidgets.showMyErrorDialog(
                    context,
                    "Incorrect Relay value",
                    "A Relay must be chosen,It cannot be the value 'Choose a Relay'");
              } else {
                AddApplianceService.checkDatabaseValue(
                    context, nameController.text, dropDownvalue);
              }
              // AddApplianceService.addApplicanceToDB(
              //     nameController.text, dropDownvalue);
              //debugPrint("${nameController.text} $dropDownvalue");
            }, "Add appliance"),
          ],
        ),
      ),
    );
  }
}
