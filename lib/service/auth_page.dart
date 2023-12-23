import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../pages/Home.dart';
import '../pages/login_page.dart';


class AuthPage extends StatelessWidget {
  AuthPage({super.key});

  
  void checkprint() {
    debugPrint("auth page getting called");
  }

  @override
  Widget build(BuildContext context) {
    //debugPrint("auth page");
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(), //checks if the user is log in
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            //checkprint();
            return Home();
          } else {
            //checkprint();
            return login_page();
          }
        },
      ),
    );
  }
}
