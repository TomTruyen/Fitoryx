import 'package:fitness_app/misc/Functions.dart';
import 'package:fitness_app/models/settings/Settings.dart';
import 'package:fitness_app/models/user/User.dart';
import 'package:fitness_app/services/Database.dart';
import 'package:flutter/material.dart';

Future<void> showPopupWeight(
  User user,
  UserSettings settings,
  String currentWeight,
  BuildContext context,
) async {
  String weight = currentWeight;

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
            border: Border.all(
              width: 0,
            ),
          ),
          padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 4.0),
          child: SingleChildScrollView(
            child: Material(
              color: Colors.grey[50],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                      initialValue: currentWeight,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 32.0),
                        isDense: true,
                        suffixText:
                            settings.weightUnit == "metric" ? "KG" : "LBS",
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
                        String _date =
                            "${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}";

                        if (settings.weightHistory.length > 0 &&
                            settings.weightHistory[
                                        settings.weightHistory.length - 1]
                                    ['date'] ==
                                _date) {
                          settings.weightHistory[settings.weightHistory.length -
                              1]['weight'] = double.parse(weight);
                          settings.weightHistory[settings.weightHistory.length -
                              1]['weightUnit'] = settings.weightUnit;
                        } else {
                          settings.weightHistory.add({
                            'date': _date,
                            'weight': double.parse(weight),
                            'weightUnit': settings.weightUnit,
                          });
                        }

                        dynamic result = DatabaseService(uid: user.uid)
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
}
