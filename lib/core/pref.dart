import 'package:shared_preferences/shared_preferences.dart';

class BookPref {
  SharedPreferences? prefs;

  Future<void> setPosition(
      String path,
      double offset,
      ) async {
    prefs ??= await SharedPreferences.getInstance();
    await prefs?.setDouble(path, offset);
  }

  Future<double> getPosition(String path) async {
    prefs ??= await SharedPreferences.getInstance();
    return prefs?.getDouble(path) ?? 0;
  }
}