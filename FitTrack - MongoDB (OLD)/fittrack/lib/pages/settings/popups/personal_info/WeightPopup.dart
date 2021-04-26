// Flutter Packages
import 'package:fittrack/misc/Functions.dart';
import 'package:flutter/material.dart';

// My Packages
import 'package:fittrack/shared/Globals.dart' as globals;

Future<void> showPopupWeight(
  BuildContext context,
  Function refreshSettings,
  Function updateProfileState,
  Function updateSettingsState,
) async {
  String weight = globals.settings.weightHistory.length > 0
      ? globals.settings
          .weightHistory[globals.settings.weightHistory.length - 1]['weight']
          .toString()
      : '0';

  await showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return Center(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: 250.0,
            maxHeight: MediaQuery.of(context).size.height * 0.80,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: Colors.grey[50],
            border: Border.all(width: 0.0),
          ),
          padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 4.0),
          child: SingleChildScrollView(
            child: Material(
              color: Colors.grey[50],
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Weight',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                  Container(
                    child: TextFormField(
                      textAlignVertical: TextAlignVertical.bottom,
                      style: TextStyle(
                        fontSize: 34.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[900],
                      ),
                      initialValue: weight,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 32.0),
                        isDense: true,
                        suffixText: globals.settings.weightUnit,
                        suffixStyle: TextStyle(
                          fontSize: 14.0,
                          color: Colors.grey[600],
                        ),
                      ),
                      onChanged: (String value) {
                        weight = value;
                      },
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
                        DateTime date = DateTime.now();
                        String _date = convertDateTimeToStringDate(date);

                        if (globals.settings.weightHistory.length > 0 &&
                            globals.settings.weightHistory[
                                    globals.settings.weightHistory.length -
                                        1]['date'] ==
                                _date) {
                          globals.settings.weightHistory[
                                  globals.settings.weightHistory.length - 1]
                              ['weight'] = double.parse(weight);
                          globals.settings.weightHistory[
                                  globals.settings.weightHistory.length - 1]
                              ['weightUnit'] = globals.settings.weightUnit;
                        } else {
                          globals.settings.weightHistory.add({
                            'date': _date,
                            'weight': double.parse(weight),
                            'weightUnit': globals.settings.weightUnit,
                          });
                        }

                        updateSettingsState();
                        popContextWhenPossible(context);
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
}
