import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elderly_people/model/RoutineModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/TimerRoutines.dart';
import '../widget/PredefinedWidgets.dart';

class EditRoutine extends StatefulWidget {
  const EditRoutine({super.key});

  @override
  State<EditRoutine> createState() => _EditRoutineState();
}

class EditRoutineService {
  static Future<QuerySnapshot<Map<String, dynamic>>> fetchDataFromFirestore() {
    // Replace this with your own Firestore query to retrieve data
    return FirebaseFirestore.instance.collection('appliances').orderBy('relay', descending: false).get();
  }
}

class _EditRoutineState extends State<EditRoutine> {
  TextEditingController routineName = TextEditingController();
  TextEditingController message = TextEditingController();
  final timeController = TextEditingController();
  String applicationDropDownValue = "Choose one application";
  List<String> relayConnected = [];
  final Map<String, String> applianceRelay = {};
  String relay1 = "";
  String relay2 = "";
  String relay3 = "";
  String relay4 = "";

  List<String> listOfApplianceName = [
    "Choose one application",
  ];
  void validate(String docID, String routineName, String time,
      Map<String, int> rValue, String message) {
    if (routineName.isEmpty) {
      PredefinedWidgets.showMyErrorDialog(
          context, "Error", "Routine name is empty please try again");
    } else if (time.isEmpty) {
      PredefinedWidgets.showMyErrorDialog(
          context, "Error", "Time is empty please try again");
    } else {
      //print("${applianceRelay[application]}$routineName $time $application $applianceRelay");
      addToDatabase(docID, routineName, time, rValue, message);
    }
  }

  Future<Map<String, int>> getCurrentValue(String docID) async {
    DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
        .collection('Routines')
        .doc(docID)
        .get();
    Map<String, int> relay = {};
    if (docSnapshot.exists) {
      // Document exists, you can access its data
      Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
      int r1, r2, r3, r4;

      // Access data fields by their names, for example:
      r1 = data['Relay1'];
      r2 = data['Relay2'];
      r3 = data['Relay3'];
      r4 = data['Relay4'];

      relay = {"Relay1": r1, "Relay2": r2, "Relay3": r3, "Relay4": r4};
      ;
    } else {
      print('Document does not exist.');
    }
    return relay;
  }

  Future<void> addToDatabase(String docID, String routineName, String time,
      Map<String, int> rValue, String message) async {
    int relay1Val = 0;
    int relay2Val = 0;
    int relay3Val = 0;
    int relay4Val = 0;
    Map<String, int> dBrelay = await getCurrentValue(docID);
    print("hellowhkjsdhf${dBrelay}");

    if (rValue.isEmpty) {
      RoutineModel routine = Get.arguments;
      relay1Val = routine.Relay1;
      relay2Val = routine.Relay2;
      relay3Val = routine.Relay3;
      relay4Val = routine.Relay4;
      //print(relay1Val);
    } else {
      if (rValue['Relay1'] != null) {
        relay1Val = rValue["Relay1"]!;
      } else {
        relay1Val = dBrelay['Relay1']!;
      }
      if (rValue['Relay2'] != null) {
        relay2Val = rValue["Relay2"]!;
      } else {
        relay2Val = -1;
      }
      if (rValue['Relay3'] != null) {
        relay3Val = rValue["Relay3"]!;
      } else {
        relay3Val = dBrelay['Relay3']!;
      }
      if (message.isEmpty) {
        message = "null";
      }
      if (rValue['Relay4'] != null) {
        relay4Val = rValue["Relay4"]!;
      } else {
        relay4Val = dBrelay['Relay4']!;
      }
    }
    RoutineModel rm = Get.arguments;
    print(
        '$docID ${rm.uID} , $routineName, $time,$relay1Val,$relay2Val,$relay3Val,$relay4Val');
    await FirebaseFirestore.instance.collection("Routines").doc(docID).update({
      "uid": rm.uID,
      "routineName": routineName,
      "time": time,
      "Relay1": relay1Val,
      "Relay2": relay2Val,
      "Relay3": relay3Val,
      "Relay4": relay4Val,
      "message": message,
    }).then((value) {
      TimerRoutines.change = true;
      if (TimerRoutines.change == true) {
        print("li vrai");
      } else {
        print("li pas vrai");
      }
      Get.back();
      PredefinedWidgets.showMySuccessDialog(
          context,
          "Routine successfully updated",
          "The routine: $routineName has been successfully updated");
    }).catchError((error) {
      PredefinedWidgets.showMyErrorDialog(context, "Error",
          "Could not update Routine $routineName. Please try again");
      print(error.toString());
    });
  }

