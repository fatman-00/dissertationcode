import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elderly_people/pages/CameraPage.dart';
import 'package:elderly_people/pages/MedecinePage.dart';
import 'package:elderly_people/pages/SettingPage.dart';
import 'package:elderly_people/widget/PredefinedWidgets.dart';
import 'package:firebase_database/firebase_database.dart';
import '../utils/Notifications.dart';
import '../utils/TimerRoutines.dart';
import '/pages/IoTpage.dart';
import '/pages/HomePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import 'CalenderPage.dart';

class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

Notifications notifi = Notifications();

class BackgroundProcessing {
  static generalCheck(String uid, BuildContext context) async {
    DatabaseReference databaseReference = FirebaseDatabase.instance.ref();
    DatabaseReference temperatureReference =
        databaseReference.child('$uid/SENSORS/Temperature');
    // Replace 'your_path' with the path to the location in the database you want to listen to
    DatabaseReference humidityReference =
        databaseReference.child('$uid/SENSORS/Humidity');
    DatabaseReference flameSensorReference =
        databaseReference.child('$uid/SENSORS/FLAME_SENSOR');
    DatabaseReference motionSensorReference =
        databaseReference.child('$uid/SENSORS/MOTION_SENSOR');
    DatabaseReference medecineReference =
        databaseReference.child('$uid/Medecine/val');
    List<Map<String, dynamic>> listOfRoutines = await checkRotines(uid);

    print('$uid/SENSORS/Temperature');

    // temperatureReference.onValue.listen((event) {
    //   // Handle the value change event
    //   var snapshot = event.snapshot;
    //   var value = snapshot.value;
    //   // print(listOfRoutines.length);

    //   // for (var i = 0; i < listOfRoutines.length; i++) {
    //   //   // print("yess");
    //   //   if ((listOfRoutines[i])['sensorForRoutine'] == 'Temperature') {
    //   //     //switchAppliances(uid, listOfRoutines, 'Temperature', value);
    //   //     //print("yess");
    //   //   }
    //   // }
    //   // Perform operations with the updated value
    //   print('Temperature Value changed: $value');
    // });

    // humidityReference.onValue.listen((event) {
    //   // Handle the value change event
    //   var snapshot = event.snapshot;
    //   var value = snapshot.value;
    //   for (var i = 0; i < listOfRoutines.length; i++) {
    //     if ((listOfRoutines[i])['sensorForRoutine'] == 'Humidity') {
    //       //switchAppliances(uid, listOfRoutines, 'Humidity', value);
    //       // print("yess");
    //     }
    //   }
    //   // Perform operations with the updated value
    //   print('Humidity Value changed: $value');
    // });
    medecineReference.onValue.listen((event) async {
      // Handle the value change event

      var snapshot = event.snapshot;
      var value = snapshot.value;

      if (value == 1) {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Medecation'),
              content: const Text('Have you taken your medications?'),
              actions: [
                TextButton(
                  onPressed: () async {
                    // Cancel the timer when a button is pressed
                    //EmergencyContact.sendMessageToContact(user);
                    //print('yes');

                    await databaseReference
                        .child('$uid/Medecine')
                        .update({"val": 0});
                    //.then(
                    //    (value) => {debugPrint("success")});
                    Navigator.of(context).pop();
                  },
                  child: const Text('Yes'),
                ),
                TextButton(
                  onPressed: () async {
                    // Cancel the timer when a button is pressed
                    print("No");
                    await databaseReference
                        .child('$uid/Medecine')
                        .update({"val": 0});
                    Navigator.of(context).pop();
                  },
                  child: const Text('No'),
                ),
              ],
            );
          },
        );
      }
      // Perform operations with the updated value
      print('Humidity Value changed: $value');
    });
    flameSensorReference.onValue.listen((event) {
      // Handle the value change event
      var snapshot = event.snapshot;
      var value = snapshot.value;
      if (value == 0) {
        notifi.sendNotification("Fire has been detected",
            "A fire has been detected.Please check it.");
        PredefinedWidgets.showMyErrorDialog(
            context, "ALERT", "A fire has been detected");
      }
      // for (var i = 0; i < listOfRoutines.length; i++) {
      //   if ((listOfRoutines[i])['sensorForRoutine'] == 'Flame sensor') {
      //     switchAppliances(uid, listOfRoutines, 'Humidity', value);
      //     // print("yess");
      //   }
      // }
      // Perform operations with the updated value
      print('Flame sensor   Value changed: $value');
    });
    motionSensorReference.onValue.listen((event) {
      // Handle the value change event
      var snapshot = event.snapshot;
      var value = snapshot.value;
      if (value == 1) {
        notifi.sendNotification("Motion has been detected",
            "A motion has been detected.Please check camera");

        PredefinedWidgets.showMyErrorDialog(context, "Motion detected",
            "Something has been detected near camera.");
      }
    });
    //should run in main
  }

  /* static switchAppliances(String uID, List<Map<String, dynamic>> lists,
      String type, var sensorValue) async {
    print("called");
    if (lists.isNotEmpty) {
      for (var i = 0; i < lists.length; i++) {
        if ((lists[i])['sensorForRoutine'] == type) {
          QuerySnapshot<Map<String, dynamic>> c = await FirebaseFirestore
              .instance
              .collection('appliances')
              .where("name", isEqualTo: (lists[i])['relayConnected'])
              .where("uid", isEqualTo: uID)
              .get();

          switch ((lists[i])['operation']) {
            case '>':
              {
                if (sensorValue > (lists[i])['sensorThreshold']) {
                  print("greater than senser value");

                  print(c.docs.length);
                  for (var documentSnapshot in c.docs) {
                    Map<String, dynamic> data = documentSnapshot.data();
                    // Access document fields using data['field_name']
                    //String relay = data['relay'];
                    //print("hello" + relay);
                    //SwitchingRelay.checkRelayValue(relay, uID);
                    // Perform desired operations with the document data
                  }
                }
              }
              break;
            case '<':
              {
                if (sensorValue < int.parse((lists[i])['sensorThreshold'])) {
                  for (var documentSnapshot in c.docs) {
                    Map<String, dynamic> data = documentSnapshot.data();

                    // Access document fields using data['field_name']
                    String relay = data['relay'];
                    //SwitchingRelay.checkRelayValue(relay, uID);
                    // Perform desired operations with the document data
                  }
                }
              }
              break;

            case '=':
              {
                if (sensorValue == (lists[i])['sensorThreshold']) {
                  for (var documentSnapshot in c.docs) {
                    Map<String, dynamic> data = documentSnapshot.data();

                    // Access document fields using data['field_name']
                    String relay = data['relay'];
                    //SwitchingRelay.checkRelayValue(relay, uID);

                    // Perform desired operations with the document data
                  }
                }
              }
              break;
            default:
          }
        }
      }
    }
  }*/

  static Future<List<Map<String, dynamic>>> checkRotines(String uID) async {
    //print(uID);
    QuerySnapshot<Map<String, dynamic>> routines = await FirebaseFirestore
        .instance
        .collection("Routines")
        .where("uid", isEqualTo: uID)
        .get();
    List<Map<String, dynamic>> dataList =
        routines.docs.map((doc) => doc.data()).toList();

    //print(dataList);

    // Perform operations with the fetched data
    return dataList;
  }
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  //Function that changes body
  void _navigateThoughPages(int index) {
    setState(() {
      //  debugPrint("$index");
      _selectedIndex = index;
    });
  }

