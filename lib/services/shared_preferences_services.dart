import 'dart:convert';

import 'package:firebase_project/services/encrypt_decrypt_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesServices {
  static const customThemeIsDarkMode = 'CUSTOM_THEME_IS_DARK_MODE';
  static const userPreferencesConstant = 'USER_PREF_DATA';
  static const noOfProfileViewedPreference = 'NO_OF_PROFILE_VIEWED';

  final SharedPreferences prefs;
  SharedPreferencesServices(this.prefs);

  Future<bool> clearAllPrefs() async {
    return await prefs.clear();
  }

  Future<bool> storeUserDetails({required String token, required String userId}) async {
    final dataMap = {"token": token, "uid": userId};
    final encodedData = jsonEncode(dataMap);
    final encryptedData = EncryptDecryptServices().encryptData(data: encodedData);
    return await prefs.setString(userPreferencesConstant, encryptedData);
  }

  Map<dynamic, dynamic> getUserDetails() {
    final userData = prefs.getString(userPreferencesConstant);
    final decryptedData = userData == null ? null : EncryptDecryptServices().decryptData(data: userData);
    final decodedData = decryptedData == null ? {} : jsonDecode(decryptedData);
    return decodedData;
  }

  Future<bool> clearUserPreferences() async {
    return await prefs.remove(userPreferencesConstant);
  }
}
