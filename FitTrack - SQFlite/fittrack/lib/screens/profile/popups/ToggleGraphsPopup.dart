import 'package:fittrack/models/settings/Settings.dart';
import 'package:fittrack/shared/ErrorPopup.dart';
import 'package:fittrack/functions/Functions.dart';
import 'package:flutter/material.dart';

import 'package:fittrack/shared/Globals.dart' as globals;

Future<void> showPopupToggleGraphs(
  BuildContext context,
  Settings settings,
  Function updateSettings,
) async {
  Settings newSettings = settings.clone();

  String _getFormattedTitle(String title) {
    switch (title) {
      case 'workoutsPerWeek':
        return 'Workouts per week';
      case 'userWeight':
        return 'Weight';
      case 'totalVolume':
        return 'Total volume';
      default:
        return '';
    }
  }

  await showDialog(
    context: context,
    barrierDismissible: true,
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
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Container(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Toggle Graphs',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: ListView.builder(
                            itemBuilder: (BuildContext context, int index) {
                              return CheckboxListTile(
                                activeColor: Colors.blue[700],
                                contentPadding: EdgeInsets.zero,
                                title: Text(
                                  _getFormattedTitle(
                                      newSettings.graphsToShow[index].title),
                                  style: TextStyle(
                                    fontSize: Theme.of(context)
                                            .textTheme
                                            .bodyText2
                                            .fontSize *
                                        0.9,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                dense: true,
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                value: newSettings.graphsToShow[index].show,
                                onChanged: (bool value) {
                                  setState(() {
                                    newSettings.graphsToShow[index].show =
                                        value;
                                  });
                                },
                              );
                            },
                            itemCount: newSettings.graphsToShow.length,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.centerRight,
                            child: FlatButton(
                              color: Colors.transparent,
                              child: Text(
                                'OK',
                                style: TextStyle(
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onPressed: () async {
                                dynamic result = await globals.sqlDatabase
                                    .updateSettings(newSettings);

                                if (result != null) {
                                  updateSettings(newSettings);
                                  tryPopContext(context);
                                } else {
                                  showPopupError(
                                    context,
                                    'Failed to update',
                                    'Failed to update graph visibility',
                                  );
                                }
                              },
                            ),
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
}
