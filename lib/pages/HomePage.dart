import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elderly_people/Routes.dart';
import 'package:elderly_people/utils/EmergencyContact.dart';
import 'package:elderly_people/widget/PredefinedWidgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../model/ToDoListModel.dart';
import '../theme/Theme.dart';
import 'CalenderPage.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class HomePageService {
  /*static Future<Position?> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are disabled
      return null;
    }

    // Check if location permission is granted
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // Location permission is denied, request permission
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        // Location permission not granted
        return null;
      }
    }

    // Retrieve current position
    return await Geolocator.getCurrentPosition();
  }

  static String generateLocationUrl(double latitude, double longitude) {
    String url =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    print(url);
    return url;
  }

  static sendMessageToContact() async {
    String documentID = "";
    final user = FirebaseAuth.instance.currentUser?.uid;
    // print(user);
    try {
      //
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection("user")
          .where("uid", isEqualTo: user)
          .get();

      List<QueryDocumentSnapshot<Map<String, dynamic>>> documents =
          snapshot.docs;

      for (QueryDocumentSnapshot<Map<String, dynamic>> document in documents) {
        documentID = document.id;
      }
    } catch (e) {
      print('Error retrieving items from Firestore: $e');
    }

    // ignore: unused_local_variable
    Position? currentlocation = await getCurrentLocation();
    String url = "";
    if (currentlocation != null) {
      double latitude = currentlocation.latitude;
      double longitude = currentlocation.longitude;

      url = generateLocationUrl(latitude, longitude);
    } else {
      // Handle case when location is unavailable
      print('Unable to retrieve current location.');
    }

    try {
      print(documentID);
      Query<Map<String, dynamic>> subcollectionRef =
          // FirebaseFirestore.instance
          //     .collection("user")
          //     .doc(documentID)
          //     .collection('contactInfo');
          FirebaseFirestore.instance
              .collection("contactInfo")
              .where("uid", isEqualTo: user);
      QuerySnapshot<Map<String, dynamic>> snapshot =
          await subcollectionRef.get();
      List<String> contactNumber = [];
      List<String> message = [];

      if (snapshot.size == 0) {
        //print("No contact list availble");
      } else {
        for (var document in snapshot.docs) {
          Map<String, dynamic> data = document.data();
          //print(data['message']);
          //print(document.data()['ContactNumber']);
          contactNumber.add(data['ContactNumber']);
          message.add(data['message']);
        }
        for (var i = 0; i < contactNumber.length; i++) {
          //print(message[i]);
          SendTelephony(contactNumber[i], " ${message[i]}'s my location: $url");
        }
      }
    } catch (e) {
      print('Error retrieving items from Firestore: $e');
    }

    // return items;
  }

  static final Telephony telephony = Telephony.instance;

  static SendTelephony(String contactNumber, String message) {
    // print(message);
    telephony.sendSms(
      to: contactNumber,
      message: message,
    );
    //.then((value) => print("Success"))
    //.onError((error, stackTrace) => print("error"));
  }*/
}

