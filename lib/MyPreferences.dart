import 'package:shared_preferences/shared_preferences.dart';

class MyPreferences{
  static const  AUTOMATIC = "automatic";
  static const  USER = "user";
  static const  EMAIL = "email";
  static const  PASSWORD = "password";
  static const  NUMBER = "number";
  static final MyPreferences instance = MyPreferences._internal();


  //Campos a manejar
  SharedPreferences _sharedPreferences;
  String password = "";
  String name = "";
  String email = "";
  String number = "";

  MyPreferences._internal(){

  }

  factory MyPreferences()=>instance;

  Future<SharedPreferences> get preferences async{
    if(_sharedPreferences != null){
      return _sharedPreferences;
    }else{
      _sharedPreferences = await SharedPreferences.getInstance();
      name = _sharedPreferences.getString(PASSWORD);
      name = _sharedPreferences.getString(USER);
      email = _sharedPreferences.getString(EMAIL);
      number = _sharedPreferences.getString(NUMBER);

      return _sharedPreferences;

    }

  }
  Future<bool> commit() async {
    await _sharedPreferences.setString(PASSWORD, password);
    await _sharedPreferences.setString(USER, name);
    await _sharedPreferences.setString(EMAIL, email);
    await _sharedPreferences.setString(NUMBER, number);
  }

  Future<MyPreferences> init() async{
    _sharedPreferences = await preferences;
    return this;
  }


}