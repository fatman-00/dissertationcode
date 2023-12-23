import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:elderly_people/widget/PredefinedWidgets.dart';
import 'package:get/get.dart';

class ChangeUserDetails extends StatefulWidget {
  const ChangeUserDetails({super.key});

  @override
  State<ChangeUserDetails> createState() => _ChangeUserDetailsState();
}

class ChangeUserDetailsService {
  static updateDetails(
      BuildContext context,
      String uId,
      String email,
      String fname,
      String lname,
      String docID,
      String oriEmail,
      String oriFname,
      String orilname) async {
    int c = 0;
    int emailVal = 0;
    int success = 0;
    final CollectionReference _user =
        FirebaseFirestore.instance.collection("user");
    if (email == "") {
      PredefinedWidgets.showMyErrorDialog(
          context, "Empty Field", "Empty Email field");
    } else if (fname == "") {
      PredefinedWidgets.showMyErrorDialog(
          context, "Empty Field", "Empty first name field");
    } else if (lname == "") {
      PredefinedWidgets.showMyErrorDialog(
          context, "Empty Field", "Empty last name field");
    } else {
      User? user = FirebaseAuth.instance.currentUser;

      if (email != oriEmail) {
        await user!.updateEmail(email).then((value) {
          c = 1;
          PredefinedWidgets.showMySuccessDialog(
              context, "Success", "The values $email has been updated ");
        }).onError((error, stackTrace) {
          PredefinedWidgets.showMyErrorDialog(context, "Error",
              "Something when wrong.Please try Login in again");
        });
      }
      if (fname != oriFname) {
        _user.doc(docID).update({
          'fname': fname,
        }).then((value) {
          c = 1;
          PredefinedWidgets.showMySuccessDialog(
              context, "Success", "The values $fname  has been updated ");
        }).catchError((error) {
          PredefinedWidgets.showMyErrorDialog(
              context, "Error", "Something when wrong.Please try again later");
        });
      }
      if (lname != orilname) {
        _user.doc(docID).update({
          'lname': lname,
        }).then((value) {
          c = 1;

          PredefinedWidgets.showMySuccessDialog(
              context, "Success", "The value $lname has been updated ");
        }).catchError((error) {
          PredefinedWidgets.showMyErrorDialog(
              context, "Error", "Something when wrong.Please try again later");
        });
      }
      if (c == 1) {
        Get.back();
      }
    }
    /*if (email != "" && email != oriEmail) {
      User? user = FirebaseAuth.instance.currentUser;
      await user!.updateEmail(email).then((value) {
        success = 1;

        PredefinedWidgets.showMySuccessDialog(
            context, "Success", "The values $email has been updated ");

        emailVal = 1;
      }).onError((error, stackTrace) {
        PredefinedWidgets.showMyErrorDialog(
            context, "Error", "Something when wrong.Please try Login in again");
      });
    }
    if (fname != "" && lname != "" && fname != oriFname && lname != orilname) {
      _user.doc(docID).update({
        'fname': fname,
        'lname': lname,
      }).then((value) {
        success = 1;

        if (emailVal == 1) {
          PredefinedWidgets.showMySuccessDialog(context, "Success",
              "The values $email, $fname and $lname has been updated ");
        } else {
          PredefinedWidgets.showMySuccessDialog(context, "Success",
              "The values $fname and $lname has been updated ");
        }
      }).catchError((error) {
        PredefinedWidgets.showMyErrorDialog(
            context, "Error", "Something when wrong.Please try again later");
      });
    } else if (lname != "" && lname != orilname) {
      _user.doc(docID).update({
        'lname': lname,
      }).then((value) {
        success = 1;

        if (emailVal == 1) {
          PredefinedWidgets.showMySuccessDialog(context, "Success",
              "The value $email and $lname has been updated ");
        } else {
          PredefinedWidgets.showMySuccessDialog(
              context, "Success", "The value $lname has been updated ");
        }
      }).catchError((error) {
        PredefinedWidgets.showMyErrorDialog(
            context, "Error", "Something when wrong.Please try again later");
      });
    } else if (fname != "" && fname != oriFname) {
      _user.doc(docID).update({
        'fname': fname,
      }).then((value) {
        success = 1;
        if (emailVal == 1) {
          PredefinedWidgets.showMySuccessDialog(context, "Success",
              "The value $email and $fname has been updated ");
        } else {
          PredefinedWidgets.showMySuccessDialog(
              context, "Success", "The value $fname has been updated ");
        }
      }).catchError((error) {
        PredefinedWidgets.showMyErrorDialog(
            context, "Error", "Something when wrong.Please try again later");
      });
    }*/
    // if (success == 1) {
    //   Get.back();
    // }
  }

  //static updateEmail(String newEmail) async {}
}

class _ChangeUserDetailsState extends State<ChangeUserDetails> {
  late String uID;
  late String oriEmail;
  late String oriFname;
  late String orilname;
  late String docID;
  TextEditingController email = TextEditingController();
  TextEditingController fname = TextEditingController();
  TextEditingController lname = TextEditingController();

  @override
  void initState() {
    super.initState();

    uID = FirebaseAuth.instance.currentUser!.uid;
    oriEmail = FirebaseAuth.instance.currentUser!.email!;
    email.text = oriEmail;
    getUserDetails(uID);
    //print("$docID $oriFname $lname");
  }

  getUserDetails(String uID) async {
    Map<String, dynamic> data = {};

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('user')
        .where('uid', isEqualTo: uID)
        .get();

    for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
      data = docSnapshot.data() as Map<String, dynamic>;
      //print(docSnapshot.id);
      docID = docSnapshot.id;
      oriFname = data['fname'];
      orilname = data['lname'];
    }
    fname.text = oriFname;
    lname.text = orilname;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Change Details")),
      body: Center(
        child: Column(children: <Widget>[
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Email:"),
              ),
              Expanded(
                child: PredefinedWidgets.getTextField(email, "email", false),
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("First name:"),
              ),
              Expanded(
                child:
                    PredefinedWidgets.getTextField(fname, "First name", false),
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Last name:"),
              ),
              Expanded(
                child:
                    PredefinedWidgets.getTextField(lname, "Last name", false),
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          PredefinedWidgets.myButton(context, () {
            ChangeUserDetailsService.updateDetails(
                context,
                uID,
                email.text.trim(),
                fname.text.trim(),
                lname.text.trim(),
                docID,
                oriEmail,
                oriFname,
                orilname);
          }, "Sumbit")
        ]),
      ),
    );
  }
}
