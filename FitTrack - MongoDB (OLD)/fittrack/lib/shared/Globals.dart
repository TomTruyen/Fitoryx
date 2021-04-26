import 'package:fittrack/model/Appdata.dart';
import 'package:fittrack/model/exercise/Exercise.dart';
import 'package:fittrack/model/exercise/ExerciseCategory.dart';
import 'package:fittrack/model/exercise/ExerciseEquipment.dart';
import 'package:fittrack/model/exercise/ExerciseFilter.dart';
import 'package:fittrack/model/exercise/ExerciseType.dart';
import 'package:fittrack/model/food/Nutrition.dart';
import 'package:fittrack/model/history/WorkoutHistory.dart';
import 'package:fittrack/model/settings/Settings.dart';
import 'package:fittrack/model/workout/Workout.dart';

// User
String uid = "";
String email = "";
String name = "";

// AppData
Appdata appdata;

// Settings
Settings settings;

// WorkoutHistory
List<WorkoutHistory> workoutHistory;

// Workouts
List<Workout> workouts;

// Exercises
ExerciseFilter exerciseFilter;

List<Exercise> exercises;
List<ExerciseCategory> categories;
List<ExerciseEquipment> equipment;

List<Exercise> selectedExercises = [];
List<ExerciseCategory> selectedCategories = [];
List<ExerciseEquipment> selectedEquipment = [];
List<ExerciseType> selectedTypes = [];

// Nutrition
List<Nutrition> nutritionHistory;

// Set Back To Default
void setDefault() {
  // User
  uid = "";

  // AppData
  appdata = null;

  // Settings
  settings = null;

  // WorkoutHistory
  workoutHistory = null;

  // Workouts
  workouts = null;

  // Exercises
  exerciseFilter = null;
  exercises = null;
  categories = null;
  equipment = null;
  selectedExercises = [];
  selectedCategories = [];
  selectedEquipment = [];
  selectedTypes = [];

  // Nutrition
  nutritionHistory = null;
}
