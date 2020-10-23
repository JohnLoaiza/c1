import 'package:shared_preferences/shared_preferences.dart';

class MyPreferences{
  static const  AUTOMATIC = "automatic";
  static const  USER = "user";
  static const  EMAIL = "email";
  static const  PASSWORD = "password";
  static const  NUMBER = "number";
  static const  LOCATION1 = "location1";
  static const  LOCATION2 = "location2";
  static const  ID = "id";
  static const  FECHA = "fecha";
  static final MyPreferences instance = MyPreferences._internal();


  //Campos a manejar
  SharedPreferences _sharedPreferences;
  String password = "";
  String name = "";
  String email = "";
  String number = "";
  String location1 = "";
  String location2 = "";
  String id = "";
  String fecha = "";

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
      location1 = _sharedPreferences.getString(LOCATION1);
      location2 = _sharedPreferences.getString(LOCATION2);
      id = _sharedPreferences.getString(ID);
      fecha = _sharedPreferences.getString(FECHA);

      return _sharedPreferences;

    }

  }
  Future<bool> commit() async {
    await _sharedPreferences.setString(PASSWORD, password);
    await _sharedPreferences.setString(USER, name);
    await _sharedPreferences.setString(EMAIL, email);
    await _sharedPreferences.setString(NUMBER, number);
    await _sharedPreferences.setString(LOCATION1, location1);
    await _sharedPreferences.setString(LOCATION2, location2);
    await _sharedPreferences.setString(ID, id);
    await _sharedPreferences.setString(FECHA, fecha);
  }

  Future<MyPreferences> init() async{
    _sharedPreferences = await preferences;
    return this;
  }


}