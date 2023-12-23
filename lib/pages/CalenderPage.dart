import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elderly_people/model/ToDoListModel.dart';
import 'package:elderly_people/routes.dart';
import 'package:elderly_people/utils/TimerRoutines.dart';
import 'package:elderly_people/widget/PredefinedWidgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class CalenderPage extends StatefulWidget {
  const CalenderPage({super.key});

  @override
  State<CalenderPage> createState() => _CalenderPageState();
}

class CalenderPageService {
  static final CollectionReference _product =
      FirebaseFirestore.instance.collection("todoitems");
  static late Stream<QuerySnapshot> orderStream;

  Stream<QuerySnapshot> getItemsForUser() {
    return FirebaseFirestore.instance
        .collection('todoitems')
        .where('userId', isEqualTo: "A9vQ2dJPRHNTEpevE887n4YCxGA2")
        //.where('isAccepted', whereIn: [false, true])
        //.orderBy('complete', descending: false)
        .snapshots();
  }

  Future<String> updateDatabase(
      String docID, String title, String desc, DateTime date) async {
    String msg = "Not Updated";
    await _product
        .doc(docID)
        .update({'title': title, 'description': desc, 'date': date}).then(
            (value) => {msg = "succesfully updated"});
    return msg;
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getCollection(String uID) {
    //print("sda ${Timestamp.fromDate(selectedDate)}");

    return FirebaseFirestore.instance
        .collection('todoitems')
        .where('userId', isEqualTo: uID)
        .snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getSnap(
      DateTime selectedDate, String uID) {
    //print("sda ${Timestamp.fromDate(selectedDate)}");
    //print("sda $selectedDate}");
    //print(DateFormat('yyyy-MM-dd').format(DateTime.now()));
    return FirebaseFirestore.instance
        .collection('todoitems')
        .where('userId', isEqualTo: uID)
        .where('date', isEqualTo: DateFormat('yyyy-MM-dd').format(selectedDate))//retrieve information based on selected date
        .snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getUncompletedTask(
      DateTime selectedDate, String uID) {
    //print("sda ${Timestamp.fromDate(selectedDate)}");

    return FirebaseFirestore.instance
        .collection('todoitems')
        .where('userId', isEqualTo: uID)
        .where('date',
            isLessThan: DateFormat('yyyy-MM-dd').format(selectedDate))
        .where("complete", isEqualTo: false)
        .snapshots();
  }

  static Stream<QuerySnapshot> getOrderStream(DateTime d) {
    getOrderStream(d);
    return orderStream;
  }

  void getItem(DateTime selectedDate) {
    orderStream = FirebaseFirestore.instance
        .collection('todoitems')
        .where('userId', isEqualTo: "A9vQ2dJPRHNTEpevE887n4YCxGA2")
        .where('date', isEqualTo: selectedDate)
        .snapshots();
  }

  static Future<void> updateCheckboxValue(
      DocumentSnapshot documentSnapshot, bool val) async {
    await _product
        .doc(documentSnapshot.id)
        .update({"complete": val}).then((value) => {
              debugPrint("updated"),
            });
  }
}

class _CalenderPageState extends State<CalenderPage> {
  CalendarFormat _formatOfCalendar = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  var currenrUserID = FirebaseAuth.instance.currentUser!.uid;
  // routeToDoList createTask = routeToDoList(
  //     "", "", "", DateTime.parse('2020-01-02 03:04:05'), "", false, "create");
  Future<void> _deleteItemsFromDatabase(String productId) async {
    await FirebaseFirestore.instance
        .collection("todoitems")
        .doc(productId)
        .delete()
        .then((value) {
      PredefinedWidgets.showMySuccessDialog(
          context, "Item successfully deleted", "");
      TimerRoutines.itemchange = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Flexible(
              flex: 2,
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Card(
                        child: TableCalendar(
                      focusedDay: _focusedDay,
                      firstDay: DateTime(2022),
                      lastDay: DateTime(2024),
                      headerStyle: const HeaderStyle(
                        formatButtonVisible: false,
                      ),
                      calendarFormat: _formatOfCalendar,
                      calendarStyle: const CalendarStyle(
                          todayDecoration: BoxDecoration(
                            color: Colors.yellow,
                            shape: BoxShape.circle,
                          ),
                          selectedDecoration: BoxDecoration(
                            color: Colors.teal,
                            shape: BoxShape.circle,
                          )),
                      selectedDayPredicate: (day) {
                        return isSameDay(_selectedDay, day);
                      },
                      onDaySelected: ((selectedDay, focusedDay) {
                        if (!isSameDay(_selectedDay, selectedDay)) {
                          setState(() {
                            _selectedDay = selectedDay;
                            _focusedDay = focusedDay;
                            // debugPrint("yollo");
                          });
                        }
                      }),
                    )),
                  ),
                ),
              ),
            ),
            Flexible(
                child: SizedBox(
              height: 300,
              child: StreamBuilder(
                  stream:
                      CalenderPageService.getSnap(_selectedDay, currenrUserID),
                  builder:
                      (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                    if (streamSnapshot.hasData) {
                      //print("end");
                      if (streamSnapshot.data!.docs.isEmpty) {
                        return const Center(child: Text("No Task added yet"));
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
                                        width:
                                            MediaQuery.of(context).size.width *
                                                    0.5 -
                                                20,
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
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      child: Row(
                                        children: <Widget>[
                                          ElevatedButton(
                                              onPressed: () {
                                                //debugPrint("Open alert ");
                                                PredefinedWidgets
                                                    .showDialogForitems(
                                                        context,
                                                        tasks.title,
                                                        tasks.description,
                                                        tasks.time);
                                              },
                                              child: const Text("DESC")),
                                          IconButton(
                                              icon: const Icon(Icons.edit),
                                              onPressed: () {
                                                debugPrint(tasks.docId);
                                                tasks.setOperation("update");
                                                Get.toNamed(
                                                    Routes.updateTaskPage,
                                                    arguments: tasks);
                                              }),
                                          IconButton(
                                            icon: const Icon(Icons.delete),
                                            onPressed: () {
                                              _deleteItemsFromDatabase(
                                                  tasks.docId);
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
                      return const Center(child: Text("No Task added yet"));
                    }
                  }),
            )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            Get.toNamed(Routes.addTaskPage, arguments: _selectedDay);
          }),
    );
  }
}
