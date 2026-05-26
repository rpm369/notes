import 'package:notes/Databases/Constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SystemDB {
  static SharedPreferences? db;

  static Future<SystemDB> initializeDB() async {
    db ??= await SharedPreferences.getInstance();
    return SystemDB();
  }

  static Future<bool> isFirstExecution() async {
    if (db == null) await initializeDB();
    bool isFirstTime = await db!.getBool(Constants.FIRST_TIME.value) ?? true;

    if (isFirstTime) {
      await db!.setBool(Constants.FIRST_TIME.value, false);
      await db!.setBool(Constants.IS_THEME_DARK.value, true);
    }

    return isFirstTime;
  }

  static Future<bool> isThemeDark() async {
    if (db == null) await initializeDB();
    return db!.getBool(Constants.IS_THEME_DARK.value)!;
  }
}
