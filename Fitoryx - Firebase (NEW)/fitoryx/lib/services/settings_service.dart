import 'package:fitoryx/models/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  // Singleton Setup
  static final SettingsService _settingsService = SettingsService._internal();

  factory SettingsService() {
    return _settingsService;
  }

  SettingsService._internal();

  final String kcalKey = 'kcal';
  final String carbsKey = 'carbs';
  final String proteinKey = 'protein';
  final String fatKey = 'fat';
  final String restKey = 'rest';
  final String restEnabledKey = 'restEnabled';
  final String vibrateEnabledKey = 'vibrateEnabled';

  Future<SharedPreferences> _getPrefs() async {
    return await SharedPreferences.getInstance();
  }

  Future<void> setKcal(int? kcal) async {
    if (kcal == null) return;
    var prefs = await _getPrefs();

    await prefs.setInt(kcalKey, kcal);
  }

  Future<void> setCarbs(int? carbs) async {
    if (carbs == null) return;
    var prefs = await _getPrefs();

    await prefs.setInt(carbsKey, carbs);
  }

  Future<void> setProtein(int? protein) async {
    if (protein == null) return;
    var prefs = await _getPrefs();

    await prefs.setInt(proteinKey, protein);
  }

  Future<void> setFat(int? fat) async {
    if (fat == null) return;
    var prefs = await _getPrefs();

    await prefs.setInt(fatKey, fat);
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
      kcal: prefs.getInt(kcalKey),
      carbs: prefs.getInt(carbsKey),
      protein: prefs.getInt(proteinKey),
      fat: prefs.getInt(fatKey),
      rest: prefs.getInt(restKey) ?? 60,
      restEnabled: prefs.getBool(restEnabledKey) ?? true,
      vibrateEnabled: prefs.getBool(vibrateEnabledKey) ?? true,
    );
  }
}
