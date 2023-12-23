import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elderly_people/widget/PredefinedWidgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddRoutine extends StatefulWidget {
  const AddRoutine({super.key});

  @override
  State<AddRoutine> createState() => _AddRoutineState();
}

class AddRoutineService {
  static Future<List<String>> getAppliancesName() async {
    CollectionReference collectionRef =
        FirebaseFirestore.instance.collection('appliances');
    QuerySnapshot snapshot = await collectionRef.get();
    List<String> applianceList = [];
    for (var doc in snapshot.docs) {
      applianceList.add(doc['name']);
    }
    return applianceList;
  }

  static String addRoutinesToDB(String routineName, String sensorForRoutine,
      int sensorThreshold, String operation, String relayConnected) {
    String check = "";
    FirebaseFirestore.instance.collection('Routines').add({
      "routineName": routineName,
      "sensorForRoutine": sensorForRoutine,
      "sensorThreshold": sensorThreshold,
      "operation": operation,
      "relayConnected": relayConnected,
    }).then((value) {
      //debugPrint("adding to DB");
      check = "success";
    }).catchError((error) {
      check = "error";
    });
    if (check == "success") {
      //print("success");
      return "success";
    } else {
      return "error";
    }
  }

  static Future<QuerySnapshot<Map<String, dynamic>>> fetchDataFromFirestore() {
    // Replace this with your own Firestore query to retrieve data
    return FirebaseFirestore.instance.collection('appliances').get();
  }
}

class _AddRoutineState extends State<AddRoutine> {
  final sensorThresholdController = TextEditingController();
  final routineNameController = TextEditingController();
  String sensorDropDownvalue = 'Choose a sensor value';
  String equationDropDownValue = 'Choose an Operations';
  String applicationDropDownValue = "Choose one application";
  List<String> listOfApplianceName = [
    "Choose one application",
  ];

  List<String> listOfOperations = <String>[
    'Choose an Operations',
    '=',
    '<',
    '>'
  ];

  List<String> listOfSensor = <String>[
    'Choose a sensor value',
    'Temperature',
    'Humidity',
    'FlameSensor'
  ];

  @override
  void initState() {
  
    super.initState();
  }
  void validate(String routineName, String sensorForRoutine,
      String sensorThreshold, String operation, String relayConnected){
    if(routineName.isEmpty){
       PredefinedWidgets.showMyErrorDialog(context, "Error",
          "Routine name is empty please try again");
    }else if(sensorThreshold.isEmpty){
       PredefinedWidgets.showMyErrorDialog(context, "Error",
          "Sensor Threshold is empty please try again");
    }
  }
  void addRoutinesToDB(String routineName, String sensorForRoutine,
      String sensorThreshold, String operation, String relayConnected) {
    FirebaseFirestore.instance.collection('Routines').add({
      "uid": Get.arguments,
      "routineName": routineName,
      "sensorForRoutine": sensorForRoutine,
      "sensorThreshold": sensorThreshold,
      "operation": operation,
      "relayConnected": relayConnected,
    }).then((value) {
      Get.back();
      PredefinedWidgets.showMySuccessDialog(
          context,
          "Routine successfully created",
          "The routine: $routineName has been successfully created");
    }).catchError((error) {
      PredefinedWidgets.showMyErrorDialog(context, "Error",
          "Could not add Routine $routineName. Please thy again");
    });
  }
  // void setAppliancename() async {
  //   listOfApplianceName = await AddRoutineService.getAppliancesName();
  //   if (listOfApplianceName.isEmpty) {
  //     applicationDropDownValue = "NO APPLIANCES AVAILABLE";
  //   } else {
  //     applicationDropDownValue = listOfApplianceName[0];
  //     //print(listOfApplianceName);

  //     //print(applicationDropDownValue);
  //   }
  // }

  Widget applianceDropDown() {
    //setAppliancename();

    if (listOfApplianceName.isEmpty) {
      return const Text("Please add appliances to set routine");
    } else {
      return Padding(
        padding: const EdgeInsets.all(10),
        child: DropdownButton<String>(
            value: applicationDropDownValue,
            items: listOfApplianceName
                .map<DropdownMenuItem<String>>((String value) {
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
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Add Routines"),
        ),
        body:SingleChildScrollView(child:SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextField(
                      controller: routineNameController,
                      //obscureText: obscuretext,
                      decoration: InputDecoration(
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey.shade400)),
                        fillColor: Colors.grey.shade200,
                        filled: true,
                        hintText: "routine name",
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: DropdownButton<String>(
                        value: sensorDropDownvalue,
                        items: listOfSensor
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            sensorDropDownvalue = newValue!;
                          });
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextField(
                      controller: sensorThresholdController,
                      //obscureText: obscuretext,
                      keyboardType: TextInputType.number,

                      decoration: InputDecoration(
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey.shade400)),
                        fillColor: Colors.grey.shade200,
                        filled: true,
                        hintText: "threshold value",
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: DropdownButton<String>(
                        value: equationDropDownValue,
                        items: listOfOperations
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            equationDropDownValue = newValue!;
                          });
                        }),
                  ),
                  FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    future: AddRoutineService.fetchDataFromFirestore(),
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
                        }
                        debugPrint("list:$listOfApplianceName");
                        //return const Text("Please add appliances 1to set routine");

                        // listOfApplianceName=['hwllo','hwllo1','hwllo2','hwllo3'];
                        // // Example: Building a Text widget with the retrieved value
                        return Padding(
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
                        );
                      }
                    },
                  ),
                  SizedBox(
                    width: 150,
                    height: 50,
                    child:
                    PredefinedWidgets.myButton(context, (){
                      addRoutinesToDB(
                              routineNameController.text,
                              sensorDropDownvalue,
                              sensorThresholdController.text,
                              equationDropDownValue,
                              applicationDropDownValue);
                        
                    }, "Submit") 
                    // ElevatedButton(
                    //     onPressed: () {
                    //       addRoutinesToDB(
                    //           routineNameController.text,
                    //           sensorDropDownvalue,
                    //           sensorThresholdController.text,
                    //           equationDropDownValue,
                    //           applicationDropDownValue);
                    //     },
                    //     style: ElevatedButton.styleFrom(
                    //       backgroundColor: Colors.black, // Background color
                    //     ),
                    //     child: const Text("SUBMIT")),
                  ),
                ],
              ),
            ),
          ),
        ))
        );
  }
}
