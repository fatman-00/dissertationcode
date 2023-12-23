import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class Camera {
  static Future<String> getImageURL(String uID) async {
    String? imageURL = 'gs://elderly-people-8d142.appspot.com/images/image.jpg';
    final snapshot =
        await FirebaseDatabase.instance.ref().child('$uID/cameraImage').get();
    if (snapshot.exists) {
      imageURL=snapshot.value as String?;
    } 
    String downloadURL = await firebase_storage.FirebaseStorage.instance
        .refFromURL(imageURL!)
        .getDownloadURL();
    return downloadURL;
  } 
}

class CameraPage extends StatelessWidget {
  CameraPage({super.key});
  late String uID = FirebaseAuth.instance.currentUser!.uid;

  Future<String> getImageURL(String uID) async {
    String? imageURL = 'gs://elderly-people-8d142.appspot.com/images/creation.png';
    final snapshot =
        await FirebaseDatabase.instance.ref().child('$uID/cameraImage').get();
    if (snapshot.exists) {
      imageURL=snapshot.value as String?;
    } 
    String downloadURL = await firebase_storage.FirebaseStorage.instance
        .refFromURL(imageURL!)
        .getDownloadURL();
    return downloadURL;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: getImageURL(uID),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text('An error has occur : ${snapshot.error}'),
          );
        }

        if (snapshot.hasData) {
          String downloadURL = snapshot.data!;

          return Center(
            child: Image.network(downloadURL),
          );
        }

        return const Center(
          child: Text('No image data available'),
        );
      },
    );
  }
}
