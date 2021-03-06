import 'package:fittrack/models/settings/GraphToShow.dart';
import 'package:fittrack/models/settings/UserWeight.dart';
import 'package:fittrack/functions/Functions.dart';

class Settings {
  int id;

  // Personal Info
  List<UserWeight> userWeight;

  // Units
  String weightUnit;

  // Food Goals
  double kcalGoal;
  double carbsGoal;
  double proteinGoal;
  double fatGoal;

  // Rest Timer
  int defaultRestTime;
  int isRestTimerEnabled;
  int isVibrateUponFinishEnabled;

  // Profile Page
  List<GraphToShow> graphsToShow;
  int workoutsPerWeekGoal;

  // AutoExport
  int isAutoExportEnabled;

  Settings({
    this.id,
    this.userWeight,
    this.weightUnit = 'kg',
    this.kcalGoal,
    this.carbsGoal,
    this.proteinGoal,
    this.fatGoal,
    this.defaultRestTime = 60,
    this.isRestTimerEnabled = 1,
    this.isVibrateUponFinishEnabled = 1,
    this.graphsToShow,
    this.workoutsPerWeekGoal,
    this.isAutoExportEnabled = 0,
  }) {
    if (this.userWeight == null || this.userWeight.isEmpty) {
      this.userWeight = [
        UserWeight(
          weightUnit: this.weightUnit ?? 'kg',
          timeInMillisSinceEpoch: DateTime.now().millisecondsSinceEpoch,
        )
      ];
    }

    if (this.graphsToShow == null) {
      this.graphsToShow = GraphToShow.getDefaultGraphs();
    }
  }

  Settings clone() {
    return new Settings(
      id: id,
      userWeight: userWeight ?? [],
      weightUnit: weightUnit ?? 'kg',
      kcalGoal: kcalGoal,
      carbsGoal: carbsGoal,
      proteinGoal: proteinGoal,
      fatGoal: fatGoal,
      defaultRestTime: defaultRestTime ?? 60,
      isRestTimerEnabled: isRestTimerEnabled ?? 1,
      isVibrateUponFinishEnabled: isVibrateUponFinishEnabled ?? 1,
      graphsToShow: graphsToShow,
      workoutsPerWeekGoal: workoutsPerWeekGoal,
      isAutoExportEnabled: isAutoExportEnabled,
    );
  }

  static Settings fromJSON(Map<String, dynamic> settings) {
    List<UserWeight> _userWeightList = getUserWeightListFromJson(settings);
    List<GraphToShow> _graphsToShowList = getGraphsToShowListFromJson(settings);

    return new Settings(
      id: settings['id'],
      userWeight: _userWeightList ?? [UserWeight()],
      weightUnit: settings['weightUnit'] ?? 'kg',
      kcalGoal: settings['kcalGoal'],
      carbsGoal: settings['carbsGoal'],
      proteinGoal: settings['proteinGoal'],
      fatGoal: settings['fatGoal'],
      defaultRestTime: settings['defaultRestTime'] ?? 60,
      isRestTimerEnabled: settings['isRestTimerEnabled'] ?? 1,
      isVibrateUponFinishEnabled: settings['isVibrateUponFinishEnabled'] ?? 1,
      graphsToShow: _graphsToShowList ?? [],
      workoutsPerWeekGoal: settings['workoutsPerWeekGoal'],
      isAutoExportEnabled: settings['isAutoExportEnabled'] ?? 0,
    );
  }

  bool shouldShowGraph(String title) {
    for (int i = 0; i < graphsToShow.length; i++) {
      if (graphsToShow[i].title.toLowerCase() == title.toLowerCase()) {
        if (graphsToShow[i].show) {
          return true;
        }
      }
    }

    return false;
  }

  bool shouldShowNoGraphs() {
    for (int i = 0; i < graphsToShow.length; i++) {
      if (graphsToShow[i].show) {
        return false;
      }
    }

    return true;
  }

  void tryAddUserWeight(double _weight, String _weightUnit) {
    DateTime date = DateTime.now();

    DateTime lastWeightInputDate = DateTime.fromMillisecondsSinceEpoch(
      userWeight[0].timeInMillisSinceEpoch,
    );

    if (isSameDay(date, lastWeightInputDate) ||
        userWeight[0].timeInMillisSinceEpoch == 0) {
      userWeight[0] = new UserWeight(
        weight: _weight,
        weightUnit: _weightUnit,
        timeInMillisSinceEpoch: date.millisecondsSinceEpoch,
      );
    } else {
      userWeight.insert(
        0,
        new UserWeight(
          weight: _weight,
          weightUnit: _weightUnit,
          timeInMillisSinceEpoch: date.millisecondsSinceEpoch,
        ),
      );
    }
  }

  void updateUserWeights(String _weightUnit) {
    for (int i = 0; i < userWeight.length; i++) {
      if (userWeight[i].weightUnit != _weightUnit) {
        userWeight[i].weight = recalculateWeight(
          userWeight[i].weight,
          _weightUnit,
        );

        userWeight[i].weightUnit = _weightUnit;
      }
    }
  }
}
