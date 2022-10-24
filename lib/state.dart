import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState extends ChangeNotifier {
  ///DartMode
  bool _darkMode = false;
  bool get darkMode => _darkMode;
  void setDarkMode(bool tkn) {
    _darkMode = tkn;

    notifyListeners();
  }


  ///CUID
  String _cuid;
  String get cuid => _cuid;
  void setCUID(String tkn) {
    _cuid = tkn;

    notifyListeners();
  }

  String _osid;
  String get osid => _osid;
  void setOSID(String tkn) {
    _osid = tkn;

    notifyListeners();
  }

  Future<int> checkCountOpen()async{
    final SharedPreferences pref = await SharedPreferences.getInstance();
    var _count = pref.getInt("count") ?? 1;

    return _count;
  }

  void setCountOpen()async{
    final SharedPreferences pref = await SharedPreferences.getInstance();
    var _count = pref.getInt("count") ?? 1;
    _count++;
    pref.setInt("count", _count);
  }

  void removeCountOpen()async{
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove("count");
  }

  ///ID
  String _id;
  String get id => _id;
  void setID(String tkn) {
    _id = tkn;

    notifyListeners();
  }

}
