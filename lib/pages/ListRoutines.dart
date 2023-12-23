import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Routes.dart';
import '../model/RoutineModel.dart';
import '../theme/Theme.dart';
import '../utils/TimerRoutines.dart';
import '../widget/PredefinedWidgets.dart';

class ListRoutine extends StatefulWidget {
  const ListRoutine({super.key});

  @override
  State<ListRoutine> createState() => _ListRoutineState();
}

class ListRoutineService {
  static getRoutine(String uID) {
    return FirebaseFirestore.instance
        .collection('Routines')
        .where('uid', isEqualTo: uID)
        .snapshots();
  }

  static deleteItemsFromDatabase(BuildContext context, String docId) async {
    await FirebaseFirestore.instance
        .collection("Routines")
        .doc(docId)
        .delete()
        .then((value) {
        TimerRoutines.change = true;
      PredefinedWidgets.showMySuccessDialog(
          context, "Item successfully deleted", "");
    });
  }
}

class _ListRoutineState extends State<ListRoutine> {
  late String uID;
  @override
  void initState() {
    super.initState();
    uID = FirebaseAuth.instance.currentUser!.uid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("List routines"),
      ),
      body: Center(
        child: Column(children: <Widget>[
          Flexible(
            child: StreamBuilder(
                stream: ListRoutineService.getRoutine(uID),
                builder:
                    (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                  if (streamSnapshot.hasData) {
                    //print("end");
                    if (streamSnapshot.data!.docs.isEmpty) {
                      return const Center(
                          child: Text(
                        "No Routines available",
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
                            RoutineModel app = RoutineModel(
                              documentSnapshot.id,
                              documentSnapshot['routineName'],
                              documentSnapshot['Relay1'],
                              documentSnapshot['Relay2'],
                              documentSnapshot['Relay3'],
                              documentSnapshot['Relay4'],
                              documentSnapshot['message'],
                              documentSnapshot['time'],
                              documentSnapshot['uid'],
                            );
                            return Card(
                                margin: const EdgeInsets.all(10),
                                child: Row(children: <Widget>[
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text("${app.name} "),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
                                    child: Row(
                                      children: <Widget>[
                                        IconButton(
                                          icon: const Icon(Icons.edit),
                                          onPressed: () {
                                            Get.toNamed(Routes.editRoutine,
                                                arguments: app);
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete),
                                          onPressed: () {
                                            ListRoutineService
                                                .deleteItemsFromDatabase(
                                                    context, app.docID);
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
                    return const Center(child: Text("No Routines available"));
                  }
                }),
          )
        ]),
      ),
    );
  }
}
