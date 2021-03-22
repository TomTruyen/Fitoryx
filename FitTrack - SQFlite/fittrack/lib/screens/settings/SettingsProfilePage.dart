import 'package:fittrack/functions/Functions.dart';
import 'package:fittrack/models/settings/Settings.dart';
import 'package:fittrack/screens/settings/popups/dateofbirth/DateOfBirthPopup.dart';
import 'package:fittrack/shared/ErrorPopup.dart';
import 'package:fittrack/shared/Globals.dart' as globals;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SettingsProfilePage extends StatefulWidget {
  final Function updateSettings;
  final Settings settings;

  SettingsProfilePage({this.updateSettings, this.settings});

  @override
  _SettingsProfilePageState createState() => _SettingsProfilePageState();
}

class _SettingsProfilePageState extends State<SettingsProfilePage> {
  double weight;
  String weightUnit;

  double height;
  String heightUnit;

  double bodyFat;

  String gender;
  DateTime dateOfBirth;

  @override
  void initState() {
    super.initState();

    setState(() {
      weight = widget.settings?.userWeight[0]?.weight ?? 0.0;
      weightUnit = widget.settings?.weightUnit ?? "kg";
      height = widget.settings?.height ?? 0.0;
      heightUnit = widget.settings?.heightUnit ?? 'cm';
      bodyFat = widget.settings.bodyFat[0].percentage ?? 0.0;
      gender = widget.settings?.gender ?? "male";
      dateOfBirth = widget.settings?.dateOfBirth;
    });
  }

  void updateDateOfBirth(DateTime dob) {
    setState(() {
      dateOfBirth = dob;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Colors.grey[50],
            floating: true,
            pinned: true,
            title: Text(
              'Edit profile',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
            leading: IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.black,
              ),
              onPressed: () {
                tryPopContext(context);
              },
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.check,
                  color: Colors.black,
                ),
                onPressed: () async {
                  Settings newSettings = widget.settings.clone();
                  newSettings.height = height;
                  newSettings.dateOfBirth = dateOfBirth;
                  newSettings.gender = gender;

                  bool isInsertUserWeight = newSettings.tryAddUserWeight(
                    weight,
                    weightUnit,
                  );

                  bool isInsertBodyFat = newSettings.tryAddBodyFat(
                    bodyFat,
                  );

                  dynamic userWeightInputResult = await globals.sqlDatabase
                      .updateUserWeight(
                          newSettings.userWeight[0], isInsertUserWeight);

                  dynamic bodyFatInputResult = await globals.sqlDatabase
                      .updateBodyFat(newSettings.bodyFat[0], isInsertBodyFat);

                  if (userWeightInputResult != null &&
                      bodyFatInputResult != null) {
                    await globals.sqlDatabase.updateSettings(newSettings);
                    await widget.updateSettings(newSettings);
                    tryPopContext(context);
                  } else {
                    showPopupError(
                      context,
                      'Failed to update',
                      'Something went wrong updating your profile. Please try again.',
                    );
                  }
                },
              ),
            ],
          ),
          SliverFillRemaining(
            child: Container(
              margin: EdgeInsets.all(4.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.only(left: 12.0),
                      child: Text(
                        'Personal Info',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  if (heightUnit?.toLowerCase() == 'ft')
                    Container(
                      margin: EdgeInsets.only(left: 12.0),
                      child: Text(
                        'Height in feet should be inputted as 5.11 instead of 5\'11',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 12.0,
                        ),
                      ),
                    ),
                  SizedBox(height: 12.0),
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 12.0),
                      child: Row(
                        children: <Widget>[
                          Flexible(
                            child: TextFormField(
                              initialValue:
                                  tryConvertDoubleToInt(weight ?? 0).toString(),
                              keyboardType: TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(4),
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'(^\d*\.?\d{0,2})'),
                                )
                              ],
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(12.0),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                fillColor: Colors.grey[300],
                                filled: true,
                                hintText: '0',
                                hintStyle: TextStyle(color: Colors.black54),
                                suffixText: weightUnit.toUpperCase(),
                              ),
                              onChanged: (String value) {
                                if (value == "") value = "0";

                                weight = double.parse(value);
                              },
                            ),
                          ),
                          SizedBox(width: 12.0),
                          Flexible(
                            child: TextFormField(
                              initialValue:
                                  tryConvertDoubleToInt(height ?? 0).toString(),
                              keyboardType: TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(
                                  heightUnit == 'cm' ? 3 : 4,
                                ),
                                heightUnit == 'cm'
                                    ? FilteringTextInputFormatter.digitsOnly
                                    : FilteringTextInputFormatter.allow(
                                        RegExp(r'(^\d*\.?\d{0,2})'),
                                      )
                              ],
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(12.0),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                fillColor: Colors.grey[300],
                                filled: true,
                                hintText: '0',
                                hintStyle: TextStyle(color: Colors.black54),
                                suffixText: heightUnit.toUpperCase(),
                              ),
                              onChanged: (String value) {
                                if (value == "") value = "0";

                                height = double.parse(value);
                              },
                            ),
                          ),
                          SizedBox(width: 12.0),
                          Flexible(
                            child: TextFormField(
                              initialValue: tryConvertDoubleToInt(bodyFat ?? 0)
                                  .toString(),
                              keyboardType: TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(4),
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'(^\d*\.?\d{0,2})'),
                                )
                              ],
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(12.0),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                fillColor: Colors.grey[300],
                                filled: true,
                                hintText: '0',
                                hintStyle: TextStyle(color: Colors.black54),
                                suffixText: "%",
                              ),
                              onChanged: (String value) {
                                if (value == "") value = "0";

                                bodyFat = double.parse(value);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 24.0),
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.only(left: 12.0),
                      child: Text(
                        'Date of Birth',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.only(left: 12.0),
                    title: Text(
                      dateOfBirth != null
                          ? convertDateTimeToString(dateOfBirth)
                          : "No date of birth set",
                    ),
                    onTap: () async {
                      clearFocus(context);

                      await showPopupDateOfBirth(
                        context,
                        updateDateOfBirth,
                        widget.settings,
                      );
                    },
                  ),
                  SizedBox(height: 24.0),
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.only(left: 12.0),
                      child: Text(
                        'Gender',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                      child: RadioListTile(
                    activeColor: Colors.blue[700],
                    selected: gender == 'male',
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    title: Text(
                      'Male',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    groupValue: gender,
                    value: 'male',
                    onChanged: (String value) {
                      clearFocus(context);

                      setState(() {
                        gender = value;
                      });
                    },
                  )),
                  Flexible(
                      child: RadioListTile(
                    activeColor: Colors.blue[700],
                    selected: gender == 'female',
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    title: Text(
                      'Female',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    groupValue: gender,
                    value: 'female',
                    onChanged: (String value) {
                      clearFocus(context);

                      setState(() {
                        gender = value;
                      });
                    },
                  )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
