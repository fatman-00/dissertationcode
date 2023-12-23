import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Routes.dart';
import '../theme/Theme.dart';
import '../widget/PredefinedWidgets.dart';

class ListUserGuide extends StatefulWidget {
  const ListUserGuide({super.key});

  @override
  State<ListUserGuide> createState() => _ListUserGuideState();
}

class ListUserGuideService {
  static getUserGuide(String uID) {
    return FirebaseFirestore.instance
        .collection('UserGuide')
        .where('uID', isEqualTo: uID)
        .snapshots();
  }

  static deleteItemsFromDatabase(BuildContext context, String docId) async {
    await FirebaseFirestore.instance
        .collection("UserGuide")
        .doc(docId)
        .delete()
        .then((value) => PredefinedWidgets.showMySuccessDialog(
            context, "Item successfully deleted", ""));
  }
}

class UserGuideModel {
  String docID;
  String title;
  String desc;
  String uID;
  UserGuideModel(this.docID, this.title, this.desc, this.uID);
}

class _ListUserGuideState extends State<ListUserGuide> {
  late String uID;
  @override
  void initState() {
    // TODO: implement initState
    uID = FirebaseAuth.instance.currentUser!.uid;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("User guide"),
        ),
        body: Center(
            child: Column(
          children: <Widget>[
            Flexible(
              child: StreamBuilder(
                  stream: ListUserGuideService.getUserGuide(uID),
                  builder:
                      (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                    if (streamSnapshot.hasData) {
                      //print("end");
                      if (streamSnapshot.data!.docs.isEmpty) {
                        return const Center(
                            child: Text(
                          "No User guide available",
                          style: CustomTextStyle.whiteModetextStyle,
                        ));
                      } else {
                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: streamSnapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              final DocumentSnapshot documentSnapshot =
                                  streamSnapshot.data!.docs[index];
                              //print("js$documentSnapshot['title']");
                              // RoutineModel routines = RoutineModel(
                              //     documentSnapshot.id,
                              //     documentSnapshot['routineName'],
                              //     documentSnapshot['sensorForRoutine'],
                              //     documentSnapshot['operation'],
                              //     documentSnapshot['relayConnected'],
                              //     documentSnapshot['sensorThreshold'],
                              //     documentSnapshot['uID']);
                              UserGuideModel userGuide = UserGuideModel(
                                  documentSnapshot.id,
                                  documentSnapshot['title'],
                                  documentSnapshot['desc'],
                                  documentSnapshot['uID']);
                              return Card(
                                  margin: const EdgeInsets.all(10),
                                  child: Row(children: <Widget>[
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text("${userGuide.title} "),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.3,
                                      child: Row(
                                        children: <Widget>[
                                          IconButton(
                                            icon: const Icon(
                                              Icons.visibility,
                                            ),
                                            onPressed: () {
                                              PredefinedWidgets
                                                  .showDialogForUserGuide(
                                                      context,
                                                      userGuide.title,
                                                      userGuide.desc);
                                            },
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.delete),
                                            onPressed: () {
                                              ListUserGuideService
                                                  .deleteItemsFromDatabase(
                                                      context, userGuide.docID);
                                            },
                                          )
                                        ],
                                      ),
                                    )
                                  ]));
                            });
                      }
                    } else {
                      //print("no data");
                      return const Center(
                          child: Text("No Routiones available"));
                    }
                  }),
            )
          ],
        )),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add), //child widget inside this button
          onPressed: () {
            Get.toNamed(Routes.addUserGuide);
            //task to execute when this button is pressed
          },
        ));
  }
}
