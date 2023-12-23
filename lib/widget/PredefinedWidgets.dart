import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';

import '../pages/CalenderPage.dart';

class PredefinedWidgets {
  static Widget getTextField(
      final controller, String hinttext, bool obscuretext) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextField(
        controller: controller,
        obscureText: obscuretext,
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400)),
          fillColor: Colors.grey.shade200,
          filled: true,
          hintText: hinttext,
        ),
      ),
    );
  }

  static getTimeTextField(BuildContext context, final controller) {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          readOnly: true,
          controller: controller,
          decoration: const InputDecoration(hintText: 'Pick your Time'),
          onTap: () async {
            var time = await showTimePicker(
                context: context, initialTime: TimeOfDay.now());

            if (time != null) {
              controller.text = time.format(context);
            }
          },
        ));
  }

  static Widget getNumberTextField(
      final controller, String hinttext, bool obscuretext) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextField(
        controller: controller,
        obscureText: obscuretext,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400)),
          fillColor: Colors.grey.shade200,
          filled: true,
          hintText: hinttext,
        ),
      ),
    );
  }

  static SizedBox myButton(BuildContext context, func, String text) {
    return SizedBox(
      width: 150,
      height: 50,
      child: ElevatedButton(
          onPressed: () => func(),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black, // Background color
          ),
          child: Text(
            text,
            style: const TextStyle(color: Colors.white),
          )),
    );
  }

  static Future<void> showMyDialog(
      parentContext, String errorTitle, String errorMessage) {
    return showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  errorTitle,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  errorMessage,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Future<void> showMyErrorDialog(
      parentContext, String errorTitle, String errorMessage) {
    return showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: const Color.fromARGB(255, 141, 11, 11),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 50.0,
                ),
                Text(
                  errorTitle,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  errorMessage,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Future<void> showMySuccessDialog(
      parentContext, String errorTitle, String errorMessage) {
    return showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: const Color.fromARGB(255, 45, 135, 252),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.star,
                  color: Colors.white,
                  size: 70.0,
                ),
                Text(
                  errorTitle,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  errorMessage,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  //-----------------------------------------------------------------TextToSpeech function
  static FlutterTts speaker = FlutterTts();
  static void textToSpeech(String title, String desc) async {
    await speaker.setLanguage('en-US');
    await speaker.setVolume(1);
    await speaker.setSpeechRate(0.5);
    await speaker.setPitch(1);
    await speaker.speak(title);
    await Future.delayed(const Duration(seconds: 2));
    if (desc.isNotEmpty) {
      await speaker.speak(desc);
    }
  }

  static showDialogForUserGuide(parentContext, String title, String desc) {
    //debugPrint("hello");

    return showDialog(
        context: parentContext,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    desc,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20.0),
                  IconButton(
                    icon: const Icon(
                      Icons.volume_up,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      // Perform action on button press
                      textToSpeech(title, desc);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  static showDialogForitems(
      parentContext, String title, String desc, String time) {
    //debugPrint("hello");

    return showDialog(
        context: parentContext,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Reminder time: $time",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    desc,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20.0),
                  IconButton(
                    icon: const Icon(
                      Icons.volume_up,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      // Perform action on button press
                      textToSpeech(title, desc);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  static showDialogForUncompleteditems(
      parentContext, String title, String desc, String time, String date) {
    debugPrint("hello");

    return showDialog(
        context: parentContext,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text("Due date: $date",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      )),
                  Text(
                    "Reminder time: $time",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    desc,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20.0),
                  IconButton(
                    icon: const Icon(
                      Icons.volume_up,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      // Perform action on button press
                      textToSpeech(title, desc);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  static getSnackBarWidget(String title, String message) {
    return Get.snackbar(
      title, // Title of the snackbar
      message, // Message to be displayed
      snackPosition: SnackPosition.BOTTOM, // Position of the snackbar
      duration: const Duration(
          seconds: 3), // Duration for which the snackbar is visible
      backgroundColor: Colors.grey[900], // Background color of the snackbar
      colorText: Colors.white, // Text color of the snackbar
    );
  }
}
