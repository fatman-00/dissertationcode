import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elderly_people/utils/SwitchingRelay.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../pages/Home.dart';

class TimerRoutines {
  static Timer? _timer;
  static bool change = false;
  static bool itemchange = false;
  static bool timeChange = false;
  static bool routineChange = false;
  static int numOfRelay = 5;
  //static late String userID;
  static List<Map<String, dynamic>> listOfAppliance = [];
  static List<Map<String, dynamic>> listOftask = [];
  static List<Map<String, dynamic>> listOfMedicationTime = [];

  static getRoutinesFromDB(String userID) async {
    List<Map<String, dynamic>> listOfData = [];
    QuerySnapshot<Map<String, dynamic>> c = await FirebaseFirestore.instance
        .collection('Routines')
        .where("uid", isEqualTo: userID)
        .get();

    for (var documentSnapshot in c.docs) {
      Map<String, dynamic> data = documentSnapshot.data();
      listOfData.add(data);
    }
    listOfAppliance = listOfData;
    //print(listOfAppliance);
  }

  static getItems(String userID) async {
    List<Map<String, dynamic>> listOfData = [];
    QuerySnapshot<Map<String, dynamic>> c = await FirebaseFirestore.instance
        .collection('todoitems')
        .where("userId", isEqualTo: userID)
        .where("date",
            isEqualTo: DateFormat('yyyy-MM-dd')
                .format(DateTime.now())) //Get task due to today
        .get();

    for (var documentSnapshot in c.docs) {
      Map<String, dynamic> data = documentSnapshot.data();
      listOfData.add(data); //convert hte data to a list
    }
    listOftask = listOfData;
    //print(listOfAppliance);
  }

  static getMedicationTime(String userID) async {
    List<Map<String, dynamic>> listOfData = [];
    QuerySnapshot<Map<String, dynamic>> c = await FirebaseFirestore.instance
        .collection('MedicationTime')
        .where("uid", isEqualTo: userID)
        .get();

    for (var documentSnapshot in c.docs) {
      Map<String, dynamic> data = documentSnapshot.data();
      listOfData.add(data);
    }
    listOfMedicationTime = listOfData;
  }

  static TimeOfDay splitTime(String rTime) {
    List<String> timeParts = rTime.split(':');
    int hour = int.parse(timeParts[0]);
    int minute = int.parse(timeParts[1]);

    TimeOfDay time = TimeOfDay(hour: hour, minute: minute);
    return time;
  }

