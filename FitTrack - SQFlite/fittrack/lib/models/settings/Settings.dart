class Settings {
  int id;
  String weightUnit;

  // Food Goals
  int kcalGoal;
  int carbsGoal;
  int proteinGoal;
  int fatGoal;

  // Rest Timer
  int defaultRestTime;
  int isRestTimerEnabled;
  int isVibrateUponFinishEnabled;

  Settings({
    this.id,
    this.weightUnit = 'kg',
    this.kcalGoal,
    this.carbsGoal,
    this.proteinGoal,
    this.fatGoal,
    this.defaultRestTime = 30,
    this.isRestTimerEnabled = 1,
    this.isVibrateUponFinishEnabled = 1,
  });

  Settings clone() {
    return new Settings(
      id: id,
      weightUnit: weightUnit ?? 'kg',
      kcalGoal: kcalGoal,
      carbsGoal: carbsGoal,
      proteinGoal: proteinGoal,
      fatGoal: fatGoal,
      defaultRestTime: defaultRestTime ?? 30,
      isRestTimerEnabled: isRestTimerEnabled ?? 1,
      isVibrateUponFinishEnabled: isVibrateUponFinishEnabled ?? 1,
    );
  }

  static Settings fromJSON(Map<String, dynamic> settings) {
    return new Settings(
      id: settings['id'],
      weightUnit: settings['weightUnit'] ?? 'kg',
      kcalGoal: settings['kcalGoal'],
      carbsGoal: settings['carbsGoal'],
      proteinGoal: settings['proteinGoal'],
      fatGoal: settings['fatGoal'],
      defaultRestTime: settings['defaultRestTime'] ?? 30,
      isRestTimerEnabled: settings['isRestTimerEnabled'] ?? 1,
      isVibrateUponFinishEnabled: settings['isVibrateUponFinishEnabled'] ?? 1,
    );
  }
}
