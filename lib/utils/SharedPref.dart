import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static late SharedPreferences _pref;

  static const _keyMorningTime = "8";
  
  static Future init() async {
    _pref = await SharedPreferences.getInstance();
  }

  static Future setMorningTime(String morningTime) async {
    await _pref.setString(_keyMorningTime, morningTime);
  }

  static String? getMorningTime() {
    return _pref.getString(_keyMorningTime);
  }
}