  static void startTimer(String uID) {
    //print("calling");
    getRoutinesFromDB(uID);
    getItems(uID);
    getMedicationTime(uID);
    // userID = uID;
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) async {
      TimeOfDay timeNow = TimeOfDay.now();
      getRoutinesFromDB(uID);

      print("before$listOfAppliance");

      if (itemchange == true) {
        print(true);
        await getItems(uID);
        itemchange = false;
      }
      if (timeChange == true) {
        print("time change");
        await getMedicationTime(uID);
        timeChange = false;
      }
      if (change == true) {
        //print("change id true");
        await getRoutinesFromDB(uID);
        change = false;
        routineChange = true;
        //Future.delayed(const Duration(seconds: 3), () {
        //print("inside teh list$listOfAppliance");
        //});
      }
      //print("after $listOfAppliance");
      if (listOftask.isNotEmpty) {
        //print("hello");
        for (var task in listOftask) {
          TimeOfDay reminderTime = splitTime(task['time']);
          print("reminderTime $reminderTime");
          if (reminderTime == timeNow) {
            //if time matches the execute notification call
            /*if (reminderTime == TimeOfDay.now() ||
              reminderTime.replacing(
                    hour: reminderTime.hour,
                    minute: reminderTime.minute + 1,
                  ) ==
                  TimeOfDay.now()) {
                    */
            //print("Reminder yes");

            notifi.sendNotification(
                "Reminder:${task['title']}", "${task['description']}");
            print("Reminder:${task['title']}${task['description']}");
            SpeakerInterface.setReminder(
                "Reminder          ${task['title']}                            Description                    ${task['description']}",
                uID); //play alarm + text to speech on speaker
          }
        }
      }
      if (listOfMedicationTime.isNotEmpty) {
        for (var time in listOfMedicationTime) {
          TimeOfDay morning = splitTime(time['morning']);
          TimeOfDay noon = splitTime(time['noon']);
          TimeOfDay night = splitTime(time['night']);
          //  print("morning time ${morning.replacing(
          //    hour: night.hour,
          //    minute: night.minute + 1,
          //  )}");
          print("Morning time $morning");

          if (morning == timeNow) {
            print("sending Morning");

            notifi.sendNotification(
                "Morning Medication", "Please take your morning medication");
            SpeakerInterface.setMedecine("morning", uID);
          }
          print("Morning time $noon");

          if (noon == timeNow) {
            print("sending");
            notifi.sendNotification(
                "Noon medication", "Please take you're noon medications");
            SpeakerInterface.setMedecine("noon", uID);
          }
          print("Morning time $night");

          if (night == timeNow) {
            print("sending night");
            notifi.sendNotification(
                "Night medication", "Please take you're night medications");
            SpeakerInterface.setMedecine("night", uID);
          }
        }
      }
      if (listOfAppliance.isNotEmpty) {
        //print("not empty");
        if (routineChange == true) {
          //print("Routine change------------------------------------------------------------------");
          Future.delayed(const Duration(seconds: 3), () {
            for (var items in listOfAppliance) {
              String setuptime = items['time'];
              List<String> timeParts = setuptime.split(':');
              int hour = int.parse(timeParts[0]);
              int minute = int.parse(timeParts[1]);

              TimeOfDay time = TimeOfDay(hour: hour, minute: minute);
              print("Time now $timeNow");
              print("appliance name:$time");
              if (time == timeNow) {
                //print("current time $timeNow");
                for (var i = 1; i < numOfRelay; i++) {
                  if (items["Relay$i"] != -1) {
                    SwitchingRelay.checkRelayValue(
                        "Relay$i", items["Relay$i"], uID);
                  }
                }
                SpeakerInterface.setRoutineMsg(items['message'], uID);
                //SwitchingRelay.checkRelayValue(items['relayConnected'], uID);
              }
              //print("time db:$time timenow :${TimeOfDay.now()}");
            }
            routineChange = false;
            print("routineChange$routineChange");
          });
        } else {
          for (var items in listOfAppliance) {
            String setuptime = items['time'];
            List<String> timeParts = setuptime.split(':');
            int hour = int.parse(timeParts[0]);
            int minute = int.parse(timeParts[1]);

            TimeOfDay time = TimeOfDay(hour: hour, minute: minute);
            print("Time now $timeNow");
            print("appliance name:$time");
            if (time == timeNow) {
              //print("current time $timeNow");
              for (var i = 1; i < numOfRelay; i++) {
                if (items["Relay$i"] != -1) {
                  SwitchingRelay.checkRelayValue(
                      "Relay$i", items["Relay$i"], uID);
                }
              }
              SpeakerInterface.setRoutineMsg(items['message'], uID);
              //SwitchingRelay.checkRelayValue(items['relayConnected'], uID);
            }
            //print("time db:$time timenow :${TimeOfDay.now()}");
          }
        }
      }
      print(
          "---------------------------------------------------------------------");
      //print('Function executed every minutes');
    });
  }
}
/*

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elderly_people/utils/SwitchingRelay.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../pages/Home.dart';

class TimerRoutines {
  static Timer? _timer;
  static bool change = false;
  static bool itemchange = false;
  static bool timeChange = false;
  static int numOfRelay = 5;
  //static late String userID;
  static List<Map<String, dynamic>> listOfAppliance = [];
  static List<Map<String, dynamic>> listOftask = [];
  static List<Map<String, dynamic>> listOfMedicationTime = [];

  static getRoutinesFromDB(String userID) async {
    List<Map<String, dynamic>> listOfData = [];
    QuerySnapshot<Map<String, dynamic>> c = await FirebaseFirestore.instance
        .collection('Routines')
        .where("uid", isEqualTo: userID)
        .get();

    for (var documentSnapshot in c.docs) {
      Map<String, dynamic> data = documentSnapshot.data();
      listOfData.add(data);
    }
    listOfAppliance = listOfData;
    //print(listOfAppliance);
  }

  static getItems(String userID) async {
    List<Map<String, dynamic>> listOfData = [];
    QuerySnapshot<Map<String, dynamic>> c = await FirebaseFirestore.instance
        .collection('todoitems')
        .where("userId", isEqualTo: userID)
        .where("date",
            isEqualTo: DateFormat('yyyy-MM-dd').format(DateTime.now()))
        .get();

    for (var documentSnapshot in c.docs) {
      Map<String, dynamic> data = documentSnapshot.data();
      listOfData.add(data);
    }
    listOftask = listOfData;
    //print(listOfAppliance);
  }

  static getMedicationTime(String userID) async {
    List<Map<String, dynamic>> listOfData = [];
    QuerySnapshot<Map<String, dynamic>> c = await FirebaseFirestore.instance
        .collection('MedicationTime')
        .where("uid", isEqualTo: userID)
        .get();

    for (var documentSnapshot in c.docs) {
      Map<String, dynamic> data = documentSnapshot.data();
      listOfData.add(data);
    }
    listOfMedicationTime = listOfData;
  }

  static TimeOfDay splitTime(String rTime) {
    List<String> timeParts = rTime.split(':');
    int hour = int.parse(timeParts[0]);
    int minute = int.parse(timeParts[1]);

    TimeOfDay time = TimeOfDay(hour: hour, minute: minute);
    return time;
  }

  static void startTimer(String uID) {
    //print("calling");
    getRoutinesFromDB(uID);
    getItems(uID);
    getMedicationTime(uID);
    // userID = uID;
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      TimeOfDay timeNow = TimeOfDay.now();
      //print(listOfAppliance);
      if (itemchange == true) {
        print(true);
        getItems(uID);
        itemchange = false;
      }
      if (timeChange == true) {
        getMedicationTime(uID);
        timeChange = false;
      }
      if (change == true) {
        getRoutinesFromDB(uID);
        change = false;
      }
      if (listOftask.isNotEmpty) {
        print("hello");
        for (var task in listOftask) {
          TimeOfDay reminderTime = splitTime(task['time']);
          print("reminderTime $reminderTime");
           if (reminderTime == TimeOfDay.now() ||
              reminderTime.replacing(
                    hour: reminderTime.hour,
                    minute: reminderTime.minute + 1,
                  ) ==
                  TimeOfDay.now()) {
          /*if (reminderTime == TimeOfDay.now() ||
              reminderTime.replacing(
                    hour: reminderTime.hour,
                    minute: reminderTime.minute + 1,
                  ) ==
                  TimeOfDay.now()) {
                    */
            print("Reminder yes");
            notifi.sendNotification(
                "Reminder:${task['title']}", "${task['description']}");
            SpeakerInterface.setReminder(
                "The following task is due ${task['title']}", uID);
          }
        }
      }
      if (listOfMedicationTime.isNotEmpty) {
        for (var time in listOfMedicationTime) {
          TimeOfDay morning = splitTime(time['morning']);
          TimeOfDay noon = splitTime(time['noon']);
          TimeOfDay night = splitTime(time['night']);
          print("morning time ${night.replacing(
            hour: night.hour,
            minute: night.minute + 1,
          )}");

          if (morning == TimeOfDay.now() ||
              morning.replacing(
                    hour: morning.hour,
                    minute: morning.minute + 1,
                  ) ==
                  TimeOfDay.now()) {
            notifi.sendNotification(
                "Morning Medication", "Please take your morning medication");
            SpeakerInterface.setMedecine("morning", uID);
          }
          if (noon == TimeOfDay.now() ||
              noon.replacing(
                    hour: noon.hour,
                    minute: noon.minute + 1,
                  ) ==
                  TimeOfDay.now()) {
            print("sending");
            notifi.sendNotification(
                "Noon medication", "Please take you're noon medications");
            SpeakerInterface.setMedecine("noon", uID);
          }
          if (night == TimeOfDay.now() ||
              night.replacing(
                    hour: night.hour,
                    minute: night.minute + 1,
                  ) ==
                  TimeOfDay.now()) {
            print("sending");
            notifi.sendNotification(
                "Night medication", "Please take you're night medications");
            SpeakerInterface.setMedecine("night", uID);
          }
        }
      }
      if (listOfAppliance.isNotEmpty) {
        //print("not empty");
        for (var items in listOfAppliance) {
          String setuptime = items['time'];
          List<String> timeParts = setuptime.split(':');
          int hour = int.parse(timeParts[0]);
          int minute = int.parse(timeParts[1]);

          TimeOfDay time = TimeOfDay(hour: hour, minute: minute);

          if (time == TimeOfDay.now() ||
              TimeOfDay(hour: hour, minute: minute + 1) == TimeOfDay.now()) {
            //print("yess");
            for (var i = 1; i < numOfRelay; i++) {
              if (items["Relay$i"] != -1) {
                SwitchingRelay.checkRelayValue(
                    "Relay$i", items["Relay$i"], uID);
              }
            }
            //SwitchingRelay.checkRelayValue(items['relayConnected'], uID);
          }
          //print("time db:$time timenow :${TimeOfDay.now()}");
        }
      }

      //print('Function executed every minutes');
    });
  }
}

 */