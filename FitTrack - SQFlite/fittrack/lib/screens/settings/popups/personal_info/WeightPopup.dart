// Flutter Packages
import 'package:fittrack/shared/ErrorPopup.dart';
import 'package:fittrack/functions/Functions.dart';
import 'package:flutter/material.dart';

import 'package:fittrack/models/settings/Settings.dart';
import 'package:fittrack/shared/Globals.dart' as globals;

Future<void> showPopupWeight(
  BuildContext context,
  Settings settings,
  Function updateSettings,
) async {
  double weight = settings.userWeight[0].weight ?? 0.0;
  String weightUnit = settings.weightUnit ?? "kg";

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
                height: 250.0,
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
                              'Weight',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: SingleChildScrollView(
                            child: Container(
                              margin: EdgeInsets.all(8.0),
                              child: TextFormField(
                                initialValue: weight != null
                                    ? tryConvertDoubleToInt(weight).toString()
                                    : '0',
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: true),
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(12.0),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  fillColor: Colors.grey[300],
                                  filled: true,
                                  hintText: '0.0',
                                  hintStyle: TextStyle(color: Colors.black54),
                                  suffixText: weightUnit.toUpperCase(),
                                ),
                                onChanged: (String value) {
                                  weight = double.parse(value);
                                },
                              ),
                            ),
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
                                Settings newSettings = settings.clone();
                                newSettings.tryAddUserWeight(
                                    weight, weightUnit);

                                dynamic result = await globals.sqlDatabase
                                    .updateSettings(newSettings);

                                if (result != null) {
                                  updateSettings(newSettings);
                                  await globals.sqlDatabase
                                      .fetchUpdatedWeights();
                                  tryPopContext(context);
                                } else {
                                  tryPopContext(context);

                                  showPopupError(
                                    context,
                                    'Failed to update',
                                    'Something went wrong updating your weight. Please try again.',
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
