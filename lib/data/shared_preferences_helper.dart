import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {

  Future<bool> isLoggedIn() async {
    SharedPreferences instance = await SharedPreferences.getInstance();
    return instance.getBool('logged_in');
  }
   Future<String> myUserID() async {
    SharedPreferences instance = await SharedPreferences.getInstance();
    return instance.getString('userID');
  }
  void setLoggedIn(bool state) async {
    SharedPreferences instance = await SharedPreferences.getInstance();
    instance.setBool('logged_in', state);
  }
  void setUserID(String state) async {
    SharedPreferences instance = await SharedPreferences.getInstance();
    instance.setString('userID', state);
  }
  void setNombre(String state) async {
    SharedPreferences instance = await SharedPreferences.getInstance();
    instance.setString('NameUser', state);
  }
  Future<String> myName() async {
    SharedPreferences instance = await SharedPreferences.getInstance();
    return instance.getString('NameUser');
  }
}

