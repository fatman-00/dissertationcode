import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elderly_people/Routes.dart';
import 'package:elderly_people/widget/PredefinedWidgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class ShoppingCart extends StatefulWidget {
  const ShoppingCart({super.key});

  @override
  State<ShoppingCart> createState() => _ShoppingCartState();
}

class ShoppingItemsModel {
  String docID;
  String itemName;
  String qty;
  bool completed;
  ShoppingItemsModel(this.docID, this.itemName, this.qty, this.completed);
}

class ShoppingCartService {
  static final CollectionReference _items =
      FirebaseFirestore.instance.collection("ShoppingItems");
  static retrieveFromDB(String uID) {
    return FirebaseFirestore.instance
        .collection('ShoppingItems')
        .where('uid', isEqualTo: uID)
        .snapshots();
  }

  static Future<void> updateCheckboxValue(
      BuildContext context, String docID, bool val) async {
    await _items.doc(docID).update({"completed": val});
  }

  static deleteItemsFromDatabase(BuildContext context, String productId) async {
    await FirebaseFirestore.instance
        .collection("ShoppingItems")
        .doc(productId)
        .delete()
        .then((value) => PredefinedWidgets.showMySuccessDialog(
            context, "Item successfully deleted", ""));
  }
}

class _ShoppingCartState extends State<ShoppingCart> {
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
        appBar: AppBar(
          title: const Text("Shopping list"),
        ),
        body: Center(
          child: Column(children: <Widget>[
            Flexible(
                child: StreamBuilder(
                    stream: ShoppingCartService.retrieveFromDB(uID),
                    builder:
                        (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                      if (streamSnapshot.hasData) {
                        //print("end");
                        if (streamSnapshot.data!.docs.isEmpty) {
                          return const Center(child: Text("No Item added yet"));
                        } else {
                          return ListView.builder(
                              shrinkWrap: true,
                              itemCount: streamSnapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                final DocumentSnapshot documentSnapshot =
                                    streamSnapshot.data!.docs[index];
                                //print("js$documentSnapshot['title']");
                                ShoppingItemsModel shoppingItems =
                                    ShoppingItemsModel(
                                        documentSnapshot.id,
                                        documentSnapshot['ItemName'],
                                        documentSnapshot['qty'],
                                        documentSnapshot['completed']);
                                return Card(
                                    margin: const EdgeInsets.all(10),
                                    child: Row(children: <Widget>[
                                      SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.7,
                                          child: CheckboxListTile(
                                            title: Text(
                                                "${shoppingItems.itemName} x ${shoppingItems.qty}"),
                                            value: shoppingItems.completed,
                                            onChanged: (val) {
                                              setState(() {
                                                ShoppingCartService
                                                    .updateCheckboxValue(
                                                        context,
                                                        shoppingItems.docID,
                                                        val!);
                                              });
                                            },
                                          )),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.2,
                                        child: Row(
                                          children: <Widget>[
                                            IconButton(
                                              icon: const Icon(Icons.delete),
                                              onPressed: () {
                                                ShoppingCartService
                                                    .deleteItemsFromDatabase(
                                                        context,
                                                        shoppingItems.docID);
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
          ]),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add), //child widget inside this button
          onPressed: () {
            Get.toNamed(Routes.addShoppingItem);
            //task to execute when this button is pressed
          },
        ));
  }
}
