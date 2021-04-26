// My Packages
import 'package:fittrack/model/Appdata.dart';
import 'package:fittrack/model/food/Nutrition.dart';
import 'package:fittrack/model/goals/NutritionGoal.dart';
import 'package:fittrack/model/goals/WeightGoal.dart';
import 'package:fittrack/model/goals/WorkoutPerWeekGoal.dart';
import 'package:fittrack/model/history/WorkoutHistory.dart';
import 'package:fittrack/model/settings/Settings.dart';
import 'package:fittrack/model/workout/Workout.dart';
import 'package:fittrack/model/exercise/Exercise.dart';
import 'package:fittrack/model/exercise/ExerciseCategory.dart';
import 'package:fittrack/model/exercise/ExerciseEquipment.dart';
import 'package:fittrack/model/workout/WorkoutExercise.dart';
import 'package:fittrack/model/workout/WorkoutExerciseSet.dart';

// AppData
Appdata convertToAppData(Map appdata) {
  return Appdata(version: appdata['version'] ?? '1.0.0');
}

// Settings
Settings convertToSettings(Map settings) {
  if (settings == null) {
    return Settings();
  }

  return Settings(
    timerIncrementValue: settings['timerIncrementValue'] ?? 30,
    weightUnit: settings['weightUnit'] ?? 'kg',
    heightUnit: settings['heightUnit'] ?? 'cm',
    isDeveloperModeEnabled: settings['isDeveloperModeEnabled'] ?? false,
    isRestTimerEnabled: settings['isRestTimerEnabled'] ?? true,
    isProgressiveOverloadEnabled:
        settings['isProgressiveOverloadEnabled'] ?? false,
    isVibrateUponFinishEnabled: settings['isVibrateUponFinishEnabled'] ?? true,
    weightHistory: settings['weightHistory'] ?? [],
    heightHistory: settings['heightHistory'] ?? [],
    nutritionGoal: _convertToNutritionGoal(
          settings['nutritionGoal'],
        ) ??
        NutritionGoal(),
    workoutPerWeekGoal: _convertToWorkoutPerWeekGoal(
          settings['workoutPerWeekGoal'],
        ) ??
        WorkoutPerWeekGoal(),
    weightGoal: _convertToWeightGoal(
          settings['weightGoal'],
        ) ??
        WeightGoal(),
  );
}

NutritionGoal _convertToNutritionGoal(Map nutritionGoal) {
  if (nutritionGoal == null) {
    return NutritionGoal();
  }

  return NutritionGoal(
    kcal: nutritionGoal['kcal'],
    carbs: nutritionGoal['carbs'],
    protein: nutritionGoal['protein'],
    fat: nutritionGoal['fat'],
    isEnabled: nutritionGoal['isEnabled'],
  );
}

WorkoutPerWeekGoal _convertToWorkoutPerWeekGoal(Map workoutPerWeekGoal) {
  if (workoutPerWeekGoal == null) {
    return WorkoutPerWeekGoal();
  }

  return WorkoutPerWeekGoal(
    goal: workoutPerWeekGoal['goal'],
    isEnabled: workoutPerWeekGoal['isEnabled'],
  );
}

WeightGoal _convertToWeightGoal(Map weightGoal) {
  if (weightGoal == null) {
    return WeightGoal();
  }

  return WeightGoal(
    goal: weightGoal['goal'],
    isEnabled: weightGoal['isEnabled'],
    weightUnit: weightGoal['weightUnit'],
  );
}

// WorkoutHistory
List<WorkoutHistory> convertToWorkoutHistory(List workoutHistory) {
  List<WorkoutHistory> _workoutHistory = [];

  if (workoutHistory != null) {
    workoutHistory.forEach((workout) {
      if (workout['workout_id'] != "" && workout['workout_id'] != null) {
        _workoutHistory.add(
          WorkoutHistory(
            id: workout['workout_id'] ?? '',
            name: workout['workoutName'] ?? '',
            weightUnit: workout['weightUnit'] ?? 'kg',
            workoutNote: workout['workoutNote'] ?? '',
            workoutTime: workout['time'] ?? DateTime.now(),
            workoutDuration: workout['workoutDuration'] ?? '00:00',
            exercises:
                _convertToWorkoutExerciseList(workout['exercises']) ?? [],
          ),
        );
      }
    });
  }

  _workoutHistory = List<WorkoutHistory>.from(_workoutHistory.reversed);

  return _workoutHistory;
}

