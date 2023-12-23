import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import '../model/routeToDoList.dart';
import '../service/ListViewService.dart';
import '../widget/PredefinedWidgets.dart';

class AdditemsPage extends StatefulWidget {
  //final DateTime selectedDate;
  final routeToDoList task;
  const AdditemsPage({
    super.key,
    //required this.selectedDate,
    required this.task,
  });

  @override
  State<AdditemsPage> createState() => _AdditemsPageState();
}

class AddItemsPageService {
  static Future<String> addTaskToDB(
      String title, String desc, var itemDate, String userID) async {
    String msg = await FirebaseFirestore.instance.collection('todoitems').add({
      'title': title,
      "description": desc,
      "date": itemDate,
      "complete": false,
      "userId": userID,
    }).then((value) {
      return "success";
    }).catchError((error) {
      return "error";
    });
    return msg;
  }
}

class _AdditemsPageState extends State<AdditemsPage> {
  ListViewService d = ListViewService();
  void checkCreateOrUpdate(String operation, routeToDoList r1) {
    if (operation == "create") {
      _addItemToDatabse(context);
    } else if (operation == "update") {
      UpdateItemToDatabase();
    }
  }

  Future<void> UpdateItemToDatabase() async {
    final title = _formKey.currentState!.fields['title']!.value;
    final desc = _formKey.currentState!.fields['desc']!.value;
    final itemdate = _formKey.currentState!.fields['date']!.value;
    String docID = widget.task.docId;
    String msg = await d.updateDatabase(docID, title, desc, itemdate);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(' $msg')),
    );
    Navigator.pop(context);
    
  }

  Future<void> _addItemToDatabse(BuildContext context) async {
    final title = _formKey.currentState!.fields['title']!.value;
    final desc = _formKey.currentState!.fields['desc']!.value;
    final itemDate = _formKey.currentState!.fields['date']!.value;
    var userID = FirebaseAuth.instance.currentUser!.uid;
    String Status =
       await  AddItemsPageService.addTaskToDB(title, desc, itemDate, userID);
    if (Status == "success") {
      Navigator.pop(context);

      PredefinedWidgets.getSnackBarWidget("Item added successfully", "");
    } else {
      PredefinedWidgets.getSnackBarWidget("Error adding Items", "");
    }
  }
  /*void _addItemToDatabse(BuildContext context) {
    //debugPrint(_formKey.currentState!.fields['title']!.value);
    final title = _formKey.currentState!.fields['title']!.value;
    final desc = _formKey.currentState!.fields['desc']!.value;
    final itemdate = _formKey.currentState!.fields['date']!.value;
    final complete = false;
    var userId = "A9vQ2dJPRHNTEpevE887n4YCxGA2";
    debugPrint("item DATE $itemdate");
    FirebaseFirestore.instance.collection('todoitems').add({
      'title': title,
      "description": desc,
      "date": itemdate,
      "complete": false,
      "userId": userId,
    }).then((value) {
      //debugPrint("adding to DB");
      //ListItem.getSnap(widget.task.date);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Item added successfully')),
      );
      Navigator.pop(context);
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding item: $error')),
      );
    });
  }*/

  final _formKey = GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {
    final routeToDoList task1 = widget.task;

    return Scaffold(
        appBar: AppBar(
          title: const Text("Add items"),
          actions: [
            Center(
                child: ElevatedButton(
              onPressed: () async {
                checkCreateOrUpdate(task1.operation, task1);
                //_addItemToDatabse(context);
              },
              child: const Text("Save"),
            ))
          ],
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
                      initialValue: task1.title,
                      decoration: const InputDecoration(
                          hintText: "Add Title",
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(18.0)),
                    ),
                    const Divider(),
                    FormBuilderTextField(
                      name: "desc",
                      initialValue: task1.description,
                      decoration: const InputDecoration(
                          hintText: "Add Description",
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(18.0)),
                    ),
                    const Divider(),
                    FormBuilderDateTimePicker(
                      name: "date",
                      //initialValue: widget.selectedDate,
                      initialValue: task1.date,
                      //onChanged: (value) => getSnap(),
                      fieldHintText: " Add Date",
                      inputType: InputType.date,
                      format: DateFormat('EEEE, dd MMMM ,yyyy'),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.calendar_month_rounded),
                      ),
                    )
                  ],
                ))
          ],
        ));
  }
}
