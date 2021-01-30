class Settings {
  int id;
  String weightUnit;

  // Food Goals
  int kcalGoal;
  int carbsGoal;
  int proteinGoal;
  int fatGoal;

  Settings({
    this.id,
    this.weightUnit = 'kg',
    this.kcalGoal,
    this.carbsGoal,
    this.proteinGoal,
    this.fatGoal,
  });

  Settings clone() {
    return new Settings(
      id: id,
      weightUnit: weightUnit,
      kcalGoal: kcalGoal,
      carbsGoal: carbsGoal,
      proteinGoal: proteinGoal,
      fatGoal: fatGoal,
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
    );
  }
}
