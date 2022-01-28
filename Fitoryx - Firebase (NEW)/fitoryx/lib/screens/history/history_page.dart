import 'package:fitoryx/models/exercise.dart';
import 'package:fitoryx/models/workout_history.dart';
import 'package:fitoryx/screens/history/history_calendar_page.dart';
import 'package:fitoryx/services/firestore_service.dart';
import 'package:fitoryx/widgets/alert.dart';
import 'package:fitoryx/widgets/exercise_row.dart';
import 'package:fitoryx/widgets/list_divider.dart';
import 'package:fitoryx/widgets/loader.dart';
import 'package:fitoryx/widgets/sort_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  bool _loading = true;

  final FirestoreService _firestoreService = FirestoreService();

  List<WorkoutHistory> _history = [];
  bool _ascending = true;

  String _divider = "";

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: <Widget>[
          SliverAppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.grey[50],
            floating: true,
            pinned: true,
            title: const Text(
              'History',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
            actions: <Widget>[
              IconButton(
                icon: const Icon(
                  Icons.calendar_today_outlined,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      fullscreenDialog: true,
                      builder: (context) => HistoryCalendarPage(
                        history: _history,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          if (_history.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Container(
                  child: _loading
                      ? const Loader()
                      : const Text('No workouts performed.'),
                ),
              ),
            ),
          if (_history.isNotEmpty)
            SliverToBoxAdapter(
              child: Container(
                alignment: Alignment.centerRight,
                margin: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 4.0,
                ),
                child: SortButton(
                  isAscending: _ascending,
                  text: 'Sort by date',
                  onPressed: _sortHistory,
                ),
              ),
            ),
          if (_history.isNotEmpty)
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  WorkoutHistory history = _history[index];

                  bool addDivider = false;
                  String newDivider = DateFormat("MMMM yyyy").format(
                    history.date,
                  );

                  if (newDivider != _divider) {
                    addDivider = true;
                    _divider = newDivider;
                  }

                  return Column(
                    children: <Widget>[
                      if (addDivider)
                        ListDivider(
                          text: _divider,
                          style: const TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12.0,
                          vertical: 4.0,
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(8.0),
                          onTap: () {
                            // Navigate to history detail page (pass history obj as param)
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Flexible(
                                    child: Container(
                                      padding: const EdgeInsets.all(16),
                                      child: Text(
                                        history.workout.name,
                                        style: TextStyle(
                                          color: Colors.blue[700],
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              _buildExerciseRows(history.workout.exercises),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                  vertical: 4.0,
                                ),
                                child: Text(
                                  history.workout.exercises.length > 3
                                      ? 'More...'
                                      : '',
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.caption,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
                childCount: _history.length,
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _init() async {
    try {
      _history = await _firestoreService.getWorkoutHistory();
      _sortHistory(noToggle: true);
    } catch (e) {
      showAlert(context, content: "Failed to load workout history");
    }

    setState(() {
      _loading = false;
    });
  }

  void _sortHistory({noToggle = false}) {
    if (!noToggle) {
      _ascending = !_ascending;
    }

    _history.sort(
      (a, b) => a.date.compareTo(b.date),
    );

    if (!_ascending) {
      _history = _history.reversed.toList();
    }

    setState(() {
      _divider = "";
      _history = _history;
    });
  }

  Column _buildExerciseRows(List<Exercise> exercises) {
    List<ExerciseRow> rows = [];

    for (int i = 0; i < 3; i++) {
      ExerciseRow row = const ExerciseRow();

      if (exercises.length > i) {
        row = ExerciseRow(
          sets: exercises[i].sets.length.toString(),
          name: exercises[i].name,
          equipment: exercises[i].equipment,
        );
      }

      rows.add(row);
    }

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: rows);
  }
}
