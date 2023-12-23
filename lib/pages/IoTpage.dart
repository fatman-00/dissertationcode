import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elderly_people/Routes.dart';
import 'package:elderly_people/theme/Theme.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IoTPage extends StatefulWidget {
  const IoTPage({super.key});

  @override
  State<IoTPage> createState() => _IoTPageState();
}

class theme {
  static const TextStyle t1 = TextStyle(
    fontSize: 20,
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle t2 = TextStyle(
    fontSize: 15,
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );
}

class SensorData {
  late num temperature;
  late num humidity;
  late num flameSenor;
  late int motionSensor;
  SensorData(num temp, num hum, num flame, int motion) {
    temperature = temp;
    humidity = hum;
    flameSenor = flame;
    motionSensor = motion;
  }
}

class AppliancesModel {
  String docID;
  String name;
  String relay;
  String uID;
  AppliancesModel(this.docID, this.name, this.relay, this.uID);
}

class IoTPageDB {
  static late String userID;
  static Future<void> writeLedValue() async {
    String userId = getUserID();
    DatabaseReference ref = FirebaseDatabase.instance.ref();
    await ref.update({"$userId/LED_STATUS1": 1}).then((value) => {
          //debugPrint("success")
        });
  }

  static Future<void> writeRelay1Value(bool val) async {
    String userId = getUserID();
    DatabaseReference ref = FirebaseDatabase.instance.ref("$userId/RELAY");

    if (val == true) {
      await ref.update({"RELAY1": 1});
    } else {
      await ref.update({"RELAY1": 0});
    }
  }

  static Future<void> writeRelay2Value(bool val) async {
    String userId = getUserID();
    DatabaseReference ref = FirebaseDatabase.instance.ref("$userId/RELAY");
    if (val == true) {
      await ref.update({"RELAY2": 1});
    } else {
      await ref.update({"RELAY2": 0});
    }
  }

  static Future<void> writeRelay3Value(bool val) async {
    String userId = getUserID();
    DatabaseReference ref = FirebaseDatabase.instance.ref("$userId/RELAY");
    if (val == true) {
      await ref.update({"RELAY3": 1});
    } else {
      await ref.update({"RELAY3": 0});
    }
  }

  static Future<void> writeRelay4Value(bool val) async {
    String userId = getUserID();
    DatabaseReference ref = FirebaseDatabase.instance.ref("$userId/RELAY");
    if (val == true) {
      await ref.update({"RELAY4": 1});
    } else {
      await ref.update({"RELAY4": 0});
    }
  }

