import 'package:fitness_app/pages/profile/charts/WeightChart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:fitness_app/services/Database.dart';
import 'package:fitness_app/misc/Functions.dart';

import 'package:fitness_app/models/user/User.dart';
import 'package:fitness_app/models/settings/Settings.dart';

class WeightHistoryGraphWidget extends StatelessWidget {
  final User user;
  final UserSettings settings;

  WeightHistoryGraphWidget({
    @required this.user,
    @required this.settings,
  });

  @override
  Widget build(BuildContext context) {
    Future<void> showWeightGoalDialog(bool isAdd) async {
      double goal = settings.weightGoal.goal;

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
                            height: 70.0,
                            child: TextFormField(
                              onChanged: (String value) {
                                goal = double.parse(value);
                              },
                              keyboardType: TextInputType.number,
                              initialValue: goal.toString(),
                              decoration: InputDecoration(
                                suffixText: settings.weightUnit == 'metric'
                                    ? 'KG'
                                    : 'LBS',
                                hintText: '0',
                                fillColor: Colors.grey[300],
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8.0),
                                  ),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8.0),
                                  ),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: EdgeInsets.all(16.0),
                              ),
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
                                settings.weightGoal.isEnabled = true;
                                settings.weightGoal.goal = goal;
                                settings.weightGoal.weightUnit =
                                    settings.weightUnit;

                                dynamic result =
                                    await DatabaseService(uid: user.uid)
                                        .updateSettings(settings);

                                if (result != null) {
                                  popContextWhenPossible(context);
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
                        settings.weightUnit == 'metric'
                            ? 'Weight (kg)'
                            : 'Weight (lbs)',
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
                              showWeightGoalDialog(
                                  selection == 'add' ? true : false);
                            } else if (selection == 'remove') {
                              settings.weightGoal.isEnabled = false;

                              await DatabaseService(uid: user.uid)
                                  .updateSettings(settings);
                            }
                          },
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry>[
                            if (settings.weightGoal.isEnabled)
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
                              value: settings.weightGoal.isEnabled
                                  ? 'remove'
                                  : 'add',
                              child: Text(
                                settings.weightGoal.isEnabled
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
                  child: WeightChart(
                    seriesList: convertWeightToChartSeries(
                      Theme.of(context).accentColor,
                      settings,
                    ),
                    settings: settings,
                    weightHistoryCount: settings.weightHistory.length,
                  )),
            ],
          ),
        ),
        if (settings.weightHistory.length <= 0)
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
                  child: Text("No weight history found"),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
