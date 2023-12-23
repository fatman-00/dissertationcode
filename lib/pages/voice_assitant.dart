import 'dart:io';

import 'package:elderly_people/utils/EmergencyContact.dart';
import 'package:elderly_people/utils/SwitchingRelay.dart';
import 'package:elderly_people/widget/PredefinedWidgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:picovoice_flutter/picovoice_error.dart';
import 'package:picovoice_flutter/picovoice_manager.dart';
import 'package:rhino_flutter/rhino.dart';
import '../utils/WeatherApi.dart';
import '../theme/Theme.dart';

class voice_assistant extends StatefulWidget {
  const voice_assistant({super.key});

  @override
  State<voice_assistant> createState() => _voice_assistantState();
}

class _voice_assistantState extends State<voice_assistant> {
  List<String> msg = [];
  final String accessKey =
      "q234JWMq2rQcpq9zTvmzcQ51uIHyquYr1UBZgksHozhN+Uz22Pc//Q=="; // AccessKey obtained from Picovoice Console (https://console.picovoice.ai/)
  bool _listeningForCommand = false;
  late PicovoiceManager _picovoiceManager;
  late String uID;
  @override
  void dispose() {
    // Your function to be executed when the page is closed
    _picovoiceManager.stop();
    super.dispose();
  }

  void _initPicovoice() async {
    //print("working");
    String platform = Platform.isAndroid ? "android" : "ios";

    String keywordPath = "lib/asset/hey-john_en_android_v2_2_0.ppn";
    //String contextPath = "lib/asset/Elderly_people2_en_android_v2_2_0.rhn";
    String contextPath = "lib/asset/Elderly_people_en_android_v3.rhn";

    try {
      _picovoiceManager = await PicovoiceManager.create(accessKey, keywordPath,
          _wakeWordCallback, contextPath, _inferenceCallback);

      // start audio processing
      _picovoiceManager.start();
    } on PicovoiceException catch (ex) {
      print(ex);
    }
  }
  // void button(bool val){
  //   if(val==true){
  //     _listeningForCommand = false;

  //   }else if( val==false){
  //     setState(() {
  //     _listeningForCommand = false;
  //   });
  //   }
  // }
  void _wakeWordCallback() {
    setState(() {
      _listeningForCommand = true;
    });
    //print("wake word detected!");
  }

  @override
  void initState() {
    // TODO: implement initState
    _initPicovoice();
    uID = FirebaseAuth.instance.currentUser!.uid;
    super.initState();
  }

  Future<void> _inferenceCallback(RhinoInference inference) async {
    Map<String, String>? slots = inference.slots;
    if (inference.isUnderstood!) {
      // if (inference.intent == 'turningOnOrOffAppliances') {
      //   String? state= slots?["state1"];
      //   String? appliance = slots?["state2"];
        
      //   SwitchingRelay.checkRelayValue(appliance!, state as int, uID);
      // } 
      // else 
      if (inference.intent == 'turnOnRelay1') {
        msg.add("Turning on relay1");
        SwitchingRelay.writeRelay1(true, uID);
        //print("turn on relay 1");
      } else if (inference.intent == 'turnOnRelay2') {
        SwitchingRelay.writeRelay2(true, uID);

        msg.add("Turning on relay 2");

        //print("turn on relay2");
      } else if (inference.intent == 'turnOnRelay3') {
        msg.add("Turning on relay 3");
        SwitchingRelay.writeRelay3(true, uID);

        //print("turn on relay3");
      } else if (inference.intent == 'turnOnRelay4') {
        SwitchingRelay.writeRelay4(true, uID);

        msg.add("Turning on relay 4");

        //print("turn on relay4");
      } else if (inference.intent == 'turnOffRelay1') {
        msg.add("Turning off relay 1");
        SwitchingRelay.writeRelay1(false, uID);

        //print("turn off relay1");
      } else if (inference.intent == 'turnoffRelay2') {
        SwitchingRelay.writeRelay2(false, uID);

        msg.add("Turning off relay 2");

        //print("turn off relay2");
      } else if (inference.intent == 'turnOffRelay3') {
        msg.add("Turning off relay 3");
        SwitchingRelay.writeRelay3(false, uID);

        //print("turn off relay3");
      } else if (inference.intent == 'turnoffRelay4') {
        msg.add("Turning off relay4");
        SwitchingRelay.writeRelay4(false, uID);

        //print("turn off relay4");
      } else if (inference.intent == 'EmergencyContact') {
        msg.add("Contacting emergency contact immediately");
        PredefinedWidgets.textToSpeech("Contacting emergency contact immediately","");//text to speech
        EmergencyContact.sendMessageToContact(uID);
        //print("EmergencyContact");
      } else if (inference.intent == "currentTime") {
        DateTime now = DateTime.now();
        String formattedDate = DateFormat('yyyy-MM-dd').format(now);
        String formattedTime = DateFormat('HH:mm').format(now);
        msg.add("The current date and time is $formattedDate $formattedTime");//Getting current date/Time
        PredefinedWidgets.textToSpeech(
            "The current date and time is ", "$formattedDate $formattedTime");//text to speech
      } else if (inference.intent == "CurrentWeather") {
        String weather = await getWeather();
        msg.add(weather);//getting current weather condition
        PredefinedWidgets.textToSpeech("", weather);//text to speech
      }
      /* 
      else if (inference.intent == 'EmergencyContact') {
        msg.add("Contacting emergency contact immediately");
        EmergencyContact.sendMessageToContact(uID);//Contacting emegency contact
        //print("EmergencyContact");
      } else if (inference.intent == "currentTime") {
        DateTime now = DateTime.now();
        String formattedDate = DateFormat('yyyy-MM-dd').format(now);
        String formattedTime = DateFormat('HH:mm').format(now);
        msg.add("The current date and time is $formattedDate $formattedTime");//Getting current date/Time
        PredefinedWidgets.textToSpeech(
            "The current date and time is ", "$formattedDate $formattedTime");//text to speech
      } else if (inference.intent == "CurrentWeather") {
        String weather = await getWeather();
        msg.add(weather);//getting current weather condition
        PredefinedWidgets.textToSpeech("", weather);//text to speech
      } 
       */ 
      else {
        msg.add("Couldn't find command please try again");
      }
    } else {
      msg.add("Couldn't understand command please try again");
    }

    setState(() {
      _listeningForCommand = false;
    });
    //print(inference);
    //  print(inference.isUnderstood);
  }

