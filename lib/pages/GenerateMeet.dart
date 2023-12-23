import 'dart:math';

import 'package:elderly_people/widget/PredefinedWidgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:telephony/telephony.dart';
import 'package:url_launcher/url_launcher.dart';

class GenerateMeet extends StatefulWidget {
  const GenerateMeet({super.key});

  @override
  State<GenerateMeet> createState() => _GenerateMeetState();
}

class _GenerateMeetState extends State<GenerateMeet> {
  String jitsiLink = "https://meet.jit.si/";

  TextEditingController link = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  static final Telephony telephony = Telephony.instance;

  late String uid;
  late String finalLink = "";
  @override
  void initState() {
    // TODO: implement initState
    uid = FirebaseAuth.instance.currentUser!.uid;
    super.initState();
    link.text = setLinkText();
  }

  // void shareMessageToWhatsApp(List<String> phoneNumbers) async {
  //   String message = setLinkText();
  //   final url =
  //       'https://wa.me/${phoneNumbers.join(",")}?text=${Uri.encodeComponent(message)}';
  //   if (await canLaunch(url)) {
  //     await launch(url);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }

  String generateRandomString(int len) {
    var r = Random();
    return String.fromCharCodes(
        List.generate(len, (index) => r.nextInt(26) + 65));
  }

  String setLinkText() {
    finalLink = (jitsiLink + generateRandomString(15) + uid);
    return finalLink;
  }

  static SendTelephony(
      BuildContext context, String contactNumber, String message) {
    // print(message);
    telephony
        .sendSms(
      to: contactNumber,
      message: message,
    ).then((value) {
      PredefinedWidgets.showMySuccessDialog(
          context, "Success", "The message has been successfully sent");
    }).onError((error, stackTrace) {
      PredefinedWidgets.showMyErrorDialog(
          context, "Error", "something when wrong.Please try again");
    });
  }

  void sendText() {
    String number = phoneNumber.text;
    String genLink = link.text;
    if (number.isEmpty) {
      PredefinedWidgets.showMyErrorDialog(context, "Phone number is empty",
          "Please add at lease one phone number");
    } else if (genLink == "Please press the generate button") {
      PredefinedWidgets.showMyErrorDialog(context, "Phone number is empty",
          "Please add at lease one phone number");
    } else {
      //bool check = true;
      bool check =
          RegExp(r'^[0-9 ]+$').hasMatch(number);
      if (check == true) {
        List<String> numbers =
            number.split(" ").map((number) => number.trim()).toList();
        //print(numbers);
        for (var i = 0; i < numbers.length; i++) {
          SendTelephony(context, numbers[i], "Join this link $genLink");
        }
      } else {
        PredefinedWidgets.showMyErrorDialog(
            context,
            "Alphabets detected in fields",
            "Please check the numbers you enter.It contains alphabets");
      }
    }
  }
// void requestPermissions() async {
//   final permissions = [
//     Permission.microphone,
//     Permission.modifyAudioSettings,
//   ];

//   final status = await permissions.request();

//   if (status[Permission.microphone].isGranted &&
//       status[Permission.modifyAudioSettings].isGranted) {
//     // Permissions granted, proceed with audio-related functionality
//   } else {
//     // Permissions not granted, handle accordingly
//   }
// }
  // void launchURLBrowser(BuildContext context, String link) async {
  //   //   final Uri url = Uri.parse('https://flutter.dev');
  //   // if (!await launchUrl(url)) {
  //   //       throw Exception('Could not launch $_url');
  //   // }
  //   var url = Uri.parse(link);
  //   if (await canLaunchUrl(url)) {
  //     await launchUrl(url);
  //   } else {
  //     // ignore: use_build_context_synchronously
  //     PredefinedWidgets.showMyErrorDialog(
  //         context, "Error", 'Could not launch $url');
  //   }
  // }

  // _launchURL(BuildContext context, String link) async {
  //   var url = Uri.parse(link);

  //   if (await canLaunchUrl(url)) {
  //     await launchUrl(url);
  //   } else {
  //     throw 'Could not launch $link';
  //   }
  // }

  //TextEditingController
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Video Conferencing"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Link:',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: link,
                decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade400)),
                  fillColor: Colors.grey.shade200,
                  filled: true,
                  enabled: false,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            PredefinedWidgets.getTextField(
                phoneNumber, "Enter phone numbers", false),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'After each number add " "(Space)    ',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            PredefinedWidgets.myButton(context, () {
              link.text = setLinkText();
              //print(link.text);
            }, "Generate Link"),
            const SizedBox(
              height: 10,
            ),
            PredefinedWidgets.myButton(context, () {
              sendText();
            }, "Send via text"),
            const SizedBox(
              height: 10,
            ),
            PredefinedWidgets.myButton(context, () async {
              final Uri _url = Uri.parse(link.text);
              await launchUrl(_url, mode: LaunchMode.externalApplication);
              // final Uri url = Uri.parse(link.text);
              // if (!await launchUrl(url)) {
              //   throw Exception('Could not launch $url');
              // }
            }, "Open link"),
          ],
        ),
      ),
    );
  }
}
