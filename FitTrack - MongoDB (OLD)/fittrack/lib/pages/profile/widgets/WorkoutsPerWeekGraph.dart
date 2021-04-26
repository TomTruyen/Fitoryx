// Flutter Packages
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// My Packages
import 'package:fittrack/misc/Functions.dart';
import 'package:fittrack/pages/profile/charts/WorkoutsPerWeekGraph.dart';
import 'package:fittrack/services/Database.dart';
import 'package:fittrack/shared/Globals.dart' as globals;

class WorkoutsPerWeekGraph extends StatelessWidget {
  final Function updateState;
  final Function refreshSettings;

  WorkoutsPerWeekGraph({
    this.updateState,
    this.refreshSettings,
  });

  @override
  Widget build(BuildContext context) {
    Future<void> showWorkoutsPerWeekGoalDialog(bool isAdd) async {
      int goal = globals.settings.workoutPerWeekGoal.goal;

      await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, StateSetter setState) {
              return Center(
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width / 1.5,
                    maxHeight: MediaQuery.of(context).size.height * 0.80,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.grey[50],
                    border: Border.all(
                      width: 0,
                    ),
                  ),
                  padding: EdgeInsets.fromLTRB(16.0, 0.0, 8.0, 8.0),
                  child: SingleChildScrollView(
                    child: Material(
                      color: Colors.grey[50],
                      child: ListBody(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              isAdd ? 'Add goal' : 'Edit goal',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 16.0),
                            height: 100.0,
                            child: CupertinoPicker(
                              scrollController: FixedExtentScrollController(
                                initialItem:
                                    globals.settings.workoutPerWeekGoal.goal -
                                        1,
                              ),
                              squeeze: 1.0,
                              looping: true,
                              diameterRatio: 100.0,
                              itemExtent: 40.0,
                              onSelectedItemChanged: (int index) {
                                goal = index + 1;
                              },
                              useMagnifier: true,
                              magnification: 1.5,
                              children: <Widget>[
                                for (int i = 0; i < 7; i++)
                                  Center(
                                    child: Text(
                                      (i + 1).toString(),
                                      style: TextStyle(fontSize: 16.0),
                                    ),
                                  )
                              ],
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              child: Text(
                                'OK',
                                style: TextStyle(
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onPressed: () async {
                                globals.settings.workoutPerWeekGoal.isEnabled =
                                    true;
                                globals.settings.workoutPerWeekGoal.goal = goal;

                                updateState();
                                popContextWhenPossible(context);

                                dynamic isSaved =
                                    await Database(uid: globals.uid)
                                        .updateSettings(globals.settings);

                                if (isSaved) {
                                  await refreshSettings();
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      );
    }

    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(8.0),
          margin: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            border: Border.all(
              color: Colors.grey[400],
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text(
                        'Workouts per week',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16.0),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(bottom: 12.0),
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          cardColor: Color.fromRGBO(35, 35, 35, 1),
                          dividerColor: Color.fromRGBO(150, 150, 150, 1),
                        ),
                        child: PopupMenuButton(
                          offset: Offset(0, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                          ),
                          icon: Icon(
                            Icons.more_vert,
                          ),
                          onSelected: (selection) async {
                            if (selection == 'add' || selection == 'edit') {
                              showWorkoutsPerWeekGoalDialog(
                                  selection == 'add' ? true : false);
                            } else if (selection == 'remove') {
                              globals.settings.workoutPerWeekGoal.isEnabled =
                                  false;

                              updateState();
                              bool isSaved = await Database(uid: globals.uid)
                                  .updateSettings(globals.settings);

                              if (isSaved) {
                                await refreshSettings();
                              }
                            }
                          },
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry>[
                            if (globals.settings.workoutPerWeekGoal.isEnabled)
                              PopupMenuItem(
                                height: 40.0,
                                value: 'edit',
                                child: Text(
                                  'Edit goal',
                                  style: Theme.of(context)
                                      .textTheme
                                      .button
                                      .copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.normal,
                                      ),
                                ),
                              ),
                            PopupMenuItem(
                              height: 40.0,
                              value:
                                  globals.settings.workoutPerWeekGoal.isEnabled
                                      ? 'remove'
                                      : 'add',
                              child: Text(
                                globals.settings.workoutPerWeekGoal.isEnabled
                                    ? 'Remove goal'
                                    : 'Add goal',
                                style:
                                    Theme.of(context).textTheme.button.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.normal,
                                        ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.0),
              Expanded(
                flex: 5,
                child: WorkoutsPerWeekChart(
                  seriesList: convertWorkoutsToChartSeries(
                      globals.workoutHistory,
                      Theme.of(context).accentColor,
                      globals.settings),
                  settings: globals.settings,
                  workoutsCount: globals.workoutHistory.length,
                ),
              ),
            ],
          ),
        ),
        if (globals.workoutHistory.length <= 0)
          Positioned.fill(
            child: Opacity(
              opacity: 0.6,
              child: Container(
                padding: EdgeInsets.all(8.0),
                margin: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  border: Border.all(
                    color: Colors.grey[400],
                    width: 1,
                  ),
                  color: Colors.white,
                ),
                child: Center(
                  child: Text("No workouts performed"),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
