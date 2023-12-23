import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Routes.dart';
import '../model/Prescription.dart';
import '../theme/Theme.dart';
import '../widget/PredefinedWidgets.dart';

class ListPrescription extends StatefulWidget {
  const ListPrescription({super.key});

  @override
  State<ListPrescription> createState() => _ListPrescriptionState();
}

class ListPrescriptionService {
  static getAppliances(String uID) {
    return FirebaseFirestore.instance
        .collection('Prescription')
        .where('userID', isEqualTo: uID)
        //.orderBy("date")
        .snapshots();
  }

  static deleteItemsFromDatabase(BuildContext context, String docId) async {
    await FirebaseFirestore.instance
        .collection("Prescription")
        .doc(docId)
        .delete()
        .then((value) => PredefinedWidgets.showMySuccessDialog(
            context, "Item successfully deleted", ""));
  }
}



class _ListPrescriptionState extends State<ListPrescription> {
  late String uID;
  @override
  void initState() {
    uID = FirebaseAuth.instance.currentUser!.uid;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("List of prescription"),
      ),
      body: Center(
        child: Column(children: <Widget>[
          Flexible(
            child: StreamBuilder(
                stream: ListPrescriptionService.getAppliances(uID),
                builder:
                    (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                  if (streamSnapshot.hasData) {
                    //print("end");
                    if (streamSnapshot.data!.docs.isEmpty) {
                      return const Center(
                          child: Text(
                        "No prescription available",
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
                            Prescription app = Prescription(
                              documentSnapshot.id,
                              documentSnapshot['presName'],
                              documentSnapshot['qrURL'],
                              documentSnapshot['userID'],
                              documentSnapshot['docID'],
                              documentSnapshot['date'],
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
                                          Text("${app.presName} "),
                                          
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
                                          icon: const Icon(Icons.qr_code_rounded),
                                          onPressed: () {
                                             Get.toNamed(
                                                 Routes.prescriptionResultPage,
                                                 arguments: app
                                                 );
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete),
                                          onPressed: () {
                                            ListPrescriptionService
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
                    return const Center(
                        child: Text("No prescription available"));
                  }
                }),
          )
        ]),
      ),
    );
  }
}
