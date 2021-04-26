import 'dart:math';
import 'package:fitness_app/misc/Functions.dart';
import 'package:fitness_app/models/history/WorkoutHistory.dart';
import 'package:fitness_app/models/settings/Settings.dart';
import 'package:fitness_app/models/workout/WorkoutExercise.dart';
import 'package:fitness_app/pages/history/HistoryCalendarPage.dart';
import 'package:fitness_app/pages/history/HistoryViewPage.dart';
import 'package:fitness_app/shared/Loading.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  bool loading = true;

  int lastMonth;
  int lastYear;

  // Fix error: setState() called after dispose()
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<WorkoutHistory> history =
        Provider.of<List<WorkoutHistory>>(context) ?? null;
    UserSettings settings = Provider.of<UserSettings>(context) ?? null;

    if (settings == null) {
      settings = UserSettings();
    }

    if (history != null && loading) {
      Future.delayed(
        Duration(seconds: 1),
        () => {
          setState(() {
            loading = false;
          }),
        },
      );
    }

    return loading
        ? Loading()
        : ScrollConfiguration(
            behavior: ScrollBehavior(),
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 120.0,
                  floating: false,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    titlePadding: EdgeInsets.all(8.0),
                    title: Text('History'),
                  ),
                  actions: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.event),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                HistoryCalendarPage(history: history),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                history.length > 0
                    ? SliverList(
                        delegate: (SliverChildBuilderDelegate(
                          (context, index) {
                            int count = 0;
                            bool dateDivider = false;

                            if (lastMonth != null && lastYear != null) {
                              int currentMonth =
                                  history[index].workoutTime.month;
                              int currentYear = history[index].workoutTime.year;
                              if (currentMonth != lastMonth ||
                                  currentYear != lastYear) {
                                dateDivider = true;
                                lastMonth = currentMonth;
                                lastYear = currentYear;
                              }
                            } else {
                              dateDivider = true;
                              lastMonth = history[index].workoutTime.month;
                              lastYear = history[index].workoutTime.year;
                            }

                            if (dateDivider) {
                              // Get count of exercises from this month
                              for (int i = 0; i < history.length; i++) {
                                if (history[i].workoutTime.month ==
                                        history[index].workoutTime.month &&
                                    history[i].workoutTime.year ==
                                        history[index].workoutTime.year) {
                                  count++;
                                }
                              }
                            }

                            return WorkoutHistoryTile(
                              workoutHistory: history[index],
                              weightUnit: settings.weightUnit,
                              dateDivider: dateDivider,
                              workoutCount: count,
                              settings: settings,
                            );
                          },
                          childCount: history.length,
                        )),
                      )
                    : SliverToBoxAdapter(
                        child: Container(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'No workouts performed. \nPress the \'+\' icon to start a workout',
                          ),
                        ),
                      ),
              ],
            ),
          );
  }
}

class WorkoutHistoryTile extends StatelessWidget {
  final WorkoutHistory workoutHistory;
  final String weightUnit;
  final bool dateDivider;
  final int workoutCount;
  final UserSettings settings;

  WorkoutHistoryTile({
    this.workoutHistory,
    this.weightUnit = 'metric',
    this.dateDivider = false,
    this.workoutCount = 0,
    @required this.settings,
  });

  @override
  Widget build(BuildContext context) {
    final String weightUnitValue = weightUnit == 'metric' ? 'kg' : 'lbs';

    return Column(
      children: <Widget>[
        if (dateDivider)
          Container(
            padding: EdgeInsets.fromLTRB(12.0, 16.0, 12.0, 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  child: Text(
                    DateFormat("MMMM yyyy")
                        .format(workoutHistory.workoutTime)
                        .toUpperCase(),
                    style: Theme.of(context).textTheme.caption,
                  ),
                ),
                Text(
                  '$workoutCount workouts',
                  style: Theme.of(context).textTheme.caption,
                ),
              ],
            ),
          ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6.0),
            border: Border.all(
              color: Colors.grey[400],
              width: 1,
            ),
          ),
          margin: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => HistoryViewPage(
                    history: workoutHistory,
                  ),
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.all(12.0),
              child: Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      workoutHistory.name,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyText2.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      DateFormat("d MMMM").format(workoutHistory.workoutTime),
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.watch_later, size: 16.0),
                              SizedBox(width: 5.0),
                              Text(
                                workoutHistory.workoutDuration,
                                style: Theme.of(context).textTheme.caption,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 30.0),
                        Container(
                          child: Row(
                            children: <Widget>[
                              Transform.rotate(
                                angle: -pi / 4,
                                child: Icon(
                                  Icons.fitness_center,
                                  size: 16.0,
                                ),
                              ),
                              SizedBox(width: 5.0),
                              Text(
                                _getTotalWeightLifted(
                                      workoutHistory.exercises,
                                      workoutHistory.weightUnit,
                                      settings.weightUnit,
                                    ) +
                                    weightUnitValue,
                                style: Theme.of(context).textTheme.caption,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 8.0),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Exercise',
                      style: Theme.of(context).textTheme.bodyText2.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                  for (int i = 0; i < workoutHistory.exercises.length; i++)
                    Row(
                      children: <Widget>[
                        Text(workoutHistory.exercises[i].sets.length.toString(),
                            style: Theme.of(context).textTheme.caption),
                        SizedBox(width: 5.0),
                        Text('x', style: Theme.of(context).textTheme.caption),
                        SizedBox(width: 5.0),
                        Text(workoutHistory.exercises[i].name,
                            style: Theme.of(context).textTheme.caption),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

String _getTotalWeightLifted(
  List<WorkoutExercise> exercises,
  String workoutWeightUnit,
  String settingsWeightUnit,
) {
  double totalWeight = 0.0;

  for (int i = 0; i < exercises.length; i++) {
    for (int j = 0; j < exercises[i].sets.length; j++) {
      totalWeight += (exercises[i].sets[j].reps * exercises[i].sets[j].weight);
    }
  }

  if (settingsWeightUnit != workoutWeightUnit) {
    totalWeight = recalculateWeights(totalWeight, settingsWeightUnit);
  }

  final weightFormat = new NumberFormat('# ##0.00', 'en_US');

  return weightFormat.format(totalWeight);
}
