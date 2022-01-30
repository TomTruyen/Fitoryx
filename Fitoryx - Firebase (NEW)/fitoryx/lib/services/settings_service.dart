import 'package:fitoryx/models/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  // Singleton Setup
  static final SettingsService _settingsService = SettingsService._internal();

  factory SettingsService() {
    return _settingsService;
  }

  SettingsService._internal();

  final String restKey = 'rest';
  final String restEnabledKey = 'restEnabled';
  final String vibrateEnabledKey = 'vibrateEnabled';

  Future<SharedPreferences> _getPrefs() async {
    return await SharedPreferences.getInstance();
  }

  Future<void> setRest(int value) async {
    var prefs = await _getPrefs();

    await prefs.setInt(restKey, value);
  }

  Future<void> setRestEnabled(bool value) async {
    var prefs = await _getPrefs();

    await prefs.setBool(restEnabledKey, value);
  }

  Future<void> setVibrateEnabled(bool value) async {
    var prefs = await _getPrefs();

    await prefs.setBool(vibrateEnabledKey, value);
  }

  Future<Settings> getSettings() async {
    var prefs = await _getPrefs();

    return Settings(
      rest: prefs.getInt(restKey) ?? 60,
      restEnabled: prefs.getBool(restEnabledKey) ?? true,
      vibrateEnabled: prefs.getBool(vibrateEnabledKey) ?? true,
    );
  }
}
