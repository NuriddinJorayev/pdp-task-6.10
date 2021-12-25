

import 'package:shared_preferences/shared_preferences.dart';

class Prefs{

  // save method
  static Future<bool> Save(String id) async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("userId", id);
    return pref.getKeys().contains(id);
  }
  // load method
  static Future<String> Load() async{
    String? pref = (await SharedPreferences.getInstance()).getString("userId");
    return pref ?? "";
  }
  // delete method
  static Future<bool> Delete() async{     
    return (await SharedPreferences.getInstance()).remove("userId");
  }
}