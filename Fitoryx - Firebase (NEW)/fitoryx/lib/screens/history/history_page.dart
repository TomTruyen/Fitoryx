import 'package:fitoryx/models/exercise.dart';
import 'package:fitoryx/models/settings.dart';
import 'package:fitoryx/models/workout_history.dart';
import 'package:fitoryx/screens/history/history_calendar_page.dart';
import 'package:fitoryx/screens/history/history_detail_page.dart';
import 'package:fitoryx/services/firestore_service.dart';
import 'package:fitoryx/services/settings_service.dart';
import 'package:fitoryx/widgets/alert.dart';
import 'package:fitoryx/widgets/confirm_alert.dart';
import 'package:fitoryx/widgets/exercise_row.dart';
import 'package:fitoryx/widgets/list_divider.dart';
import 'package:fitoryx/widgets/loader.dart';
import 'package:fitoryx/widgets/sort_button.dart';
import 'package:fitoryx/widgets/subscription_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryPage extends StatefulWidget {
  final DateTime? day;

  const HistoryPage({Key? key, this.day}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  bool _loading = true;

  final FirestoreService _firestoreService = FirestoreService();
  final SettingsService _settingsService = SettingsService();
  Settings _settings = Settings();

  List<WorkoutHistory> _history = [];
  bool _ascending = false;

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
              leading: widget.day == null ? null : const CloseButton(),
              floating: true,
              pinned: true,
              title: Text(
                widget.day == null
                    ? 'History'
                    : "History of ${DateFormat("dd MMMM yyyy").format(widget.day!)}",
              ),
              actions: <Widget>[
                if (widget.day == null)
                  IconButton(
                    icon: const Icon(Icons.calendar_today_outlined),
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
                const SubscriptionIcon(),
              ]),
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
          if (_history.isNotEmpty && widget.day == null)
            SliverToBoxAdapter(
              child: Container(
                alignment: Alignment.centerRight,
                margin: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 4.0,
                ),
                child: SortButton(
                  isAscending: !_ascending,
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

                  if (widget.day == null) {
                    String newDivider = DateFormat("MMMM yyyy").format(
                      history.date,
                    );

                    if (newDivider != _divider) {
                      addDivider = true;
                      _divider = newDivider;
                    }
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
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                fullscreenDialog: true,
                                builder: (context) => HistoryDetailPage(
                                  history: history.workout.unit !=
                                          _settings.weightUnit
                                      ? history.clone(
                                          newUnit: _settings.weightUnit,
                                        )
                                      : history.clone(),
                                  deleteHistory: _deleteHistory,
                                ),
                              ),
                            );
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
                                          color: Theme.of(context).primaryColor,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              _buildExerciseRows(history.workout.exercises),
                              Container(
                                padding: const EdgeInsets.fromLTRB(
                                  16,
                                  4,
                                  16,
                                  16,
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

  void _init() async {
    try {
      if (widget.day != null) {
        _history = await _firestoreService.getHistoryByDay(widget.day!);
      } else {
        _history = await _firestoreService.getHistory();
      }

      _sortHistory(noToggle: true);
    } catch (e) {
      showAlert(context, content: "Failed to load workout history");
    }

    var settings = await _settingsService.getSettings();

    setState(() {
      _settings = settings;
      _loading = false;
    });
  }

  void _deleteHistory(WorkoutHistory history) {
    showConfirmAlert(
      context,
      content:
          "You will be deleting the history of ${history.workout.name}. This action can't be reversed!",
      onConfirm: () async {
        try {
          await _firestoreService.deleteHistory(history.id);

          _history.removeWhere((h) => h.id == history.id);

          _sortHistory(noToggle: true);

          if (Navigator.canPop(context)) {
            Navigator.pop(context);
            Navigator.pop(context);
          }
        } catch (e) {
          showAlert(
            context,
            content: "Failed to delete history",
          );
        }
      },
    );
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