  static StreamBuilder getTemperatureValue() {
    String userId = getUserID();
    return StreamBuilder(
      stream: FirebaseDatabase.instance
          .ref()
          .child("$userId/SENSORS/Temperature")
          .onValue,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}', style: theme.t2);
        } else if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
          return const Text('No data available', style: theme.t2);
        }
        final itemValue = snapshot.data!.snapshot.value.toString();
        return Text("$itemValue°C", style: theme.t2);
      },
    );
  }

  static StreamBuilder getHumidityValue() {
    var auth = FirebaseAuth.instance.currentUser!;
    String userId = auth.uid;
    return StreamBuilder(
      stream: FirebaseDatabase.instance
          .ref()
          .child("$userId/SENSORS/Humidity")
          .onValue,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}', style: theme.t2);
        } else if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
          return const Text('No data available', style: theme.t2);
        }
        final itemValue = snapshot.data!.snapshot.value.toString();
        return Text("$itemValue%", style: theme.t2);
      },
    );
  }

  static Future<List<Map<String, dynamic>>> getApplianceFromDB() async {
    String userId = getUserID();
    //print(userId);
    Stream<QuerySnapshot<Map<String, dynamic>>> collectionRef =
        FirebaseFirestore.instance
            .collection('appliances')
            .where("uid", isEqualTo: userId)
            .snapshots();

    //QuerySnapshot snapshot = await collectionRef.get();

    Map<String, dynamic> collectionData = {};

    List<Map<String, dynamic>> buttonList = [];
    await collectionRef.listen((QuerySnapshot<Map<String, dynamic>> snapshot) {
      if (snapshot.size == 0) {
        buttonList.add(["No application available"] as Map<String, dynamic>);
      } else {
        for (var document in snapshot.docs) {
          Map<String, dynamic>? item = document.data();
          AppliancesModel appModel = AppliancesModel(
              document.id, item['uid'], item['name'], item['relay']);
          collectionData[appModel.relay] = document.data();

          buttonList.add(collectionData[appModel.relay]);
          //print(buttonList);
        }
      }
    });

    // for (var doc in snapshot.docs) {
    //   AppliancesModel appModel = AppliancesModel(
    //       docId: doc.id,
    //       uid: doc['uid'],
    //       name: doc['name'],
    //       relay: doc['relay']

    //       );
    //   collectionData[appModel.relay] = doc.data();
    //   buttonList.add(collectionData[appModel.relay]);
    return buttonList;
    //Map<String, dynamic> firstMap = buttonList[0];
    //print(firstMap["name"]);
  }

  static Future<List<Map<String, dynamic>>> getDataFromStream() async {
    List<Map<String, dynamic>> itemList = [];
    List<Map<String, dynamic>> itemList1 = [];

    Stream<QuerySnapshot<Map<String, dynamic>>> collectionRef =
        FirebaseFirestore.instance
            .collection('appliances')
            .where("uid", isEqualTo: getUserID())
            .snapshots();
    await collectionRef.forEach((QuerySnapshot<Map<String, dynamic>> snapshot) {
      for (var document in snapshot.docs) {
        Map<String, dynamic> item = document.data();
        itemList.add(item);
        //4 debugPrint("\n normal");

        debugPrint("hello$itemList");
      }
      itemList1 = itemList;
    });
    //debugPrint("\n normal");

    return itemList1;
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getRoutine() {
    String userId = getUserID();
    return FirebaseFirestore.instance
        .collection('Routines')
        .where('uid', isEqualTo: userId)
        .snapshots();
  }

  static void setUserID() {
    userID = FirebaseAuth.instance.currentUser!.uid;
  }

  static String getUserID() {
    if (userID.isEmpty) {
      userID = FirebaseAuth.instance.currentUser!.uid;
      return userID;
    } else {
      return userID;
    }
  }

  static getInitialRelayValue() async {
    String userId = getUserID();
    DatabaseReference ref = FirebaseDatabase.instance.ref("$userId/RELAY");
    DatabaseEvent event = await ref.once();
    DataSnapshot snapshot = event.snapshot;
    //print(event.snapshot.value);
    Map<String, dynamic> convertItem = {};
    if (snapshot.value != null) {
      Map<dynamic, dynamic> values =
          Map<dynamic, dynamic>.from(snapshot.value as Map<dynamic, dynamic>);

      values.forEach((key, value) {
        //print("Key: $key, Value: $value");
        if (value == 0) {
          convertItem[key] = false;
        } else if (value == 1) {
          convertItem[key] = true;
        }
      });
      //print(convertItem.length);
    } else {
      //print("No data available");
    }
    List<bool> list;
    list = [
      convertItem['RELAY1'],
      convertItem['RELAY2'],
      convertItem['RELAY3'],
      convertItem['RELAY4']
    ];
    print(list);
    return list;

    //Map<String, dynamic> myMap = {};
  }

  static void routine() {}
  // static num getTemperatureValue() {
  //   try {
  //     SensorData s = SensorData(0, 0, 0);
  //     DatabaseReference ref = FirebaseDatabase.instance
  //         .ref()
  //         .child("SENSORS"); // gets a reference for Sensor

  //     ref.onValue.listen((DatabaseEvent event) {
  //       var snapshot = event.snapshot;
  //       final data = event.snapshot.value as Map?;
  //       // ignore: unused_local_variable
  //       if (snapshot.value != null) {
  //         print(data);
  //         s.temperature = data?['Temperature'];
  //         s.humidity = data?['Humidity'];
  //         s.flameSenor = data?['FLAME_SENSOR'];

  //         //context.read.<SensorDataProvider>().setTemperature(data?['Temperature']);
  //         // context.watch<temp>().setTemperature(s.temperature);
  //         // context.select((Model model) => model.valueThatNeverChanges);
  //         debugPrint("${s.temperature} ");
  //         debugPrint("${s.humidity}");
  //         debugPrint("${s.flameSenor}");
  //       } else {
  //         debugPrint("null");
  //       }
  //     });
  //     debugPrint("${s.temperature} ");

  //     return s.temperature;
  //   } catch (e) {
  //     debugPrint("$e");
  //     rethrow;
  //   }
  // }
}

