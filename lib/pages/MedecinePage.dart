import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../Routes.dart';
import '../theme/Theme.dart';
import '../widget/PredefinedWidgets.dart';
import 'ListMedecinePage.dart';

class MedecinePage extends StatefulWidget {
  const MedecinePage({super.key});

  @override
  State<MedecinePage> createState() => _MedecinePageState();
}

class MedecinePageService {
  static getMedecine(String uID, String type) {
    return FirebaseFirestore.instance
        .collection('Medicine')
        .where('uID', isEqualTo: uID)
        .where("time", isEqualTo: type)
        //.orderBy('time', descending: false)
        .snapshots();
  }

  static deleteItemsFromDatabase(BuildContext context, String productId) async {
    await FirebaseFirestore.instance
        .collection("Medicine")
        .doc(productId)
        .delete()
        .then((value) => PredefinedWidgets.showMySuccessDialog(
            context, "Item successfully deleted", ""));
  }

  static getMedecineTime(String uID) {
    return FirebaseFirestore.instance
        .collection('MedicationTime')
        .where('uid', isEqualTo: uID)
        .snapshots();
  }

  static getMedecineTime1(String uID) {
    return FirebaseFirestore.instance
        .collection('MedicationTime')
        .where('uid', isEqualTo: uID)
        .get();
  }
}

