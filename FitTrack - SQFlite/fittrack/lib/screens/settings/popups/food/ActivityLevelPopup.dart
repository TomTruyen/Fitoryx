import 'package:fittrack/functions/Functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<int> showPopActivityLevel(
  BuildContext context,
) async {
  int activityLevel = 0;
  await showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.transparent,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Center(
              child: Container(
                width: 250.0,
                height: 325.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.grey[50],
                  border: Border.all(
                    width: 0,
                  ),
                ),
                padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 4.0),
                child: Theme(
                  data: Theme.of(context).copyWith(
                    dividerColor: Color.fromRGBO(70, 70, 70, 1),
                    unselectedWidgetColor: Color.fromRGBO(
                      200,
                      200,
                      200,
                      1,
                    ),
                  ),
                  child: Material(
                    color: Colors.grey[50],
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Container(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Activity Level',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: SingleChildScrollView(
                            child: Column(
                              children: <Widget>[
                                InkWell(
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          flex: 1,
                                          child: Radio(
                                            activeColor: Colors.blue[700],
                                            groupValue: activityLevel,
                                            value: 0,
                                            onChanged: (int value) {
                                              setState(() {
                                                activityLevel = value;
                                              });
                                            },
                                          ),
                                        ),
                                        Expanded(
                                          flex: 4,
                                          child: Text(
                                            'No Exercise',
                                            style: TextStyle(
                                              fontSize: 16.0,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      activityLevel = 0;
                                    });
                                  },
                                ),
                                InkWell(
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          flex: 1,
                                          child: Radio(
                                            activeColor: Colors.blue[700],
                                            groupValue: activityLevel,
                                            value: 1,
                                            onChanged: (int value) {
                                              setState(() {
                                                activityLevel = value;
                                              });
                                            },
                                          ),
                                        ),
                                        Expanded(
                                          flex: 4,
                                          child: Text(
                                            '1-3x Per Week',
                                            style: TextStyle(
                                              fontSize: 16.0,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      activityLevel = 1;
                                    });
                                  },
                                ),
                                InkWell(
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          flex: 1,
                                          child: Radio(
                                            activeColor: Colors.blue[700],
                                            groupValue: activityLevel,
                                            value: 2,
                                            onChanged: (int value) {
                                              setState(() {
                                                activityLevel = value;
                                              });
                                            },
                                          ),
                                        ),
                                        Expanded(
                                          flex: 4,
                                          child: Text(
                                            '3-5x Per Week',
                                            style: TextStyle(
                                              fontSize: 16.0,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      activityLevel = 2;
                                    });
                                  },
                                ),
                                InkWell(
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          flex: 1,
                                          child: Radio(
                                            activeColor: Colors.blue[700],
                                            groupValue: activityLevel,
                                            value: 3,
                                            onChanged: (int value) {
                                              setState(() {
                                                activityLevel = value;
                                              });
                                            },
                                          ),
                                        ),
                                        Expanded(
                                          flex: 4,
                                          child: Text(
                                            '6-7x Per Week',
                                            style: TextStyle(
                                              fontSize: 16.0,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      activityLevel = 3;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              TextButton(
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onPressed: () async {
                                  activityLevel = -1;
                                  tryPopContext(context);
                                },
                              ),
                              TextButton(
                                child: Text(
                                  'OK',
                                  style: TextStyle(
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onPressed: () async {
                                  tryPopContext(context);
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );
    },
  );

  return activityLevel;
}