  int _value = 0;
  late List<int> radioValue;
  Map<String, int> rValue = {};
  late String docID;
  Map<String, int> dbval = {};
  @override
  void initState() {
    RoutineModel routine = Get.arguments;
    routineName.text = routine.name;
    docID = routine.docID;

    message.text = routine.message;
    timeController.text = routine.time;
    radioValue = [
      routine.Relay1,
      routine.Relay2,
      routine.Relay3,
      routine.Relay4
    ];
    setRadioVal(docID);
    super.initState();
  }

  void setRadioVal(String docID) async {
    Map<String, int> dbval = await getCurrentValue(docID);

    radioValue = [
      dbval["Relay1"]!,
      dbval["Relay2"]!,
      dbval["Relay3"]!,
      dbval["Relay4"]!,
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit routine"),
      ),
      body: SingleChildScrollView(
          child: SafeArea(
              child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Center(
                      child: Column(children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: PredefinedWidgets.getTextField(
                            routineName, "Enter rotine name", false)),
                    FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        future: EditRoutineService.fetchDataFromFirestore(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                                snapshot) {
                          if (!snapshot.hasData) {
                            // If there is an error retrieving data
                            return const Text(
                                "Please add appliances to set routine");
                          } else {
                            listOfApplianceName = ["Choose one application"];
                            for (var doc in snapshot.data!.docs) {
                              listOfApplianceName.add(doc['name']);
                              //relayConnected.add(doc['relay']);
                              applianceRelay[doc['name']] = doc['relay'];
                            }
                            //debugPrint("list:$listOfApplianceName");
                            return ListView.builder(
                                shrinkWrap: true,
                                itemCount: snapshot
                                    .data!.docs.length, // THE NUMBER OF ITEMS
                                itemBuilder: (context, index) {
                                  final DocumentSnapshot documentSnapshot =
                                      snapshot.data!.docs[index];
                                  // databaseCheckBoxVal = documentSnapshot['complete'];
                                  // taskDate = documentSnapshot['date'];
                                  //print(documentSnapshot['name']);
                                  return Card(
                                    margin: const EdgeInsets.all(10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.3 -
                                              40,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              documentSnapshot['name'],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.7,
                                          child: Row(
                                            children: <Widget>[
                                              Radio(
                                                  value: -1,
                                                  groupValue: radioValue[index],
                                                  onChanged: (value) {
                                                    setState(() {
                                                      rValue[documentSnapshot[
                                                          'relay']] = value!;
                                                      radioValue[index] = value;
                                                    });
                                                    print(rValue);
                                                  }),
                                              const Text("No action"),
                                              Radio(
                                                  value: 1,
                                                  groupValue: radioValue[index],
                                                  onChanged: (value) {
                                                    setState(() {
                                                      rValue[documentSnapshot[
                                                          'relay']] = value!;
                                                      radioValue[index] = value;
                                                    });

                                                    print(rValue);
                                                  }),
                                              const Text("On"),
                                              Radio(
                                                  value: 0,
                                                  groupValue: radioValue[index],
                                                  onChanged: (value) {
                                                    setState(() {
                                                      rValue[documentSnapshot[
                                                          'relay']] = value!;
                                                      radioValue[index] =
                                                          value!;
                                                    });
                                                    print(rValue);
                                                  }),
                                              const Text("Off"),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                });
                          }
                        }),
                    PredefinedWidgets.getTextField(
                        message, "Enter message", false),
                    Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextField(
                          readOnly: true,
                          controller: timeController,
                          decoration:
                              const InputDecoration(hintText: 'Pick your Time'),
                          onTap: () async {
                            var time = await showTimePicker(
                                context: context, initialTime: TimeOfDay.now());

                            if (time != null) {
                              timeController.text = time.format(context);
                            }
                          },
                        )),
                    SizedBox(
                        width: 150,
                        height: 50,
                        child: PredefinedWidgets.myButton(context, () {
                          validate(docID, routineName.text, timeController.text,
                              rValue, message.text);
                        }, "Submit"))
                  ]))))),
    );
  }
  // @override
  // void initState() {

  //   routineName.text = routine.name;
  //   timeController.text = routine.time;
  //   super.initState();
  // }
  // RoutineModel routine = Get.arguments;
  // TextEditingController routineName = TextEditingController();
  // final timeController = TextEditingController();
  // String applicationDropDownValue = "Choose one application";
  // List<String> relayConnected = [];
  // final Map<String, String> applianceRelay = {};
  // List<String> listOfApplianceName = [
  //   "Choose one application",
  // ];
  // void validate(String docID,String routineName, String time, String application) {
  //   if (routineName.isEmpty) {
  //     PredefinedWidgets.showMyErrorDialog(
  //         context, "Error", "Routine name is empty please try again");
  //   } else if (time.isEmpty) {
  //     PredefinedWidgets.showMyErrorDialog(
  //         context, "Error", "Time is empty please try again");
  //   } else if (application == "Choose one application") {
  //     PredefinedWidgets.showMyErrorDialog(
  //         context, "Error", "Please choose an application");
  //   } else {
  //     //print("${applianceRelay[application]}$routineName $time $application $applianceRelay");
  //     updateToDatabase(docID,routineName, time, applianceRelay[application]!);
  //   }
  // }

  // Future<void> updateToDatabase(String docID,String routineName, String time, String relay) async {
  //    await FirebaseFirestore.instance.collection("Routines").doc(docID).update(
  //       {"routineName":routineName,"time":time,"relayConnected":relay}).then((value) {
  //     TimerRoutines.change = true;
  //     Get.back();
  //     PredefinedWidgets.showMySuccessDialog(
  //         context,
  //         "Routine successfully update",
  //         "The routine: $routineName has been successfully update");
  //   }).catchError((error) {
  //     PredefinedWidgets.showMyErrorDialog(context, "Error",
  //         "Could not add Routine $routineName. Please try again");
  //   });
  // }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: const Text("Edit routine"),
  //     ),
  //     body: SingleChildScrollView(
  //         child: SafeArea(
  //             child: Padding(
  //                 padding: const EdgeInsets.all(10.0),
  //                 child: Center(
  //                     child: Column(children: <Widget>[
  //                   Padding(
  //                       padding: const EdgeInsets.all(10.0),
  //                       child: PredefinedWidgets.getTextField(
  //                           routineName, "Enter rotine name", false)),
  //                   FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
  //                     future: EditRoutineService.fetchDataFromFirestore(),
  //                     builder: (BuildContext context,
  //                         AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
  //                             snapshot) {
  //                       if (!snapshot.hasData) {
  //                         // If there is an error retrieving data
  //                         return const Text(
  //                             "Please add appliances to set routine");
  //                       } else {
  //                         // Data retrieval successful, build your widget using the retrieved data
  //                         // final data = snapshot.data?.data();
  //                         //QuerySnapshot snapshot = await collectionRef.get();
  //                         listOfApplianceName = ["Choose one application"];
  //                         for (var doc in snapshot.data!.docs) {
  //                           listOfApplianceName.add(doc['name']);
  //                           //relayConnected.add(doc['relay']);
  //                           applianceRelay[doc['name']] = doc['relay'];
  //                         }

  //                         return Padding(
  //                           padding: const EdgeInsets.all(10),
  //                           child: DropdownButton<String>(
  //                               value: applicationDropDownValue,
  //                               items: listOfApplianceName
  //                                   .map<DropdownMenuItem<String>>(
  //                                       (String value) {
  //                                 return DropdownMenuItem<String>(
  //                                   value: value,
  //                                   child: Text(value),
  //                                 );
  //                               }).toList(),
  //                               onChanged: (String? newValue) {
  //                                 setState(() {
  //                                   applicationDropDownValue = newValue!;
  //                                 });
  //                               }),
  //                         );
  //                       }
  //                     },
  //                   ),
  //                   Padding(
  //                       padding: const EdgeInsets.all(16.0),
  //                       child: TextField(
  //                         readOnly: true,
  //                         controller: timeController,
  //                         decoration:
  //                             const InputDecoration(hintText: 'Pick your Time'),
  //                         onTap: () async {
  //                           var time = await showTimePicker(
  //                               context: context, initialTime: TimeOfDay.now());

  //                           if (time != null) {
  //                             timeController.text = time.format(context);
  //                           }
  //                         },
  //                       )),
  //                   SizedBox(
  //                       width: 150,
  //                       height: 50,
  //                       child: PredefinedWidgets.myButton(context, () {
  //                         validate(routine.docID,routineName.text, timeController.text,
  //                             applicationDropDownValue);
  //                       }, "Submit"))
  //                 ]))))),
  //   );
  // }
}
