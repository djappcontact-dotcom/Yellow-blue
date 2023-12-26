import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  ///DartMode
  bool _darkMode = false;
  bool get darkMode => _darkMode;
  void setDarkMode(bool tkn) {
    _darkMode = tkn;
    Future.delayed(Duration.zero, () {
      notifyListeners();
    });
  }

  ///CUID
  String? _cuid;
  String? get cuid => _cuid;
  void setCUID(String tkn) {
    _cuid = tkn;
    Future.delayed(Duration.zero, () {
      notifyListeners();
    });
  }

  String? _osid;
  String? get osid => _osid;
  void setOSID(String tkn) {
    _osid = tkn;
    Future.delayed(Duration.zero, () {
      notifyListeners();
    });
  }

  ///ID
  String? _id;
  String? get id => _id;
  void setID(String tkn) {
    _id = tkn;
    Future.delayed(Duration.zero, () {
      notifyListeners();
    });
  }
}

class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}
