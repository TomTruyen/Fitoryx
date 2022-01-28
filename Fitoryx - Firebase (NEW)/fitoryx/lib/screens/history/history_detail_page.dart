import 'package:fitoryx/models/popup_option.dart';
import 'package:fitoryx/models/workout_change_notifier.dart';
import 'package:fitoryx/models/workout_history.dart';
import 'package:fitoryx/services/firestore_service.dart';
import 'package:fitoryx/widgets/alert.dart';
import 'package:fitoryx/widgets/popup_menu.dart';
import 'package:fitoryx/widgets/workout_exercise_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HistoryDetailPage extends StatelessWidget {
  final WorkoutHistory history;
  final void Function(WorkoutHistory) deleteHistory;

  final List<PopupOption> _popupOptions = [
    PopupOption(text: 'Save as workout', value: 'save'),
    PopupOption(text: 'Delete', value: 'delete'),
  ];

  final FirestoreService _firestoreService = FirestoreService();

  HistoryDetailPage(
      {Key? key, required this.history, required this.deleteHistory})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final WorkoutChangeNotifier _workout =
        Provider.of<WorkoutChangeNotifier>(context);

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Colors.grey[50],
            floating: true,
            pinned: true,
            leading: IconButton(
              icon: const Icon(
                Icons.close,
                color: Colors.black,
              ),
              onPressed: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              },
            ),
            title: Text(
              history.workout.name,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
            actions: <Widget>[
              PopupMenu(
                isHeader: true,
                items: _popupOptions,
                onSelected: (selected) async {
                  switch (selected) {
                    case 'save':
                      // save the "workout" part to the workouts and dispaly message "workout saved"
                      try {
                        await _firestoreService.createWorkout(history.workout);

                        showAlert(
                          context,
                          title: "Info",
                          content: "Workout has been saved",
                        );
                      } catch (e) {
                        showAlert(context, content: "Failed to save workout");
                      }
                      break;
                    case 'delete':
                      deleteHistory(history);
                      break;
                    default:
                      break;
                  }
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    DateFormat('EEEE, d MMMM y, H:mm').format(history.date),
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontSize:
                          Theme.of(context).textTheme.bodyText2!.fontSize! *
                              1.2,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    "Duration: ${history.duration}",
                    style: const TextStyle(color: Colors.black),
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    "Total Volume: ${history.workout.getTotalVolume()} ${history.workout.unit}",
                    style: const TextStyle(color: Colors.black),
                  ),
                  const SizedBox(height: 10.0),
                  if (history.note != "")
                    Text(
                      "Note: ${history.note}",
                      style: const TextStyle(color: Colors.black),
                    ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                _workout.withWorkout(history.workout);

                return WorkoutExerciseCard(
                  exercise: history.workout.exercises[index],
                  index: index,
                  readonly: true,
                );
              },
              childCount: history.workout.exercises.length,
            ),
          ),
        ],
      ),
    );
  }
}
