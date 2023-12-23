import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elderly_people/utils/TimerRoutines.dart';
import 'package:elderly_people/widget/PredefinedWidgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

final _formKey = GlobalKey<FormBuilderState>();

class AddItemsPageService {
  static Future<String> addTaskToDB(String title, String desc, var itemDate,
      String userID, String time) async {
    String msg = await FirebaseFirestore.instance.collection('todoitems').add({
      'title': title,
      "description": desc,
      "date": DateFormat('yyyy-MM-dd').format(itemDate),
      "complete": false,
      "time": time,
      "userId": userID,
    }).then((value) {//adding to do list to database
      TimerRoutines.itemchange = true; 
      return "success";
    }).catchError((error) {
      return "error";
    });
    return msg;
  }
}

class _AddTaskPageState extends State<AddTaskPage> {
  final timeController = TextEditingController();
  var selectedDate;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedDate = Get.arguments;
    timeController.text = "08:00";
  }

  Future<void> _addItemToDatabse(BuildContext context) async {
    //-------------getting the value from from builder

    final title = _formKey.currentState!.fields['title']!.value;
    var desc = _formKey.currentState?.fields['desc']?.value;
    final itemDate = _formKey.currentState?.fields['date']?.value;
    final time = timeController.text;
    if (title == null) {
      return PredefinedWidgets.showMyErrorDialog(
          context, "Title cannot be empty", "Please type in the title");
    }
    //--checking desc if empty
    desc ??= "";

    var userID = FirebaseAuth.instance.currentUser!.uid;
    String Status = await AddItemsPageService.addTaskToDB(
        title, desc, itemDate, userID, time);
    if (Status == "success") {
      Navigator.pop(context);

      PredefinedWidgets.showMySuccessDialog(context, "Item succesfully added",
          "The item $title has been succesfully added \n ");
    } else {
      PredefinedWidgets.getSnackBarWidget("Error adding Items", "");
    }
  }
  // void _addItemToDatabse(BuildContext context) {
  //   //debugPrint(_formKey.currentState!.fields['title']!.value);
  //   final title = _formKey.currentState!.fields['title']!.value;
  //   final desc = _formKey.currentState!.fields['desc']!.value;
  //   final itemdate = _formKey.currentState!.fields['date']!.value;
  //   final complete = false;
  //   var userId = FirebaseAuth.instance.currentUser!.uid;
  //   //debugPrint("item DATE $itemdate");
  //   FirebaseFirestore.instance.collection('todoitems').add({
  //     'title': title,
  //     "description": desc,
  //     "date": itemdate,
  //     "complete": false,
  //     "userId": userId,
  //   }).then((value) {
  //     //debugPrint("adding to DB");
  //     //ListItem.getSnap(widget.task.date);
  //     Navigator.pop(context);

  //     PredefinedWidgets.showMySuccessDialog(
  //         context, "Item succesfully added", "The item $title has been succesfully added \n ");
  //   }).catchError((error) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Error adding item: $error')),
  //     );
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Add items"),
          // actions: [
          //   Center(
          //       child: ElevatedButton(
          //     onPressed: () {
          //       _addItemToDatabse(context);
          //     },
          //     child: const Text("Save"),
          //   ))
          // ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(10.0),
          children: <Widget>[
            FormBuilder(
                key: _formKey,
                child: Column(
                  children: [
                    FormBuilderTextField(
                      name: "title",
                      //initialValue: task1.title,
                      decoration: const InputDecoration(
                          hintText: "Add Title",
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(18.0)),
                    ),
                    const Divider(),
                    FormBuilderTextField(
                      name: "desc",
                      //initialValue: task1.description,
                      decoration: const InputDecoration(
                          hintText: "Add Description",
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(18.0)),
                    ),
                    const Divider(),
                    FormBuilderDateTimePicker(
                      name: "date",
                      initialValue: selectedDate,
                      //initialValue: task1.date,
                      //onChanged: (value) => getSnap(),
                      enabled: false,
                      fieldHintText: " Add Date",
                      inputType: InputType.date,
                      format: DateFormat('EEEE, dd MMMM ,yyyy'),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.calendar_month_rounded),
                      ),
                    ),
                    const Center(
                      child: Text("Time to be reminder:"),
                    ),
                    Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextField(
                          readOnly: true,
                          controller: timeController,
                          decoration:
                              const InputDecoration(hintText: 'Pick your Time'),
                          onTap: () async {
                            var time = await showTimePicker(
                                context: context, initialTime: TimeOfDay.now());

                            if (time != null) {
                              timeController.text = time.format(context);
                            }
                          },
                        )),
                    PredefinedWidgets.myButton(context, () {
                      _addItemToDatabse(context);
                    }, "Submit")
                  ],
                ))
          ],
        ));
  }
}
