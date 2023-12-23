import 'package:elderly_people/utils/TimerRoutines.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elderly_people/model/ToDoListModel.dart';
import 'package:elderly_people/widget/PredefinedWidgets.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class UpdateTaskPageService {
  static Future<String> updateDatabase(String docID, String title, String desc,
      DateTime date, String time) async {
    final CollectionReference _product =
        FirebaseFirestore.instance.collection("todoitems");
    String msg = await _product.doc(docID).update({
      'title': title,
      'description': desc,
      'date': DateFormat('yyyy-MM-dd').format(date),
      'time': time,
    }).then((value) {
      TimerRoutines.itemchange = true;
      print(TimerRoutines.timeChange);
      return "success";
    }).catchError((error) {
      return "error";
    });
    return msg;
  }
}

final _formKey = GlobalKey<FormBuilderState>();

class UpdateTaskPage extends StatefulWidget {
  const UpdateTaskPage({super.key});

  @override
  State<UpdateTaskPage> createState() => _UpdateTaskPageState();
}

class _UpdateTaskPageState extends State<UpdateTaskPage> {
  Future<void> updateItemToDatabase(
      BuildContext context, ToDoListModel task, String time) async {
    final title = _formKey.currentState!.fields['title']!.value;
    final desc = _formKey.currentState!.fields['desc']!.value;
    final itemdate = _formKey.currentState!.fields['date']!.value;
    String docID = task.docId;
    if (title == "") {
      PredefinedWidgets.showMyErrorDialog(context, "Error", "title is empty");
    } else {
      String msg = await UpdateTaskPageService.updateDatabase(
          docID, title, desc, itemdate, time);
      if (msg == "success") {
        //print("to plm");
        //print("changed");
        Navigator.pop(context);
        PredefinedWidgets.showMySuccessDialog(
            context,
            "Item succesfully Updated",
            "The item $title has been succesfully updated \n ");
      } else {
        PredefinedWidgets.getSnackBarWidget("Error adding Items", "");
      }
    }

    //Navigator.pop(context);
  }

  late ToDoListModel taskToUpdate;
  final timeController = TextEditingController();
  var selectedDate;
  @override
  void initState() {
    // TODO: implement initState
    taskToUpdate = Get.arguments;
    selectedDate = taskToUpdate.date;
    timeController.text = taskToUpdate.time;
    super.initState();
  }

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
                      initialValue: taskToUpdate.title,
                      decoration: const InputDecoration(
                          hintText: "Add Title",
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(18.0)),
                    ),
                    const Divider(),
                    FormBuilderTextField(
                      name: "desc",
                      initialValue: taskToUpdate.description,
                      decoration: const InputDecoration(
                          hintText: "Add Description",
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(18.0)),
                    ),
                    const Divider(),
                    FormBuilderDateTimePicker(
                      name: "date",
                      initialValue: taskToUpdate.date,
                      //enabled: false,
                      fieldHintText: " Add Date",
                      inputType: InputType.date,
                      format: DateFormat('EEEE, dd MMMM ,yyyy'),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.calendar_month_rounded),
                      ),
                    ),
                    const Center(
                      child: Text(
                        "Time to be reminder:",
                        style: TextStyle(fontSize: 18),
                      ),
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
                      updateItemToDatabase(
                          context, taskToUpdate, timeController.text);
                    }, "Submit")
                  ],
                ))
          ],
        ));
  }
}
/*class _UpdateTaskPageState extends State<UpdateTaskPage> {
  Future<void> UpdateItemToDatabase(
      BuildContext context, ToDoListModel task) async {
    final title = _formKey.currentState!.fields['title']!.value;
    final desc = _formKey.currentState!.fields['desc']!.value;
    final itemdate = _formKey.currentState!.fields['date']!.value;
    String docID = task.docId;
    String msg = await UpdateTaskPageService.updateDatabase(
        docID, title, desc, itemdate);
    if (msg == "success") {
      print("to plm");
      
      Navigator.pop(context);
      PredefinedWidgets.showMySuccessDialog(context, "Item succesfully Updated",
          "The item $title has been succesfully updated \n ");
      
    } else {
      PredefinedWidgets.getSnackBarWidget("Error adding Items", "");
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final ToDoListModel taskToUpdate = Get.arguments;
    return Scaffold(
        appBar: AppBar(
          title: const Text("update items"),
          actions: [
            Center(
                child: ElevatedButton(
              onPressed: () {
                //_addItemToDatabse(context);
                UpdateItemToDatabase(context, taskToUpdate);
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
                      initialValue: taskToUpdate.title,
                      decoration: const InputDecoration(
                          hintText: "Add Title",
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(18.0)),
                    ),
                    const Divider(),
                    FormBuilderTextField(
                      name: "desc",
                      initialValue: taskToUpdate.description,
                      decoration: const InputDecoration(
                          hintText: "Add Description",
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(18.0)),
                    ),
                    const Divider(),
                    FormBuilderDateTimePicker(
                      name: "date",
                      initialValue: taskToUpdate.date,
                      //enabled: false,
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
*/
/*class _AddTaskPageState extends State<AddTaskPage> {
  var selectedDate;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedDate = Get.arguments;
  }

  Future<void> _addItemToDatabse(BuildContext context) async {
    //-------------getting the value from from builder
    final title = _formKey.currentState!.fields['title']!.value;
    var desc = _formKey.currentState?.fields['desc']?.value;
    final itemDate = _formKey.currentState?.fields['date']?.value;
    if (title == null) {
      return PredefinedWidgets.showMyErrorDialog(
          context, "Title cannot be empty", "Please type in the title");
    }
    //--checking desc if empty
    desc ??= "";

    var userID = FirebaseAuth.instance.currentUser!.uid;
    String Status =
        await AddItemsPageService.addTaskToDB(title, desc, itemDate, userID);
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

}*/