//----------------------------------------------------------Instantiate FIREBASE AUTH AND CLOUD FIRESTORE
  final auth = FirebaseAuth.instance.currentUser!;
  final firestore = FirebaseFirestore.instance;

//-----------------------------------------------------------GETTTING AUTH UID
  late String userID;
// USE "" WHGEN DATA IS NOT REQUIRED
  CollectionReference userRef = FirebaseFirestore.instance.collection('user');

  String _displayName = '';
  bool isListening = false;

  @override
  void initState() {
    super.initState();
    userID = auth.uid;
    // Call function to get the display name for the current user
    notifi.initialisaNotifications();
    _getFirstName();
    TimerRoutines.startTimer(userID);
    BackgroundProcessing.checkRotines(userID);
    BackgroundProcessing.generalCheck(userID, context);
    //----------------------------------------------------------------------------
  }

  Future<void> _getFirstName() async {
    userRef.get().then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        // Do something with each document
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        if (data['uid'] == auth.uid) {
          setState(() {
            _displayName = data['fname'];
          });
        } else {
          // debugPrint("not working ${doc.id} ${auth.uid}");
        }
      }
    });
  }

  void startListening() {
    // Start listening logic
    isListening = true;
  }

  void onListen() {
    // onListen logic
    //print('Listening...');
    BackgroundProcessing.generalCheck(userID, context);
    //BackgroundProcessing.checkRotines(userID);
  }
  // Future<void> _getFirstName() async {
  //   //USER ID FROM AUTH
  //   String userId = auth.uid;

  //   try {
  //     DocumentSnapshot snap =
  //         await firestore.collection("user").doc(userId).get();
  //     debugPrint(userID);
  //     String firstName = snap.get('fname');
  //     setState(() {
  //       _displayName = firstName;
  //     });
  //   } catch (e) {
  //     debugPrint(e.toString());
  //   }
  // }