class _MedecinePageState extends State<MedecinePage> {
  late String uID;
  StreamController<List<String>> textStreamController =
      StreamController<List<String>>();
  late String morning;
  late String noon;
  late String night;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    uID = FirebaseAuth.instance.currentUser!.uid;
    setTime();
  }

  Future<void> setTime() async {
    QuerySnapshot<Map<String, dynamic>> query =
        await MedecinePageService.getMedecineTime1(uID);
    //print("hello");
    for (var doc in query.docs) {
      morning = doc['morning'];
      noon = doc['noon'];
      night = doc['night'];
      //print('dksafsakd:${doc["morning"]}');
    }
  }

  String type = "morning";
  String buttonText = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Column(
            children: [
              Container(
                  width: MediaQuery.of(context).size.width * 0.95,
                  height: MediaQuery.of(context).size.width * 1 / 2,
                  decoration: CustomTextStyle.darkModeBox,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Medication Time",
                                    style: CustomTextStyle.darkModetextStyle
                                        .copyWith(
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ],
                              ),
                              IconButton(
                                  onPressed: () {
                                    Get.toNamed(Routes.editMedicationTime);
                                  },
                                  icon: const Icon(
                                    Icons.settings,
                                    color: Colors.white,
                                  ))
                            ],
                          ),
                          Row(
                            children: [
                              Flexible(
                                  child: SizedBox(
                                      height: 300,
                                      child: StreamBuilder(
                                          stream: MedecinePageService
                                              .getMedecineTime(uID),
                                          builder: (context,
                                              AsyncSnapshot<QuerySnapshot>
                                                  streamSnapshot) {
                                            if (streamSnapshot.hasData) {
                                              print(uID);
                                              final DocumentSnapshot =
                                                  streamSnapshot
                                                      .data!.docs.first;
                                              return Column(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          "Morning:",
                                                          style: CustomTextStyle
                                                              .darkModetextStyle
                                                              .copyWith(
                                                                  fontSize: 18),
                                                        ),
                                                        Text(
                                                          DocumentSnapshot[
                                                              'morning'],
                                                          style: CustomTextStyle
                                                              .darkModetextStyle
                                                              .copyWith(
                                                                  fontSize: 18),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          "Noon:",
                                                          style: CustomTextStyle
                                                              .darkModetextStyle
                                                              .copyWith(
                                                                  fontSize: 18),
                                                        ),
                                                        Text(
                                                          DocumentSnapshot[
                                                              'noon'],
                                                          style: CustomTextStyle
                                                              .darkModetextStyle
                                                              .copyWith(
                                                                  fontSize: 18),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          "Night:",
                                                          style: CustomTextStyle
                                                              .darkModetextStyle
                                                              .copyWith(
                                                                  fontSize: 18),
                                                        ),
                                                        Text(
                                                          DocumentSnapshot[
                                                              'night'],
                                                          style: CustomTextStyle
                                                              .darkModetextStyle
                                                              .copyWith(
                                                                  fontSize: 18),
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                  /*
                                                  Row(children: [
                                                    const Text("Morning:"),
                                                    Text(DocumentSnapshot[
                                                        'morning'])
                                                  ]),
                                                  Row(children: [
                                                    const Text("Noon:"),
                                                    Text(DocumentSnapshot[
                                                        'noon'])
                                                  ]),
                                                  Row(children: [
                                                    const Text("Night:"),
                                                    Text(DocumentSnapshot[
                                                        'night'])
                                                  ])*/
                                                ],
                                              );
                                            } else {
                                              return const Center(
                                                child: Text(
                                                  "no time available",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              );
                                            }
                                          })
                                      //     Column(
                                      //   children: [
                                      //     Padding(
                                      //       padding: const EdgeInsets.all(8.0),
                                      //       child: Row(
                                      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      //         children: [
                                      //            Text("Morning:" ,style: CustomTextStyle.darkModetextStyle.copyWith( fontSize: 18),),
                                      //           Text(morning ,style: CustomTextStyle.darkModetextStyle.copyWith( fontSize: 18),)
                                      //         ],
                                      //       ),
                                      //     ),
                                      //     Padding(
                                      //       padding: const EdgeInsets.all(8.0),
                                      //       child: Row(
                                      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                      //         children: [
                                      //            Text("Noon:" ,style: CustomTextStyle.darkModetextStyle.copyWith( fontSize: 18),),
                                      //           Text(noon ,style: CustomTextStyle.darkModetextStyle.copyWith( fontSize: 18),)
                                      //         ],
                                      //       ),
                                      //     ),
                                      //     Padding(
                                      //       padding: const EdgeInsets.all(8.0),
                                      //       child: Row(
                                      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                      //         children: [
                                      //           Text("Night:" ,style: CustomTextStyle.darkModetextStyle.copyWith( fontSize: 18),),
                                      //           Text(night ,style: CustomTextStyle.darkModetextStyle.copyWith( fontSize: 18),)
                                      //         ],
                                      //       ),
                                      //     )
                                      //   ],
                                      // )
                                      ))
                            ],
                          )
                        ],
                      ),
                    ),
                  )),
              const SizedBox(height: 10),
              InkWell(
                  onTap: () {
                    Get.toNamed(Routes.listPrescriptionPage);
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.85,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 0, 162, 255),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Prescription from doctor',
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
              Container(
                  width: MediaQuery.of(context).size.width * 0.95,
                  height: MediaQuery.of(context).size.height * 1 / 2,
                  decoration: CustomTextStyle.darkModeBox,
                  child: SingleChildScrollView(
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      type = "morning";
                                    });
                                  },
                                  child: const Text('Morning'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      type = "noon";
                                      //buttonText = 'Button 2 Pressed \n tesr';
                                    });
                                  },
                                  child: const Text('Noon'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      type = "night";
                                      //buttonText = 'Button 3 Pressed';
                                    });
                                  },
                                  child: const Text('Night'),
                                ),
                              ],
                            ),
                            Container(
                                width: MediaQuery.of(context).size.width * 0.95,
                                height:
                                    MediaQuery.of(context).size.height * 1 / 2,
                                decoration: CustomTextStyle.darkModeBox,
                                child: StreamBuilder(
                                    stream: MedecinePageService.getMedecine(
                                        uID, type),
                                    builder: (context,
                                        AsyncSnapshot<QuerySnapshot>
                                            streamSnapshot) {
                                      if (streamSnapshot.hasData) {
                                        //print("end");
                                        if (streamSnapshot.data!.docs.isEmpty) {
                                          return const Center(
                                              child: Text(
                                            "No Item added yet",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ));
                                        } else {
                                          return ListView.builder(
                                              shrinkWrap: true,
                                              itemCount: streamSnapshot
                                                  .data!.docs.length,
                                              itemBuilder: (context, index) {
                                                final DocumentSnapshot
                                                    documentSnapshot =
                                                    streamSnapshot
                                                        .data!.docs[index];
                                                //print("js$documentSnapshot['title']");
                                                MedicineModel medicineItems =
                                                    MedicineModel(
                                                        documentSnapshot.id,
                                                        documentSnapshot[
                                                            'Medicine Name'],
                                                        documentSnapshot[
                                                            'dosage'],
                                                        documentSnapshot[
                                                            'time']);
                                                return Card(
                                                    margin:
                                                        const EdgeInsets.all(
                                                            10),
                                                    child:
                                                        Row(children: <Widget>[
                                                      SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.5,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: <Widget>[
                                                              Text(
                                                                  "${medicineItems.medicineName} x ${medicineItems.dosage}"),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.3,
                                                        child: Row(
                                                          children: <Widget>[
                                                            IconButton(
                                                              icon: const Icon(
                                                                  Icons.edit),
                                                              onPressed: () {
                                                                Get.toNamed(
                                                                    Routes
                                                                        .editMedecine,
                                                                    arguments:
                                                                        medicineItems);
                                                              },
                                                            ),
                                                            IconButton(
                                                              icon: const Icon(
                                                                  Icons.delete),
                                                              onPressed: () {
                                                                MedecinePageService
                                                                    .deleteItemsFromDatabase(
                                                                        context,
                                                                        medicineItems
                                                                            .docID);
                                                              },
                                                            )
                                                          ],
                                                        ),
                                                      )
                                                    ]));
                                              });
                                        }
                                      } else {
                                        return const Center(
                                            child: Text("No Item added yet"));
                                      }
                                    })),
                          ]))))
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add), //child widget inside this button
          onPressed: () {
            Get.toNamed(Routes.addMedecine);
            //task to execute when this button is pressed
          },
        ));
  }
}
