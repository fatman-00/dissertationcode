import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:telephony/telephony.dart';

class EmergencyContact {
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
    //converting the position data into a google map URL
    String url =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    print(url);
    return url;
  }

  static sendMessageToContact(String uID) async {
    String documentID = "";
    final user = uID;
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

    
    Position? currentlocation = await getCurrentLocation();// calling function to get location
    String url = "";
    if (currentlocation != null) {
      double latitude = currentlocation.latitude;//breaking down the location(of type position) in latitude
      double longitude = currentlocation.longitude;//breaking down the location(of type position) in longitude

      url = generateLocationUrl(latitude, longitude);//generating URL for google map
    } else {
      // Handle case when location is unavailable
      print('Unable to retrieve current location.');
    }

    try {
      Query<Map<String, dynamic>> subcollectionRef = FirebaseFirestore.instance
          .collection("contactInfo")
          .where("uid", isEqualTo: user);//retrieve contact information from database
      QuerySnapshot<Map<String, dynamic>> snapshot =
          await subcollectionRef.get();
      List<String> contactNumber = [];
      List<String> message = [];

      if (snapshot.size != 0) {
        for (var document in snapshot.docs) {
          Map<String, dynamic> data = document.data();
          contactNumber.add(data['ContactNumber']);//add contact number to list contact
          message.add(data['message']);//add messages to list messages
        }
        for (var i = 0; i < contactNumber.length; i++) {
          //print(message[i]);
          SendTelephony(contactNumber[i], " ${message[i]}Here's my location: $url");// adding the location url to the message
        }
      }
    } catch (e) {
      print('Error retrieving items from Firestore: $e');
    }

    // return items;
  }

  static final Telephony telephony = Telephony.instance;

  static SendTelephony(String contactNumber, String message) {
    // The function send message
    telephony.sendSms(
      to: contactNumber,
      message: message,
    );
    //.then((value) => print("Success"))
    //.onError((error, stackTrace) => print("error"));
  }
}