// Workouts
List<Workout> convertToWorkoutList(List workouts) {
  List<Workout> _workouts = [];

  if (workouts != null) {
    workouts.forEach((workout) {
      if (workout['workout_id'] != "" && workout['workout_id'] != null) {
        _workouts.add(
          Workout(
            id: workout['workout_id'] ?? '',
            name: workout['workoutName'] ?? '',
            weightUnit: workout['weightUnit'] ?? 'kg',
            workoutNote: workout['workoutNote'] ?? '',
            exercises:
                _convertToWorkoutExerciseList(workout['exercises']) ?? [],
          ),
        );
      }
    });
  }

  return _workouts;
}

List<WorkoutExercise> _convertToWorkoutExerciseList(List exercises) {
  List<WorkoutExercise> _exercises = [];

  if (exercises != null) {
    exercises.forEach((exercise) {
      _exercises.add(
        WorkoutExercise(
          exerciseId: exercise['exercise_id'] ?? '',
          name: exercise['exerciseName'] ?? '',
          category: exercise['exerciseCategory'] ?? '',
          equipment: exercise['exerciseEquipment'] ?? '',
          isCompound: exercise['isCompound'] ?? false,
          sets: _convertToWorkoutExerciseSetList(exercise['sets']) ?? [],
          restEnabled: exercise['restEnabled'] ?? true,
          restSeconds: exercise['restSeconds'] ?? 60,
          hasNotes: exercise['hasNotes'] ?? false,
          notes: exercise['notes'] ?? '',
        ),
      );
    });
  }

  return _exercises;
}

List<WorkoutExerciseSet> _convertToWorkoutExerciseSetList(List sets) {
  List<WorkoutExerciseSet> _sets = [];

  if (sets != null) {
    sets.forEach((_set) {
      _sets.add(
        WorkoutExerciseSet(
          reps: _set['reps'] ?? 0,
          weight: _set['weight'] ?? 0,
        ),
      );
    });
  }

  return _sets;
}

// Exercises
List<Exercise> convertToExerciseList(
  List<Map<String, dynamic>> exercises,
) {
  List<Exercise> _exercises = [];

  if (exercises != null) {
    exercises.forEach((Map<String, dynamic> exercise) {
      if (exercise['name'] != "" && exercise['name'] != null) {
        _exercises.add(
          Exercise(
            id: exercise['exercise_id'] ?? '',
            name: exercise['name'] ?? '',
            category: exercise['category'] ?? '',
            equipment: exercise['equipment'] ?? '',
            isCompound: exercise['isCompound'] ?? false,
            isUserCreated: exercise['isUserCreated'] ?? false,
          ),
        );
      }
    });
  }

  return _exercises;
}

List<ExerciseCategory> convertToCategoryList(
  List<Map<String, dynamic>> categories,
) {
  List<ExerciseCategory> _categories = [];

  if (categories != null) {
    categories.forEach((Map<String, dynamic> category) {
      if (category['name'] != "") {
        _categories.add(
          ExerciseCategory(
            name: category['name'] ?? '',
          ),
        );
      }
    });
  }

  return _categories;
}

List<ExerciseEquipment> convertToEquipmentList(
  List<Map<String, dynamic>> equipment,
) {
  List<ExerciseEquipment> _equipment = [];

  if (equipment != null) {
    equipment.forEach((Map<String, dynamic> equipment) {
      if (equipment['name'] != "") {
        _equipment.add(
          ExerciseEquipment(
            name: equipment['name'] ?? '',
          ),
        );
      }
    });
  }

  return _equipment;
}

List<Nutrition> convertToNutritionHistory(
  List nutritionHistory,
) {
  List<Nutrition> _nutritionHistory = [];

  if (nutritionHistory != null) {
    nutritionHistory.forEach((nutrition) {
      _nutritionHistory.add(
        Nutrition(
          kcal: nutrition['kcal'],
          carbs: nutrition['carbs'],
          protein: nutrition['protein'],
          fat: nutrition['fat'],
          date: nutrition['date'],
        ),
      );
    });
  }

  return _nutritionHistory;
}
