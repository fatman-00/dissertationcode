import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Routes.dart';
import '../model/EmergencyContactModel.dart';
import '../theme/Theme.dart';
import '../widget/PredefinedWidgets.dart';

class ListEmergencyContact extends StatefulWidget {
  const ListEmergencyContact({Key? key}) : super(key: key);

  @override
  State<ListEmergencyContact> createState() => _ListEmergencyContactState();
}

class ListEmergencyContactService {
  static late String urlOfData;

  static  getEmergencyContact(
      String uID)  {
    // late var documentID;
    // QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
    //     .instance
    //     .collection("user")
    //     .where("uid", isEqualTo: uID)
    //     .get();

    // List<QueryDocumentSnapshot<Map<String, dynamic>>> documents = snapshot.docs;

    // for (QueryDocumentSnapshot<Map<String, dynamic>> document in documents) {
    //   documentID = document.id;
    // }
    // print("$documentID");
    // urlOfData = 'user/$documentID/contactInfo';
    // // return FirebaseFirestore.instance
    // //     .collection('user/$documentID/contactInfo')
    // //     .where('uid', isEqualTo: uID)
    // //     .get();

    return FirebaseFirestore.instance
        .collection('contactInfo')
        .where("uid",isEqualTo: uID)
        .snapshots();
  }

  static deleteItemsFromDatabase(BuildContext context, String docId) async {
    await FirebaseFirestore.instance
        .collection('contactInfo')
        .doc(docId)
        .delete()
        .then((value) => PredefinedWidgets.showMySuccessDialog(
            context, "Item successfully deleted", ""));
  }
}

class _ListEmergencyContactState extends State<ListEmergencyContact> {
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
          title: const Text("Emergency Contact"),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Flexible(
                child: StreamBuilder<QuerySnapshot>(
                  stream: ListEmergencyContactService.getEmergencyContact(uID),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasData) {
                      QuerySnapshot? data = snapshot.data;
                      if (data!.docs.isEmpty) {
                        return const Center(
                          child: Text(
                            "Please add an emergency contact",
                            style: CustomTextStyle.whiteModetextStyle,
                          ),
                        );
                      } else {
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: data.docs.length,
                          itemBuilder: (context, index) {
                            final DocumentSnapshot documentSnapshot =
                                data.docs[index];
                            EmergencyContactModel contact =
                                EmergencyContactModel(
                              documentSnapshot.id,
                              documentSnapshot['name'],
                              documentSnapshot['message'],
                              documentSnapshot['ContactNumber'],
                            );
                            return Card(
                              margin: const EdgeInsets.all(10),
                              child: Row(
                                children: <Widget>[
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text("${contact.name} "),
                                          Text(contact.contactNum),
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
                                            Get.toNamed(
                                                Routes.editEmergencyContact,
                                                arguments: contact);
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete),
                                          onPressed: () {
                                            ListEmergencyContactService
                                                .deleteItemsFromDatabase(
                                                    context, contact.docID);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      }
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return const Center(
                          child: Text("No appliances available"));
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add), //child widget inside this button
          onPressed: () {
            Get.toNamed(Routes.addEmergencyContact);
            //task to execute when this button is pressed
          },
        ));
  }
}
