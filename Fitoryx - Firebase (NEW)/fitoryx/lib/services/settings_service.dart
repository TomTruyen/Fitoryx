import 'package:fitoryx/models/graph_type.dart';
import 'package:fitoryx/models/settings.dart';
import 'package:fitoryx/models/unit_type.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  // Singleton Setup
  static final SettingsService _settingsService = SettingsService._internal();

  factory SettingsService() {
    return _settingsService;
  }

  SettingsService._internal();

  final String weightUnitKey = 'weightUnit';
  final String kcalKey = 'kcal';
  final String carbsKey = 'carbs';
  final String proteinKey = 'protein';
  final String fatKey = 'fat';
  final String restKey = 'rest';
  final String restEnabledKey = 'restEnabled';
  final String vibrateEnabledKey = 'vibrateEnabled';
  final String graphsKey = "graphs";

  Future<SharedPreferences> _getPrefs() async {
    return await SharedPreferences.getInstance();
  }

  Future<void> setWeightUnit(UnitType weightUnit) async {
    var prefs = await _getPrefs();

    await prefs.setString(weightUnitKey, UnitTypeHelper.toValue(weightUnit));
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

  Future<void> setGraphs(List<GraphType> graphs) async {
    List<String> graphList =
        graphs.map((graph) => GraphTypeHelper.toValue(graph)).toList();

    var prefs = await _getPrefs();

    await prefs.setStringList(graphsKey, graphList);
  }

  Future<Settings> getSettings() async {
    var prefs = await _getPrefs();

    var settings = Settings(
      weightUnit: UnitTypeHelper.fromValue(prefs.getString(weightUnitKey)),
      kcal: prefs.getInt(kcalKey),
      carbs: prefs.getInt(carbsKey),
      protein: prefs.getInt(proteinKey),
      fat: prefs.getInt(fatKey),
      rest: prefs.getInt(restKey) ?? 60,
      restEnabled: prefs.getBool(restEnabledKey) ?? true,
      vibrateEnabled: prefs.getBool(vibrateEnabledKey) ?? true,
    );

    settings.graphs = prefs
            .getStringList(graphsKey)
            ?.map((graph) => GraphTypeHelper.fromValue(graph))
            .toList() ??
        [];

    return settings;
  }
}
