import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Routes.dart';
import '../widget/PredefinedWidgets.dart';

class MedicineModel {
  String docID;
  String medicineName;
  String dosage;
  String time;
  MedicineModel(this.docID, this.medicineName, this.dosage, this.time);
}

class ListMedecinePage extends StatefulWidget {
  const ListMedecinePage({super.key});

  @override
  State<ListMedecinePage> createState() => _ListMedecinePageState();
}

class ListMedecinePageService {
  static getMedecine(String uID) {
    return FirebaseFirestore.instance
        .collection('Medicine')
        .where('uID', isEqualTo: uID)
        .orderBy('time', descending: false)
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
}

class _ListMedecinePageState extends State<ListMedecinePage> {
  late String uID;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    uID = FirebaseAuth.instance.currentUser!.uid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Medicines")),
        body: SafeArea(
          child: Row(
            children: <Widget>[
              Flexible(
                  child: StreamBuilder(
                      stream: ListMedecinePageService.getMedecine(uID),
                      builder: (context,
                          AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                        if (streamSnapshot.hasData) {
                          //print("end");
                          if (streamSnapshot.data!.docs.isEmpty) {
                            return const Center(
                                child: Text("No Item added yet"));
                          } else {
                            return ListView.builder(
                                shrinkWrap: true,
                                itemCount: streamSnapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  final DocumentSnapshot documentSnapshot =
                                      streamSnapshot.data!.docs[index];
                                  //print("js$documentSnapshot['title']");
                                  MedicineModel medicineItems = MedicineModel(
                                      documentSnapshot.id,
                                      documentSnapshot['Medicine Name'],
                                      documentSnapshot['dosage'],
                                      documentSnapshot['time']);
                                  return Card(
                                      margin: const EdgeInsets.all(10),
                                      child: Row(children: <Widget>[
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.6,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Text(
                                                    "${medicineItems.medicineName} x ${medicineItems.dosage}"),
                                                Text(medicineItems.time)
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.3,
                                          child: Row(
                                            children: <Widget>[
                                              IconButton(
                                                icon: const Icon(Icons.edit),
                                                onPressed: () {
                                                  Get.toNamed(
                                                      Routes.editMedecine,
                                                      arguments: medicineItems);
                                                },
                                              ),
                                              IconButton(
                                                icon: const Icon(Icons.delete),
                                                onPressed: () {
                                                  ListMedecinePageService
                                                      .deleteItemsFromDatabase(
                                                          context,
                                                          medicineItems.docID);
                                                },
                                              )
                                            ],
                                          ),
                                        )
                                      ]));
                                });
                          }
                        } else {
                          return const Center(child: Text("No Item added yet"));
                        }
                      }))
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
