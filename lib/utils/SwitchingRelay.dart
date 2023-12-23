import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class SpeakerInterface {
  static setReminder(String msg, String uID) async {
    String userId = uID;
    DatabaseReference ref = FirebaseDatabase.instance.ref("$userId/Reminder");

    await ref.update({"Msg": msg});
    //.then(  (value) => {debugPrint("success")});
    await ref.update({"val": 1});
    //.then((value) => {debugPrint("success")});
  }

  static setMedecine(String msg, String uID) async {
    String userId = uID;
    DatabaseReference ref = FirebaseDatabase.instance.ref("$userId/Medecine");
    await ref.update({"type": msg}).then((value) => {debugPrint("success")});
    await ref.update({"val": 1}).then((value) => {debugPrint("success")});
  }

  static setRoutineMsg(String msg, String uID) async {
    String userId = uID;
    DatabaseReference ref = FirebaseDatabase.instance.ref("$userId/Routine");
    await ref.update({"Msg": msg}).then((value) => {debugPrint("success")});
    await ref.update({"val": 1}).then((value) => {debugPrint("success")});
  }
}

class SwitchingRelay {
  static checkRelayValue(String relayID, int relay, String uID) async {
    String userId = uID;
    DatabaseReference ref = FirebaseDatabase.instance.ref("$userId/RELAY");
    print(relayID.toUpperCase());
    await ref.update({relayID.toUpperCase(): relay}).then(
        (value) => {debugPrint("success")});
  }

  /*
  static checkRelayValue1(String relay, String uid) {
    if (relay == 'Relay1') {
      writeRelay1(true, uid);
      //print("Switching on relay1");
    } else if (relay == 'Relay2') {
      writeRelay2(true, uid);
    } else if (relay == 'Relay3') {
      writeRelay3(true, uid);
    } else if (relay == 'Relay4') {
      writeRelay4(true, uid);
    }
  }
*/
  static Future<void> writeRelay1(bool val, String uID) async {
    String userId = uID;
    DatabaseReference ref = FirebaseDatabase.instance.ref("$userId/RELAY");

    if (val == true) {
      await ref.update({"RELAY1": 1}).then((value) => {debugPrint("success")});
    } else {
      await ref.update({"RELAY1": 0}).then((value) => {debugPrint("success")});
    }
  }

  static Future<void> writeRelay2(bool val, String uID) async {
    String userId = uID;
    DatabaseReference ref = FirebaseDatabase.instance.ref("$userId/RELAY");
    if (val == true) {
      await ref.update({"RELAY2": 1}).then((value) => {debugPrint("success")});
    } else {
      await ref.update({"RELAY2": 0}).then((value) => {debugPrint("success")});
    }
  }

  static Future<void> writeRelay3(bool val, String uID) async {
    String userId = uID;
    DatabaseReference ref = FirebaseDatabase.instance.ref("$userId/RELAY");
    if (val == true) {
      await ref.update({"RELAY3": 1}).then((value) => {debugPrint("success")});
    } else {
      await ref.update({"RELAY3": 0}).then((value) => {debugPrint("success")});
    }
  }

  static Future<void> writeRelay4(bool val, String uID) async {
    String userId = uID;
    DatabaseReference ref = FirebaseDatabase.instance.ref("$userId/RELAY");
    if (val == true) {
      await ref.update({"RELAY4": 1}).then((value) => {debugPrint("success")});
    } else {
      await ref.update({"RELAY4": 0}).then((value) => {debugPrint("success")});
    }
  }
}
