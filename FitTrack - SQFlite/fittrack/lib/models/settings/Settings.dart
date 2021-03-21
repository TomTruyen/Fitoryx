import 'package:fittrack/functions/Functions.dart';
import 'package:fittrack/models/settings/BodyFat.dart';
import 'package:fittrack/models/settings/GraphToShow.dart';
import 'package:fittrack/models/settings/UserWeight.dart';

class Settings {
  int id;

  // Personal Info
  List<UserWeight> userWeight;
  List<BodyFat> bodyFat;

  double height;

  // Units
  String heightUnit;
  String weightUnit;

  DateTime dateOfBirth;
  String gender;

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
    this.bodyFat,
    this.height = 0,
    this.heightUnit = 'cm',
    this.weightUnit = 'kg',
    this.dateOfBirth,
    this.gender = "male",
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

    if (this.bodyFat == null || this.bodyFat.isEmpty) {
      this.bodyFat = [
        BodyFat(
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
      bodyFat: bodyFat ?? [],
      height: height,
      heightUnit: heightUnit ?? 'cm',
      weightUnit: weightUnit ?? 'kg',
      dateOfBirth: dateOfBirth,
      gender: gender ?? "male",
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
    List<BodyFat> _bodyFatList = getBodyFatListFromJson(settings);
    List<GraphToShow> _graphsToShowList = getGraphsToShowListFromJson(settings);

    DateTime dob;

    if (settings['dateOfBirth'] != null) {
      dob = DateTime.fromMillisecondsSinceEpoch(settings['dateOfBirth']);
    }

    return new Settings(
      id: settings['id'],
      userWeight: _userWeightList ??
          [
            UserWeight(
              weightUnit: settings['weightUnit'] ?? 'kg',
              timeInMillisSinceEpoch: DateTime.now().millisecondsSinceEpoch,
            )
          ],
      bodyFat: _bodyFatList ??
          [
            BodyFat(
              timeInMillisSinceEpoch: DateTime.now().millisecondsSinceEpoch,
            ),
          ],
      height: settings['height'] ?? 0,
      heightUnit: settings['heightUnit'] ?? 'cm',
      weightUnit: settings['weightUnit'] ?? 'kg',
      dateOfBirth: dob,
      gender: settings['gender'] ?? 'male',
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

  bool tryAddBodyFat(double percentage) {
    bool isInsert = true;

    DateTime date = DateTime.now();

    DateTime lastBodyFatInputDate = DateTime.fromMillisecondsSinceEpoch(
      bodyFat[0].timeInMillisSinceEpoch,
    );

    if (isSameDay(date, lastBodyFatInputDate) ||
        bodyFat[0].timeInMillisSinceEpoch == 0) {
      bodyFat[0] = new BodyFat(
        id: bodyFat[0].id,
        percentage: percentage,
        timeInMillisSinceEpoch: date.millisecondsSinceEpoch,
      );

      isInsert = false;
    } else {
      bodyFat.insert(
        0,
        new BodyFat(
          percentage: percentage,
          timeInMillisSinceEpoch: date.millisecondsSinceEpoch,
        ),
      );
    }

    return isInsert;
  }

  bool tryAddUserWeight(double _weight, String _weightUnit) {
    bool isInsert = true;

    DateTime date = DateTime.now();

    DateTime lastWeightInputDate = DateTime.fromMillisecondsSinceEpoch(
      userWeight[0].timeInMillisSinceEpoch,
    );

    if (isSameDay(date, lastWeightInputDate) ||
        userWeight[0].timeInMillisSinceEpoch == 0) {
      userWeight[0] = new UserWeight(
        id: userWeight[0].id,
        weight: _weight,
        weightUnit: _weightUnit,
        timeInMillisSinceEpoch: date.millisecondsSinceEpoch,
      );

      isInsert = false;
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

    return isInsert;
  }

  void updateUserHeight(String _heightUnit) {
    height = recalculateHeight(height, _heightUnit);
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