class _HomePageState extends State<HomePage> {
  final String user = FirebaseAuth.instance.currentUser!.uid;
  //final LocalNotificationManager notificationManager =
 //     LocalNotificationManager();
  late TimeOfDay time;
  late TimeOfDay picked;


  
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }
//----------------------------------------------------------ALAN VOICE CODE-------------------------------------------------------
 // _HomePageState() {
    /// Init Alan Button with project key from Alan AI Studio
    ///   AlanVoice.addButton("936788f70ca52a4deca977dd769e04112e956eca572e1d8b807a3e2338fdd0dc/stage");
    ///  "5c12151eb04208b97980c0b11b1ffd302e956eca572e1d8b807a3e2338fdd0dc/stage",

    // AlanVoice.addButton(
    //   "936788f70ca52a4deca977dd769e04112e956eca572e1d8b807a3e2338fdd0dc/stage",
    //   buttonAlign: AlanVoice.BUTTON_ALIGN_LEFT,
    // );

    // /// Handle commands from Alan AI Studio
    // AlanVoice.onCommand.add((command) =>
    //     _handleCommand(command.data, FirebaseAuth.instance.currentUser!.uid));
  //}
  // void _handleCommand(Map<String, dynamic> command, String uID) {
  //   switch (command["command"]) {
  //     case "turn on relay 1":
  //       BackgroundProcessing.writeRelay1(true, uID);
  //       break;
  //     case "turn on relay 2":
  //       BackgroundProcessing.writeRelay2(true, uID);

  //       break;
  //     case "turn on relay 3":
  //       BackgroundProcessing.writeRelay3(true, uID);

  //       break;
  //     case "turn on relay 4":
  //       BackgroundProcessing.writeRelay4(true, uID);

  //       break;
  //     case "turn off relay 1":
  //       BackgroundProcessing.writeRelay1(false, uID);

  //       break;
  //     case "turn off relay 2":
  //       BackgroundProcessing.writeRelay2(false, uID);

  //       break;

  //     case "turn off relay 3":
  //       BackgroundProcessing.writeRelay3(false, uID);

  //       break;
  //     case "turn off relay 4":
  //       BackgroundProcessing.writeRelay4(false, uID);
  //       break;

  //     case "Emergency Contact":
  //       HomePageService.sendMessageToContact();
  //       break;
  //   }
  // }

  bool morning = false;
  bool noon = false;
  bool night = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Center(
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.85,
              height: 75.0,
              child: ElevatedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Emergency button'),
                        content: const Text(
                            'Emergency button has been pressed if you wish to proceed press "yes"'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              // Cancel the timer when a button is pressed
                              EmergencyContact.sendMessageToContact(user);
                              Navigator.of(context).pop();
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
                  backgroundColor: Colors.red[700], // Background color
                ),
                icon: const Icon(
                  Icons.call,
                  size: 55,
                  color: Colors.white,
                ),
                label: const Text(
                  "SOS",
                  style: CustomTextStyle.PanicButton,
                ),
              ),
            ),
            const SizedBox(height: 10),
            InkWell(
                onTap: () {
                  Get.toNamed(Routes.shoppingCart);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.green[900],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Shopping list',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(
                          Icons.arrow_right,
                          color: Colors.white,
                          size: 20.0,
                        )
                      ],
                    ),
                  ),
                )),
            const SizedBox(height: 10),

            /*Container(
              decoration: CustomTextStyle.darkModeBox,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Text(
                            'Medicine',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Icon(
                            Icons.medication,
                            color: Colors.white,
                          ),
                        ],
                      ),
                      IconButton(
                          onPressed: () {
                            Get.toNamed(Routes.addMedecine);
                          },
                          icon: const Icon(
                            Icons.add_circle_outline,
                            color: Colors.white,
                          )),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //   children: [
                  //     Column(
                  //       children: [
                  //         const Icon(
                  //           Icons.wb_sunny,
                  //           color: Colors.white,
                  //         ),
                  //         const Text(
                  //           'Morning',
                  //           style: TextStyle(color: Colors.white),
                  //         ),
                  //         Checkbox(
                  //           value: morning,
                  //           onChanged: (value) {
                  //             setState(() {
                  //               morning = value!;
                  //             });
                  //           },
                  //         ),
                  //       ],
                  //     ),
                  //     Column(
                  //       children: [
                  //         const Icon(
                  //           Icons.cloud,
                  //           color: Colors.white,
                  //         ),
                  //         const Text(
                  //           'Noon',
                  //           style: TextStyle(color: Colors.white),
                  //         ),
                  //         Checkbox(
                  //           value: noon,
                  //           onChanged: (value) {
                  //             setState(() {
                  //               noon = value!;
                  //             });
                  //           },
                  //         ),
                  //       ],
                  //     ),
                  //     Column(
                  //       children: [
                  //         const Icon(
                  //           Icons.nights_stay,
                  //           color: Colors.white,
                  //         ),
                  //         const Text(
                  //           'Night',
                  //           style: TextStyle(color: Colors.white),
                  //         ),
                  //         Checkbox(
                  //           value: night,
                  //           onChanged: (value) {
                  //             setState(() {
                  //               night = value!;
                  //             });
                  //           },
                  //         ),
                  //       ],
                  //     ),
                  //   ],
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            notificationManager.showNotification();
                            // Notifications.showNotification(
                            //   title: "hello",
                            //   body: "you have not taken your medecine",
                            //   payload: "lo.abs",
                            // );
                            // showDialog(
                            //   context: context,
                            //   builder: (BuildContext context) {

                            //     //return ReminderDialog();
                            //   },
                            // );
                          },
                          child: const Text(
                            "Change Time",
                            style: TextStyle(color: Colors.black),
                          ))
                      //PredefinedWidgets.myButton(context, (){}, "Change time"),
                    ],
                  )
                ],
              ),
            ),*/
            InkWell(
                onTap: () {
                  Get.toNamed(Routes.uncompletedTask);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Uncompleted Tasks',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(
                          Icons.arrow_right,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                )),
            const SizedBox(height: 10),
            InkWell(
                onTap: () {
                  Get.toNamed(Routes.newsArticle);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 102, 101, 24),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'News',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(
                          Icons.arrow_right,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                )),
            const SizedBox(height: 10),
            InkWell(
                onTap: () {
                  Get.toNamed(Routes.listUserGuide);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.blue[900],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'User guide',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(
                          Icons.arrow_right,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                )),
            const SizedBox(height: 10),
            Container(
              decoration: CustomTextStyle.darkModeBox,
              child: Column(children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Task for today",
                        style: CustomTextStyle.darkModetextStyle.copyWith(
                          fontSize: 18.0,
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Flexible(
                      child: SizedBox(
                        height: 250,
                        child: StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('todoitems')
                                .where('userId', isEqualTo: user)
                                .where('date',
                                    isEqualTo: DateFormat('yyyy-MM-dd')
                                        .format(DateTime.now()))
                                .snapshots(),
                            builder: (context,
                                AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                              if (streamSnapshot.hasData) {
                                //print("end");
                                if (streamSnapshot.data!.docs.isEmpty) {
                                  return const Center(
                                      child: Text(
                                    "No task for today",
                                    style: CustomTextStyle.darkModetextStyle,
                                  ));
                                } else {
                                  return ListView.builder(
                                      shrinkWrap: true,
                                      itemCount:
                                          streamSnapshot.data!.docs.length,
                                      itemBuilder: (context, index) {
                                        final DocumentSnapshot
                                            documentSnapshot =
                                            streamSnapshot.data!.docs[index];
                                        //print("js$documentSnapshot['title']");
                                        ToDoListModel tasks = ToDoListModel(
                                            documentSnapshot.id,
                                            documentSnapshot['title'],
                                            documentSnapshot['description'],
                                            DateTime.parse(
                                                documentSnapshot['date']),
                                            documentSnapshot['time'],
                                            documentSnapshot['userId'],
                                            documentSnapshot['complete'],
                                            "null");
                                        return Card(
                                            margin: const EdgeInsets.all(10),
                                            child: Row(children: <Widget>[
                                              SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.55,
                                                  child: CheckboxListTile(
                                                    title: Text(tasks.title),
                                                    value: tasks.complete,
                                                    onChanged: (val) {
                                                      setState(() {
                                                        CalenderPageService
                                                            .updateCheckboxValue(
                                                                documentSnapshot,
                                                                val!);
                                                      });
                                                    },
                                                  )),
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.3,
                                                child: Row(
                                                  children: <Widget>[
                                                    ElevatedButton(
                                                        onPressed: () {
                                                          debugPrint(
                                                              "Open alert ");
                                                          PredefinedWidgets
                                                              .showDialogForitems(
                                                                  context,
                                                                  tasks.title,
                                                                  tasks
                                                                      .description,tasks.time);
                                                        },
                                                        child:
                                                            const Text("DESC")),
                                                  ],
                                                ),
                                              )
                                            ]));
                                      });
                                }
                              } else {
                                //print("no data");
                                return const Center(
                                    child: Text("No Task added yet"));
                              }
                            }),
                      ),
                    )
                  ],
                )
              ]),
            )
          ],
        ),
      ),
    ),
      floatingActionButton:
      Stack(
        children: [
          Positioned(
            bottom: 16.0,
            left: 30.0,
            child: FloatingActionButton(
              heroTag: 1,
              onPressed: () {
                // Handle right FAB press
              Get.toNamed(Routes.QRPage);

              },
              child: const Icon(Icons.qr_code),
            ),
          ),
          Positioned(
            bottom: 16.0,
            right: 16.0,
            child: FloatingActionButton(
              heroTag: 2,
              child: const Icon(Icons.mic), //child widget inside this button
          onPressed: () {
            Get.toNamed(Routes.voiceAssistant);
            //task to execute when this button is pressed
          },
              
            ),
          ),
        ],
      ),
      // FloatingActionButton(

      //     child: const Icon(Icons.mic), //child widget inside this button
      //     onPressed: () {
      //       Get.toNamed(Routes.voiceAssistant);
      //       //task to execute when this button is pressed
      //     },
      //   )
    );
      }
}
