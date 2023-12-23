import 'package:flutter/material.dart';

class CustomTextStyle {
  static const TextStyle heading1 = TextStyle(
    fontSize: 24,
    color: Colors.black,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle heading2 = TextStyle(
    fontSize: 18,
    color: Colors.black,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle simpleText1 = TextStyle(
    fontSize: 16,
    color: Colors.black,
  );
  static const TextStyle PanicButton =
      TextStyle(fontSize: 55, color: Colors.white, fontWeight: FontWeight.w800);
  static const TextStyle buttonText =
      TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w800);
  static const darkModetextStyle = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );
  static const whiteModetextStyle = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
  );
  static  BoxDecoration whiteModeBox = BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
  );
  static  BoxDecoration darkModeBox = BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(10.0),
  );
  static  BoxDecoration darkModeBox2 = BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(10.0),
  );
}
