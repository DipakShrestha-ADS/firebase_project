import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesServices {
  static const customThemeIsDarkMode = 'CUSTOM_THEME_IS_DARK_MODE';
  static const userPreferencesConstant = 'USER_PREF_MATRIMONIAL';
  static const noOfProfileViewedPreference = 'NO_OF_PROFILE_VIEWED';

  final SharedPreferences prefs;
  SharedPreferencesServices(this.prefs);

  Future<bool> clearAllPrefs() async {
    return await prefs.clear();
  }

  Future<bool> clearUserPreferences() async {
    return await prefs.remove(userPreferencesConstant);
  }
}