class _IoTPageState extends State<IoTPage> {
  ScrollController _controller = ScrollController();
  late SensorData s;
  late String _temp = "";
  bool val1 = false;
  bool val2 = false;
  bool val3 = false;
  var auth = FirebaseAuth.instance.currentUser!;
  late List<bool> CupertinoSwitchValue = [false, false, false, false];
  late String userId;
  IoTPageDB data = IoTPageDB();
  List<Map<String, dynamic>> itemList = [];

  @override
  initState() {
    super.initState();
    userId = auth.uid;
    IoTPageDB.setUserID();
    //setButtton();
    //getButtonInitialVal(userId);
  }
// void setButtonState() {
//     // Simulating an asynchronous task
//     Future.delayed(Duration(seconds: 2), () {
//       setState(() {
//         isButtonEnabled = true;
//       });
//     });
//   }
  // void getButtonInitialVal(String uID) async {
  //   DatabaseReference ref = FirebaseDatabase.instance.ref("$uID/RELAY");
  //   DatabaseEvent event = await ref.once();
  //   DataSnapshot snapshot = event.snapshot;
  //   //print(event.snapshot.value);
  //   Map<String, dynamic> convertItem = {};
  //   if (snapshot.value != null) {
  //     Map<dynamic, dynamic> values =
  //         Map<dynamic, dynamic>.from(snapshot.value as Map<dynamic, dynamic>);

  //     values.forEach((key, value) {
  //       //print("Key: $key, Value: $value");
  //       if (value == 0) {
  //         convertItem[key] = false;
  //       } else if (value == 1) {
  //         convertItem[key] = true;
  //       }
  //     });
  //     //print(convertItem.length);
  //   } else {
  //     //print("No data available");
  //   }
  //   List<bool> list;
  //   list = [
  //     convertItem['RELAY1'],
  //     convertItem['RELAY2'],
  //     convertItem['RELAY3'],
  //     convertItem['RELAY4']
  //   ];
  //   print(list);
  //   CupertinoSwitchValue = list;
  // }

  Future<void> setButtton() async {
    CupertinoSwitchValue = await IoTPageDB.getInitialRelayValue();
  }

  Future<List<Map<String, dynamic>>> getDataFromStream() async {
    //print(userId);

    Stream<QuerySnapshot<Map<String, dynamic>>> collectionRef =
        FirebaseFirestore.instance
            .collection('appliances')
            .where("uid", isEqualTo: userId)
            .snapshots();
    await collectionRef.forEach((QuerySnapshot<Map<String, dynamic>> snapshot) {
      for (var document in snapshot.docs) {
        Map<String, dynamic> item = document.data();
        itemList.add(item);
        //4 debugPrint("\n normal");

        //debugPrint("hello$itemList");
      }
    });

    return itemList;
  }

