import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../theme/Theme.dart';
import '../widget/PredefinedWidgets.dart';

class ListRoutinesPage extends StatefulWidget {
  const ListRoutinesPage({super.key});

  @override
  State<ListRoutinesPage> createState() => _ListRoutinesPageState();
}

class ListRoutinesPageService {
  static getRotines(String uID) {
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
        .then((value) => PredefinedWidgets.showMySuccessDialog(
            context, "Item successfully deleted", ""));
  }
}

class RoutineModel {
  String docID;
  String routineName;
  String sensorForRoutine;
  String operation;
  String relayConnected;
  String sensorThreshold;
  String uID;
  RoutineModel(this.docID, this.routineName, this.sensorForRoutine,
      this.operation, this.relayConnected, this.sensorThreshold, this.uID);
}

class _ListRoutinesPageState extends State<ListRoutinesPage> {
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
        title: const Text("Routines available"),
      ),
      body: Center(
        child: Column(children: <Widget>[
          Flexible(
            child: StreamBuilder(
                stream: ListRoutinesPageService.getRotines(uID),
                builder:
                    (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                  if (streamSnapshot.hasData) {
                    //print("end");
                    if (streamSnapshot.data!.docs.isEmpty) {
                      return const Center(
                          child: Text(
                        "No Routiones available",
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
                            RoutineModel routines = RoutineModel(
                                documentSnapshot.id,
                                documentSnapshot['routineName'],
                                documentSnapshot['sensorForRoutine'],
                                documentSnapshot['operation'],
                                documentSnapshot['relayConnected'],
                                documentSnapshot['sensorThreshold'],
                                documentSnapshot['uID']);

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
                                          Text("${routines.routineName} "),
                                          Text(routines.relayConnected)
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
                                          icon: const Icon(Icons.delete),
                                          onPressed: () {
                                            ListRoutinesPageService
                                                .deleteItemsFromDatabase(
                                                    context, routines.docID);
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
                    return const Center(child: Text("No Routiones available"));
                  }
                }),
          )
        ]),
      ),
    );
  }
}
