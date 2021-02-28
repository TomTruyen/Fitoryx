import 'package:fittrack/shared/Functions.dart';
import 'package:flutter/material.dart';

Future<void> showPopupToggleGraphs(
  BuildContext context,
  Function updateSettings,
) async {
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
                          child: ListView(
                            children: <Widget>[
                              CheckboxListTile(
                                activeColor: Colors.blue[700],
                                contentPadding: EdgeInsets.zero,
                                title: Text(
                                  'Workouts per week',
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
                                value: true,
                                onChanged: (bool value) {
                                  // toggle values
                                },
                              ),
                              CheckboxListTile(
                                contentPadding: EdgeInsets.zero,
                                activeColor: Colors.blue[700],
                                title: Text(
                                  'Weight',
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
                                value: true,
                                onChanged: (bool value) {
                                  // toggle values
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.blue[700],
                                contentPadding: EdgeInsets.zero,
                                title: Text(
                                  'Total weight lifted',
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
                                value: true,
                                onChanged: (bool value) {
                                  // toggle values
                                },
                              ),
                            ],
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
                                // update settings + setstate voor upate profiles,
                                // updateSettings(newSettings);
                                tryPopContext(context);
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
