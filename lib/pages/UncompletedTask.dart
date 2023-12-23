import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/ToDoListModel.dart';
import '../theme/Theme.dart';
import '../widget/PredefinedWidgets.dart';
import 'CalenderPage.dart';

class UncompletedTask extends StatefulWidget {
  const UncompletedTask({super.key});

  @override
  State<UncompletedTask> createState() => _UncompletedTaskState();
}

class _UncompletedTaskState extends State<UncompletedTask> {
  late String uID;
  @override
  void initState() {
    super.initState();
    uID = FirebaseAuth.instance.currentUser!.uid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Uncompleted task")),
      body: Center(
        child: Column(children: <Widget>[
          Flexible(
            child: StreamBuilder(
                stream:
                    CalenderPageService.getUncompletedTask(DateTime.now(), uID),
                builder:
                    (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                  if (streamSnapshot.hasData) {
                    //print("end");
                    if (streamSnapshot.data!.docs.isEmpty) {
                      return const Center(
                          child: Text(
                        "All Task completed",
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
                            ToDoListModel tasks = ToDoListModel(
                                documentSnapshot.id,
                                documentSnapshot['title'],
                                documentSnapshot['description'],
                                DateTime.parse(documentSnapshot['date']),
                                documentSnapshot['time'],
                                documentSnapshot['userId'],
                                documentSnapshot['complete'],
                                "null");
                            return Card(
                                margin: const EdgeInsets.all(10),
                                child: Row(children: <Widget>[
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      child: CheckboxListTile(
                                        title: Text(tasks.title),
                                        value: tasks.complete,
                                        onChanged: (val) {
                                          setState(() {
                                            CalenderPageService
                                                .updateCheckboxValue(
                                                    documentSnapshot, val!);
                                          });
                                        },
                                      )),
                                  const Spacer(),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    child: Row(
                                      children: <Widget>[
                                        ElevatedButton(
                                            onPressed: () {
                                              debugPrint("Open alert ");
                                              PredefinedWidgets.showDialogForUncompleteditems(
                                                  context,
                                                  tasks.description,
                                                  tasks.title,
                                                  tasks.time,
                                                  DateFormat('dd-MM-yyyy').format(tasks.date));
                                            },
                                            child: const Text("DESC")),
                                      ],
                                    ),
                                  )
                                ]));
                          });
                    }
                  } else {
                    //print("no data");
                    return const Center(child: Text("No Task added yet"));
                  }
                }),
          )
        ]),
      ),
    );
  }
}
