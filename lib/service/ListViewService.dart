import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_tts/flutter_tts.dart';

class ListViewService {
  final CollectionReference _product =
      FirebaseFirestore.instance.collection("todoitems");
  static late Stream<QuerySnapshot> orderStream;
  
  //-----------------------------------------------------------------TextToSpeech function
  static FlutterTts speaker = FlutterTts();
  static void textToSpeech(String title, String desc) async {
    await speaker.setLanguage('en-US');
    await speaker.setVolume(1);
    await speaker.setSpeechRate(0.5);
    await speaker.setPitch(1);
    await speaker.speak(title);
    await Future.delayed(const Duration(seconds: 4));
    await speaker.speak(desc);

  }


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
  Stream<QuerySnapshot<Map<String, dynamic>>> getSnap(DateTime selectedDate,String uID) {
    //print("sda ${Timestamp.fromDate(selectedDate)}");

    return FirebaseFirestore.instance
        .collection('todoitems')
        .where('userId', isEqualTo: uID)
        .where('date', isEqualTo: selectedDate)
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
}