  Future<String> getWeather() async {
    var weatherData = await WeatherModel.getLocationWeather();//recieve data in  terms of JSON
    return "Here are the conditions at ${weatherData['name']}:\n Condition:${weatherData['weather'][0]['main']}\n Temperature:${weatherData['main']['temp']}";
    //access JSON data in terms of am list
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("voice assistant"),
      ),
      body: SafeArea(
          child: Center(
        child: Column(
          children: <Widget>[
            Container(
                width: MediaQuery.of(context).size.width *
                    0.85, // Replace with your desired width
                height: MediaQuery.of(context).size.width * 1.5,
                decoration: CustomTextStyle
                    .darkModeBox, // Replace with your desired height
                child: Column(children: [
                  const Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Commands',
                      style: TextStyle(
                        color: Colors.white, // Title color
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(child: StreamBuilder(builder: (BuildContext context,
                      AsyncSnapshot<List<String>> snapshot) {
                    if (msg.isEmpty) {
                      return const Center(
                          child: Text(
                              "Say something like 'Switch on red light'",
                              style: TextStyle(color: Colors.white)));
                    } else {
                      return ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: msg.length,
                        itemBuilder: (BuildContext context, int index) {
                          final item = msg[index];
                          return ListTile(
                            title: Text(item,
                                style: const TextStyle(color: Colors.white)),
                          );
                        },
                      );
                    }
                    ;
                  }))
                ])),
            Container(
                child: _listeningForCommand
                    ? const Icon(Icons.mic, size: 100, color: Colors.blue)
                    : const Icon(Icons.mic_none, size: 100, color: Colors.red)),
            Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: Text("Say 'Hey John!'",
                    style: Theme.of(context).textTheme.bodyText1))
          ],
        ),
      )),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Respond to button press
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Commands Example'),
                content: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Command 1: Turn on/off relay1'),
                    Text('Command 2: Turn on/off red light'),
                    Text('Command 3: Say "I\'m in danger"'),
                    Text('Command 4: Give me the current weather stats'),
                    Text('Command 5: Give me the current time and date'),
                    Text(""),
                    Text('A variation of these command can be used'),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Close'),
                  ),
                ],
              );
            },
          );
          //PredefinedWidgets.showMyDialog(context, "Commands",
          //    "Example of command that can be used:\n To Turn on\\off appliances:\n1. Turn on\\off red light \n   Turn on\\off relay 2\n   Switch on\\off red light\n To Contact emergency contact \n  say 'I'm in danger'");
        },
        icon: const Icon(Icons.help),
        label: const Text('Help'),
      ),
    );
  }
}