//  String displayName = "";
//   Future<void> getUserDocument() async {
//     DocumentSnapshot documentSnapshot =
//         await firestore.collection('user').doc(auth.uid).get();
//      displayName = documentSnapshot.get('fname');
//   }
  final List<Widget> _pages = [
    const HomePage(),
    const CalenderPage(),
    const IoTPage(),
    const MedecinePage(),
    CameraPage(),
    const SettingPage(),
  ];

  late String? email = auth.email;
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isListening) {
        onListen();
      }
    });
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          //title: Text("Hi $_displayName"),
          title: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('user')
                .where('uid', isEqualTo: userID)
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
              if (streamSnapshot.connectionState == ConnectionState.waiting) {
                return const Text(
                    ""); // Display a loading indicator while data is loading
              }

              if (streamSnapshot.hasError) {
                return const Text("");
              }

              if (!streamSnapshot.hasData) {
                return const Text('No data available');
              }

              // Assuming that the query returns a list with one document
              final userDoc = streamSnapshot.data!.docs.first;

              // Replace 'fname' with the actual field name in your Firestore document
              final fname = userDoc['fname'];
              print(fname);
              return Text('Hi $fname');
            },
          ),
          actions: [
            IconButton(
                //onPressed: null,
                //onPressed: () => DatabaseFunc.logOut(),
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                },
                icon: const Icon(Icons.logout))
          ],
        ),
        body: _pages.elementAt(_selectedIndex),
        bottomNavigationBar: Container(
          color: Colors.black,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 0),
            child: GNav(
                gap: 8,
                backgroundColor: Colors.black,
                color: Colors.white,
                activeColor: Colors.white,
                tabBackgroundColor: Colors.grey.shade800,
                padding: const EdgeInsets.all(16),
                onTabChange: (index) {
                  //debugPrint("$index heheh");
                  _navigateThoughPages(index);
                },
                tabs: const [
                  GButton(
                    icon: Icons.home,
                    // text: 'home',
                  ),
                  GButton(
                    icon: Icons.task,
                    //text: 'To-do',
                  ),
                  GButton(
                    icon: Icons.radio_button_checked_sharp,
                    //text: 'Buttons',
                  ),
                  GButton(
                    icon: Icons.medical_services_outlined,
                    //text: 'Meds',
                  ),
                  GButton(
                    icon: Icons.camera,
                    //text: 'Camera',
                  ),
                  GButton(
                    icon: Icons.settings,
                    //text: 'Settings',
                  ),
                ]),
          ),
        ));
  }
}
