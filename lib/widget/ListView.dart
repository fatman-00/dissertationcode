import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:dissertationtest/services/database.dart';
import 'package:elderly_people/service/ListViewService.dart';
import 'package:elderly_people/widget/PredefinedWidgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:dissertationtest/features/routes.dart' as route;
import '../model/routeToDoList.dart';

class ListItem extends StatefulWidget {
  final DateTime selectedDate;

  const ListItem({
    super.key,
    required this.selectedDate,
  });

  @override
  State<ListItem> createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  // ----------------------------------------------------------------DECLARATION OF VARIABLE
  DateTime getSelectedDate() {
    return widget.selectedDate;
  }

  bool databaseCheckBoxVal = false;
  bool test = false;
  ListViewService d = ListViewService();

  final CollectionReference _product =
      FirebaseFirestore.instance.collection("todoitems");

  // -------------------------------------------------------------Query search based on userID
  late Stream<QuerySnapshot> orderStream;
  static Stream<QuerySnapshot<Map<String, dynamic>>> getSnap(
      DateTime selectedDate) {
    //print("sda ${Timestamp.fromDate(selectedDate)}");
    final user = FirebaseAuth.instance;

    return FirebaseFirestore.instance
        .collection('todoitems')
        .where('userId', isEqualTo: user.currentUser!.uid)
        .where('date', isEqualTo: selectedDate)
        .snapshots();
  }

//----------------------------------------------------------------DATABASE FUNCTION update check box valu
  Future<void> _updateCheckboxValue(
      DocumentSnapshot documentSnapshot, bool val) async {
    await _product
        .doc(documentSnapshot.id)
        .update({"complete": val}).then((value) => {
              debugPrint("updated"),
            });
  }

  Future<void> _deleteItemsFromDatabase(String productId) async {
    await _product.doc(productId).delete();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Item successfully delete')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        //stream: _product.snapshots(),
        //stream: ListItem.getSnap(widget.selectedDate),
        stream: getSnap(widget.selectedDate),
        //stream: d.getO,

        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return ListView.builder(
                shrinkWrap: true,
                itemCount:
                    streamSnapshot.data!.docs.length, // THE NUMBER OF ITEMS
                itemBuilder: (context, index) {
                  final DocumentSnapshot documentSnapshot =
                      streamSnapshot.data!.docs[index];
                  // databaseCheckBoxVal = documentSnapshot['complete'];
                  // taskDate = documentSnapshot['date'];

                  routeToDoList task = routeToDoList(
                      documentSnapshot.id,
                      documentSnapshot['title'],
                      documentSnapshot['description'],
                      documentSnapshot['date'].toDate(),
                      documentSnapshot['userId'],
                      documentSnapshot['complete'],
                      "null");
                  debugPrint("${widget.selectedDate}");
                  return Card(
                      margin: const EdgeInsets.all(10),
                      child: Container(
                        child: Row(
                          children: <Widget>[
                            SizedBox(
                              width:
                                  MediaQuery.of(context).size.width * 0.5 - 20,
                              child: CheckboxListTile(
                                title: Text(
                                    //documentSnapshot['title']
                                    task.title),
                                value: task.complete, //databaseCheckBoxVal,
                                onChanged: (val) {
                                  setState(() {
                                    _updateCheckboxValue(
                                        documentSnapshot, val!);
                                    debugPrint("${task.complete}");
                                  });
                                },
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: Row(
                                children: <Widget>[
                                  ElevatedButton(
                                      onPressed: () {
                                        debugPrint("Open alert ");
                                        // PredefinedWidgets.showDialogForitems(
                                        //   context,
                                        //     task.title,
                                        //     task.description);
                                        /*showDialog(
                                            context: context,
                                            builder: (context) {
                                              return SimpleDialog(
                                                title: Text(
                                                  //documentSnapshot['title'],
                                                  task.title,
                                                  textAlign: TextAlign.center,
                                                ),
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(task.description
                                                        //documentSnapshot['description']
                                                        ),
                                                  )
                                                ],
                                              );
                                            });*/
                                      },
                                      child: const Text("DESC")),
                                  IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () {
                                        debugPrint(task.docId);
                                        task.setOperation("update");
                                        // Navigator.pushNamed(
                                        //     context, route.addItemPage,
                                        //     arguments: dummy);
                                        // Navigator.pushNamed(
                                        //     context, route.addItemPage,
                                        //     arguments: task);
                                      }
                                      // =>
                                      // Navigator.pushNamed(
                                      //     context, route.addItemPage,
                                      //     arguments: task.date),
                                      // arguments: taskDate.toDate()),
                                      ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () {
                                      _deleteItemsFromDatabase(task.docId);
                                    },
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ));
                });
          } else {
            return const Center(child: Text("No Task"));
          }
        });
  }
}
