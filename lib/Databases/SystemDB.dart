import 'package:flutter/material.dart';
import 'package:notes/Databases/Constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SystemDB extends ChangeNotifier {
  static SharedPreferences? db;

  static Future<SystemDB> initializeDB() async {
    if (db == null) {
      db = await SharedPreferences.getInstance();
      await _configureIfFirstTime();
    }

    return SystemDB();
  }

  static Future<void> _configureIfFirstTime() async {
    bool? isFirstTime = db!.getBool(Constants.FIRST_TIME.value);
    if (isFirstTime == null) {
      await db!.setBool(Constants.FIRST_TIME.value, false);
      await db!.setBool(Constants.IS_THEME_DARK.value, true);
    }
  }

  bool isThemeDark() {
    return db!.getBool(Constants.IS_THEME_DARK.value)!;
  }

  Future<void> alterTheme() async {
    if (db == null) await initializeDB();
    await db!.setBool(Constants.IS_THEME_DARK.value, !isThemeDark());
    notifyListeners();
  }
}