  onChangeMethod(bool val, String relay) {
    if (relay == "Relay1") {
      //print("$val $relay");
      IoTPageDB.writeRelay1Value(val);
    } else if (relay == "Relay2") {
      //print("$val $relay");
      IoTPageDB.writeRelay2Value(val);
    } else if (relay == "Relay3") {
      //print("$val $relay");
      IoTPageDB.writeRelay3Value(val);
    } else if (relay == "Relay4") {
      //print("$val $relay");
      IoTPageDB.writeRelay4Value(val);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  decoration: CustomTextStyle.darkModeBox,
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.thermostat_outlined,
                            color: Colors.white,
                            size: 48.0,
                          ),
                          const SizedBox(width: 8.0),
                          Text(
                            'Temperature',
                            style: CustomTextStyle.darkModetextStyle.copyWith(
                              fontSize: 18.0,
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          IoTPageDB.getTemperatureValue(),
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.water_drop_outlined,
                            color: Colors.white,
                            size: 48.0,
                          ),
                          const SizedBox(width: 8.0),
                          Text(
                            'Humidity',
                            style: CustomTextStyle.darkModetextStyle.copyWith(
                              fontSize: 18.0,
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          IoTPageDB.getHumidityValue(),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.95,
                  height: MediaQuery.of(context).size.width * 0.6,
                  decoration: CustomTextStyle.darkModeBox,
                  child: Column(
                    children: <Widget>[
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.95,
                        child: Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      children: [
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        Text(
                                          "Appliances",
                                          style: CustomTextStyle
                                              .darkModetextStyle
                                              .copyWith(
                                            fontSize: 18.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              Get.toNamed(
                                                  Routes.listAppliances);
                                            },
                                            icon: const Icon(
                                              Icons.edit,
                                              color: Colors.white,
                                              size: 32.0,
                                            )),
                                        IconButton(
                                            onPressed: () {
                                              Get.toNamed(Routes.addAppliances,
                                                  arguments:
                                                      IoTPageDB.getUserID());
                                            },
                                            icon: const Icon(Icons.add_box,
                                                color: Colors.white,
                                                size: 32.0)),
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            )),
                      ),
                      Flexible(
                          child: SizedBox(
                              height: 300,
                              child: /* FutureBuilder<
                                  QuerySnapshot<Map<String, dynamic>>>(
                                future: FirebaseFirestore.instance
                                    .collection('appliances')
                                    .where("uid",
                                        isEqualTo: IoTPageDB.getUserID())
                                    .get(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Text("Loading...");
                                  } else if (snapshot.hasError) {
                                    return const Text("Error");
                                  } else if (snapshot.hasData) {
                                    List<
                                            QueryDocumentSnapshot<
                                                Map<String, dynamic>>> docs =
                                        snapshot.data!.docs;
                                    if (docs.isEmpty) {
                                      return const Text(
                                          "No appliances added yet");
                                    } else {
                                      List<Map<String, dynamic>> buttonList =
                                          docs
                                              .map((doc) => doc.data())
                                              .toList();

                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10),
                                        child: Scrollbar(
                                          thumbVisibility: true,
                                          thickness: 7,
                                          controller: _controller,
                                          child: ListView.builder(
                                            itemCount: buttonList.length,
                                            controller: _controller,
                                            itemBuilder: (context, index) {
                                              Map<String, dynamic> buttonData =
                                                  buttonList[index];

                                              return Padding(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 15),
                                                      child: Text(
                                                        buttonData['name'],
                                                        style: CustomTextStyle
                                                            .darkModetextStyle
                                                            .copyWith(
                                                          fontSize: 12.0,
                                                        ),
                                                      ),
                                                    ),
                                                    const Spacer(),
                                                    CupertinoSwitch(
                                                      trackColor: Colors.white,
                                                      activeColor: Colors.green,
                                                      value:
                                                          CupertinoSwitchValue[
                                                              index],
                                                      onChanged: (newVal) {
                                                        setState(() {
                                                          CupertinoSwitchValue[
                                                              index] = newVal;
                                                          onChangeMethod(
                                                              CupertinoSwitchValue[
                                                                  index],
                                                              buttonData[
                                                                  "relay"]);
                                                        });
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      );
                                    }
                                  } else {
                                    return const Text("No data found");
                                  }
                                },
                              )*/
                                  StreamBuilder(
                                      stream: FirebaseFirestore.instance
                                          .collection('appliances')
                                          .where("uid",
                                              isEqualTo: IoTPageDB.getUserID())
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (!snapshot.hasData) {
                                          return const Text(
                                            "no appliances added yet",
                                            style:
                                                TextStyle(color: Colors.white),
                                          );
                                        } else {
                                          Map<String, dynamic> collectionData =
                                              {};
                                          List<Map<String, dynamic>>
                                              buttonList = [];
                                          for (QueryDocumentSnapshot<
                                                  Map<String, dynamic>> doc
                                              in snapshot.data!.docs) {
                                            AppliancesModel appModel =
                                                AppliancesModel(
                                                    doc.id,
                                                    doc['uid'],
                                                    doc['name'],
                                                    doc['relay']);
                                            collectionData[appModel.relay] =
                                                doc.data();
                                            buttonList.add(
                                                collectionData[appModel.relay]);
                                          }

                                          //print(buttonList[0]);
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                right: 10),
                                            child: Scrollbar(
                                                thumbVisibility: true,
                                                thickness: 7,
                                                controller: _controller,
                                                child: ListView.builder(
                                                  itemCount: buttonList.length,
                                                  controller: _controller,
                                                  itemBuilder:
                                                      (context, index) {
                                                    Map<String, dynamic>
                                                        buttonData =
                                                        buttonList[index];

                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 15),
                                                            child: Text(
                                                              buttonData[
                                                                  'name'],
                                                              style: CustomTextStyle
                                                                  .darkModetextStyle
                                                                  .copyWith(
                                                                fontSize: 12.0,
                                                              ),
                                                            ),
                                                          ),
                                                          const Spacer(),
                                                          CupertinoSwitch(
                                                              trackColor:
                                                                  Colors.white,
                                                              activeColor:
                                                                  Colors.green,
                                                              value:
                                                                  CupertinoSwitchValue[
                                                                      index],
                                                              onChanged:
                                                                  (newVal) {
                                                                setState(() {
                                                                  CupertinoSwitchValue[
                                                                          index] =
                                                                      newVal;
                                                                  onChangeMethod(
                                                                      CupertinoSwitchValue[
                                                                          index],
                                                                      buttonData[
                                                                          "relay"]);
                                                                });
                                                              })
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                )),
                                          );
                                        }
                                      })
                              // FutureBuilder<List<Map<String, dynamic>>>(
                              //             future: getDataFromStream(),
                              //             builder: (context, snapshot) {
                              //               if (!snapshot.hasData) {
                              //                 return const Text(
                              //                     "no appliances added yet");
                              //               } else {
                              //                 List<Map<String, dynamic>> buttonList =
                              //                     snapshot.data!;
                              //                 //print(buttonList[0]);
                              //                 return ListView.builder(
                              //                   itemCount: buttonList.length,
                              //                   itemBuilder: (context, index) {
                              //                     Map<String, dynamic> buttonData =
                              //                         buttonList[index];

                              //                     return Padding(
                              //                       padding: const EdgeInsets.all(10),
                              //                       child: Row(
                              //                         mainAxisAlignment:
                              //                             MainAxisAlignment
                              //                                 .spaceBetween,
                              //                         children: [
                              //                           Text(buttonData['name']),
                              //                           const Spacer(),
                              //                           CupertinoSwitch(
                              //                               trackColor: Colors.white,
                              //                               activeColor: Colors.green,
                              //                               value: CupertinoSwitchValue[
                              //                                   index],
                              //                               onChanged: (newVal) {
                              //                                 setState(() {
                              //                                   CupertinoSwitchValue[
                              //                                       index] = newVal;
                              //                                   onChangeMethod(
                              //                                       CupertinoSwitchValue[
                              //                                           index],
                              //                                       buttonData[
                              //                                           "relay"]);
                              //                                 });
                              //                               })
                              //                         ],
                              //                       ),
                              //                     );
                              //                   },
                              //                 );
                              //               }
                              //             })
                              // getAppliancesFromDB(),
                              // IoTPageDB.getApplianceFromDB()
                              )),
                      //customSwitch("button1", val1, onChangeMethod),
                      // customSwitch("button2", val2, onChangeMethod1),
                      // customSwitch("button3", val3, onChangeMethod3),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                    width: MediaQuery.of(context).size.width * 0.95,
                    height: MediaQuery.of(context).size.width * 1 / 2,
                    decoration: CustomTextStyle.darkModeBox,
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    "Routines",
                                    style: CustomTextStyle.darkModetextStyle
                                        .copyWith(
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        Get.toNamed(Routes.listRoutines);
                                      },
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.white,
                                        size: 32.0,
                                      )),
                                  IconButton(
                                      onPressed: () {
                                        Get.toNamed(Routes.addRoutines,
                                            arguments: IoTPageDB.getUserID());
                                      },
                                      icon: const Icon(Icons.add_box,
                                          color: Colors.white, size: 32.0)),
                                ],
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Flexible(
                                  child: SizedBox(
                                      height: 300,
                                      child: StreamBuilder(
                                          stream: IoTPageDB.getRoutine(),
                                          builder: (context,
                                              AsyncSnapshot<QuerySnapshot>
                                                  streamSnapshot) {
                                            if (streamSnapshot.hasData) {
                                              if (streamSnapshot
                                                  .data!.docs.isEmpty) {
                                                return const Center(
                                                    child: Text(
                                                  "No Item added yet",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ));
                                              } else {
                                                return ListView.builder(
                                                    shrinkWrap: true,
                                                    itemCount: streamSnapshot
                                                        .data!
                                                        .docs
                                                        .length, // THE NUMBER OF ITEMS
                                                    itemBuilder:
                                                        (context, index) {
                                                      final DocumentSnapshot
                                                          documentSnapshot =
                                                          streamSnapshot.data!
                                                              .docs[index];
                                                      // databaseCheckBoxVal = documentSnapshot['complete'];
                                                      // taskDate = documentSnapshot['date'];

                                                      return Card(
                                                          margin:
                                                              const EdgeInsets
                                                                  .all(10),
                                                          child: Container(
                                                            decoration:
                                                                CustomTextStyle
                                                                    .darkModeBox,
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: <Widget>[
                                                                SizedBox(
                                                                  width: MediaQuery.of(context)
                                                                              .size
                                                                              .width *
                                                                          0.5 -
                                                                      40,
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            8.0),
                                                                    child: Text(
                                                                      documentSnapshot[
                                                                          'routineName'],
                                                                      style: CustomTextStyle
                                                                          .darkModetextStyle
                                                                          .copyWith(
                                                                        fontSize:
                                                                            15.0,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Row(
                                                                  children: <Widget>[
                                                                    IconButton(
                                                                      icon:
                                                                          const Icon(
                                                                        Icons
                                                                            .visibility,
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                                      onPressed:
                                                                          () {
                                                                        // View button functionality
                                                                      },
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ));
                                                    });
                                              }
                                            } else {
                                              return const Center(
                                                  child: Text(
                                                "No Routine available",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ));
                                            }
                                          })))
                            ],
                          )
                        ],
                      ),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Widget customSwitch(String text, bool val, Function onChanegMethod) {
//   return Padding(
//     padding: const EdgeInsets.all(10),
//     child: Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(text),
//         const Spacer(),
//         CupertinoSwitch(
//             trackColor: Colors.white,
//             activeColor: Colors.green,
//             value: val,
//             onChanged: (newVal) {
//               onChanegMethod(newVal);
//               print("yess");
//             })
//       ],
//     ),
//   );
// }
