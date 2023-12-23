import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../model/AppliancesModel.dart';
import '../theme/Theme.dart';
import '../widget/PredefinedWidgets.dart';

class ListAppliancePage extends StatefulWidget {
  const ListAppliancePage({super.key});

  @override
  State<ListAppliancePage> createState() => _ListAppliancePageState();
}



class ListAppliancePageService {
  static getAppliances(String uID) {
    return FirebaseFirestore.instance
        .collection('appliances')
        .where('uid', isEqualTo: uID)
        .snapshots();
  }
   static deleteItemsFromDatabase(BuildContext context, String docId) async {
    await FirebaseFirestore.instance
        .collection("appliances")
        .doc(docId)
        .delete()
        .then((value) => PredefinedWidgets.showMySuccessDialog(
            context, "Item successfully deleted", ""));
  }
}

class _ListAppliancePageState extends State<ListAppliancePage> {
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
        title: const Text("Appliances"),
      ),
      body: Center(
        child: Column(children: <Widget>[
          Flexible(
            child: StreamBuilder(
                stream: ListAppliancePageService.getAppliances(uID),
                builder:
                    (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                  if (streamSnapshot.hasData) {
                    //print("end");
                    if (streamSnapshot.data!.docs.isEmpty) {
                      return const Center(
                          child: Text(
                        "No appliances available",
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
                            AppliancesModel app = AppliancesModel(
                                documentSnapshot.id,
                                documentSnapshot['name'],
                                documentSnapshot['relay'],
                                documentSnapshot['uid'],);
                            return Card(
                                margin: const EdgeInsets.all(10),
                                child: Row(children: <Widget>[
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                      child:  Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Text(
                                                    "${app.name} "),
                                                Text(app.relay)
                                              ],
                                            ),
                                          ),
                                      ),
                                  const Spacer(),
                                  SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.3,
                                          child: Row(
                                            children: <Widget>[
                                              // IconButton(
                                              //   icon: const Icon(Icons.edit),
                                              //   onPressed: () {
                                              //      Get.toNamed(
                                              //          Routes.editAppliances,
                                              //          arguments: app);
                                              //   },
                                              // ),
                                              IconButton(
                                                icon: const Icon(Icons.delete),
                                                onPressed: () {
                                                  ListAppliancePageService
                                                      .deleteItemsFromDatabase(
                                                          context,
                                                          app.docID);
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
                    return const Center(child: Text("No appliances available"));
                  }
                }),
          )
        ]),
      ),
    );
  }
}
