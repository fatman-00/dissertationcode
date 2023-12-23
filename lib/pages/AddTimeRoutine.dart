import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elderly_people/widget/PredefinedWidgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/TimerRoutines.dart';

class AddTimeRoutine extends StatefulWidget {
  const AddTimeRoutine({super.key});

  @override
  State<AddTimeRoutine> createState() => _AddTimeRoutineState();
}

class AddTimeRoutineService {
  static Future<QuerySnapshot<Map<String, dynamic>>> fetchDataFromFirestore() {
    // Replace this with your own Firestore query to retrieve data
    return FirebaseFirestore.instance.collection('appliances').get();
  }
}

class _AddTimeRoutineState extends State<AddTimeRoutine> {
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
  void validate(String routineName, String time, Map<String, int> rValue,
      String message) {
    if (routineName.isEmpty) {
      PredefinedWidgets.showMyErrorDialog(
          context, "Error", "Routine name is empty please try again");
    } else if (time.isEmpty) {
      PredefinedWidgets.showMyErrorDialog(
          context, "Error", "Time is empty please try again");
    } else if (rValue.isEmpty) {
      PredefinedWidgets.showMyErrorDialog(
          context, "Error", "Please choose at least one device");
    } else {
      //print("${applianceRelay[application]}$routineName $time $application $applianceRelay");
      addToDatabase(routineName, time, rValue, message);
    }
  }

  void addToDatabase(String routineName, String time, Map<String, int> rValue,
      String message) {
    int relay1Val = 0;
    int relay2Val = 0;
    int relay3Val = 0;
    int relay4Val = 0;
    if (rValue['Relay1'] != null) {
      relay1Val = rValue["Relay1"]!;
    } else {
      relay1Val = -1;
    }
    if (rValue['Relay2'] != null) {
      relay2Val = rValue["Relay2"]!;
    } else {
      relay2Val = -1;
    }
    if (rValue['Relay3'] != null) {
      relay3Val = rValue["Relay3"]!;
    } else {
      relay3Val = -1;
    }
    if (message.isEmpty) {
      message = "null";
    }
    if (rValue['Relay4'] != null) {
      relay4Val = rValue["Relay4"]!;
    } else {
      relay4Val = -1;
    }
    FirebaseFirestore.instance.collection('Routines').add({
      "uid": Get.arguments,
      "routineName": routineName,
      "time": time,
      "Relay1": relay1Val,
      "Relay2": relay2Val,
      "Relay3": relay3Val,
      "Relay4": relay4Val,
      "message": message,
    }).then((value) {
      TimerRoutines.change = true;
      Get.back();
      PredefinedWidgets.showMySuccessDialog(
          context,
          "Routine successfully created",
          "The routine: $routineName has been successfully created");
    }).catchError((error) {
      PredefinedWidgets.showMyErrorDialog(context, "Error",
          "Could not add Routine $routineName. Please try again");
    });
  }

  //int _value = 0;
  late List<int> radioValue;
  Map<String, int> rValue = {};
  @override
  void initState() {
    radioValue = [-1, -1, -1, -1];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add routine"),
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
                    // StreamBuilder(
                    //     stream: FirebaseFirestore.instance
                    //         .collection('appliances')
                    //         .snapshots(),
                    //     builder: (BuildContext context,
                    //         AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                    //       if (streamSnapshot.hasData) {
                    //         return ListView.builder(
                    //             shrinkWrap: true,
                    //             itemCount: streamSnapshot
                    //                 .data!.docs.length, // THE NUMBER OF ITEMS
                    //             itemBuilder: (context, index) {
                    //               final DocumentSnapshot documentSnapshot =
                    //                   streamSnapshot.data!.docs[index];
                    //               // databaseCheckBoxVal = documentSnapshot['complete'];
                    //               // taskDate = documentSnapshot['date'];
                    //               print(documentSnapshot['name']);
                    //               return Card(
                    //                 margin: const EdgeInsets.all(10),
                    //                 child: Row(
                    //                   mainAxisAlignment:
                    //                       MainAxisAlignment.spaceBetween,
                    //                   children: <Widget>[
                    //                     SizedBox(
                    //                       width: MediaQuery.of(context)
                    //                                   .size
                    //                                   .width *
                    //                               0.4 -
                    //                           40,
                    //                       child: Padding(
                    //                         padding: const EdgeInsets.all(8.0),
                    //                         child: Text(
                    //                           documentSnapshot['name'],
                    //                         ),
                    //                       ),
                    //                     ),
                    //                     Row(

                    //                       children: <Widget>[

                    //                       ],
                    //                     ),
                    //                   ],
                    //                 ),
                    //               );
                    //             });
                    //       } else {
                    //         return const Center(
                    //             child: Text("No Appliances available"));
                    //       }
                    //     }),
                    FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        future: AddTimeRoutineService.fetchDataFromFirestore(),
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
                                                      radioValue[index] =
                                                          value;
                                                    });
                                                    //print(rValue);
                                                  }),
                                              const Text("No action"),
                                              Radio(
                                                  value: 1,
                                                  groupValue: radioValue[index],
                                                  onChanged: (value) {
                                                    setState(() {
                                                      rValue[documentSnapshot[
                                                          'relay']] = value!;
                                                      radioValue[index] =
                                                          value!;
                                                    });

                                                    //print(rValue);
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
                                                    //print(rValue);
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
                        message, "Enter message", false)
                    /*FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      future: AddTimeRoutineService.fetchDataFromFirestore(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                              snapshot) {
                        if (!snapshot.hasData) {
                          // If there is an error retrieving data
                          return const Text(
                              "Please add appliances to set routine");
                        } else {
                          // Data retrieval successful, build your widget using the retrieved data
                          // final data = snapshot.data?.data();
                          //QuerySnapshot snapshot = await collectionRef.get();
                          listOfApplianceName = ["Choose one application"];
                          for (var doc in snapshot.data!.docs) {
                            listOfApplianceName.add(doc['name']);
                            //relayConnected.add(doc['relay']);
                            applianceRelay[doc['name']] = doc['relay'];
                          }
                          //debugPrint("list:$listOfApplianceName");
                          //return const Text("Please add appliances 1to set routine");

                          // listOfApplianceName=['hwllo','hwllo1','hwllo2','hwllo3'];
                          // // Example: Building a Text widget with the retrieved value
                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: DropdownButton<String>(
                                    value: applicationDropDownValue,
                                    items: listOfApplianceName
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        applicationDropDownValue = newValue!;
                                      });
                                    }),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          );
                        }
                      },
                    ),*/
                    ,
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
                          validate(routineName.text, timeController.text,
                              rValue, message.text);
                        }, "Submit"))
                  ]))))),
    );
  }
}
