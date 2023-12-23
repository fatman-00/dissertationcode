import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:telephony/telephony.dart';

class SendSms extends StatefulWidget {
  const SendSms({super.key});

  @override
  State<SendSms> createState() => _SendSmsState();
}

class SendSmsService {
  static Future<Position?> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are disabled
      return null;
    }

    // Check if location permission is granted
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // Location permission is denied, request permission
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        // Location permission not granted
        return null;
      }
    }

    // Retrieve current position
    return await Geolocator.getCurrentPosition();
  }

  static String generateLocationUrl(double latitude, double longitude) {
    String url =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    print(url);
    return url;
  }

/*  static sendMessageToContact() async {
    Telephony telephony = Telephony.instance;
    //print("yess");

    bool? permissionsGranted = await telephony.requestPhoneAndSmsPermissions;

    String rMsg = "";
    await telephony
        .sendSms(
          to: "57686782",
          message: "hi",
        )
        .then((value) => rMsg = "Sucess")
        .onError((error, stackTrace) => rMsg = "Error");

    print(rMsg);
    return rMsg;
    //return items;
  }
*/

  static sendMessageToContact() async {
    String documentID = "";
    final user = FirebaseAuth.instance.currentUser?.uid;
    // print(user);
    try {
      //
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection("user")
          .where("uid", isEqualTo: user)
          .get();

      List<QueryDocumentSnapshot<Map<String, dynamic>>> documents =
          snapshot.docs;

      for (QueryDocumentSnapshot<Map<String, dynamic>> document in documents) {
        documentID = document.id;
      }
    } catch (e) {
      print('Error retrieving items from Firestore: $e');
    }

    // ignore: unused_local_variable
    Position? currentlocation = await SendSmsService.getCurrentLocation();
    String url = "";
    if (currentlocation != null) {
      double latitude = currentlocation.latitude;
      double longitude = currentlocation.longitude;

      url = SendSmsService.generateLocationUrl(latitude, longitude);
    } else {
      // Handle case when location is unavailable
      print('Unable to retrieve current location.');
    }
    //print("yess");
    // List<Map<String, dynamic>> items = [{""}];

    try {
      CollectionReference<Map<String, dynamic>> subcollectionRef =
          FirebaseFirestore.instance
              .collection("user")
              .doc(documentID)
              .collection('contactInfo');

      QuerySnapshot<Map<String, dynamic>> snapshot =
          await subcollectionRef.get();
      List<String> contactNumber = [];
      List<String> message = [];

      if (snapshot.size == 0) {
        //print("No contact list availble");
      } else {
        for (var document in snapshot.docs) {
          Map<String, dynamic> data = document.data();
          print(data['message']);
          print(document.data()['ContactNumber']);
          contactNumber.add(data['ContactNumber']);
          message.add(data['message']);
        }
        for (var i = 0; i < contactNumber.length; i++) {
          print(message[i]);
          SendSmsService.SendTelephony(
              contactNumber[i], " ${message[i]}'s my location: $url");
        }
      }
    } catch (e) {
      print('Error retrieving items from Firestore: $e');
    }

    // return items;
  }

  static final Telephony telephony = Telephony.instance;

  static SendTelephony(String contactNumber, String message) {
    print(message);
    telephony
        .sendSms(
          to: contactNumber,
          message: message,
        )
        .then((value) => print("Success"))
        .onError((error, stackTrace) => print("error"));
  }
}

class _SendSmsState extends State<SendSms> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Center(
      child: Column(children: [
        ElevatedButton(
            onPressed: () async {
              SendSmsService.sendMessageToContact();
            },
            child: Text("SOS"))
      ]),
    ));
  }
}
