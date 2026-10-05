import 'package:flutter/material.dart';
import '../../core/constants/storage_key.dart';
import '../../core/services/preferences_manager.dart';


class HomeController with ChangeNotifier {
  String? userName;
  bool isCheck = false;
  String? motivationQuote;
  String? userImagePath;


  void init() {
    loadUserData();
  }

  void loadUserData() async {
    userImagePath = PreferencesManager().getString(StorageKey.userImagePath);
    userName = PreferencesManager().getString(StorageKey.username);
    motivationQuote = PreferencesManager().getString(
      StorageKey.motivationQuote,
    );
    notifyListeners();
  }


}
