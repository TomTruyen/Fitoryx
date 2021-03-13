// Flutter Packages
import 'dart:io';
import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:fittrack/functions/Functions.dart';
// My Packages
import 'package:fittrack/shared/Globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> showPopupImportData(
  BuildContext context,
  Function updateSettings,
) async {
  bool isImporting = false;
  bool isCompleted = false;
  bool isFailed = false;
  String errorMessage = "";

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
                    child: isImporting
                        ? Container(
                            alignment: Alignment.center,
                            constraints: BoxConstraints(
                              minHeight: 200.0,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                CircularProgressIndicator(
                                  backgroundColor: Colors.grey[200],
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.grey[500]),
                                  strokeWidth: 2.0,
                                ),
                                SizedBox(height: 10.0),
                                Text('Importing...'),
                              ],
                            ),
                          )
                        : isFailed
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: SingleChildScrollView(
                                      child: Container(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                          'Failed to import data',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Container(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        errorMessage,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: <Widget>[
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
                                  ),
                                ],
                              )
                            : isCompleted
                                ? Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                            'Successfully imported data',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: SingleChildScrollView(
                                          child: Container(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                              'Data has been successfully imported.',
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: <Widget>[
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
                                      ),
                                    ],
                                  )
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                            'Import data',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: SingleChildScrollView(
                                          child: Container(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                              'Are you sure you want to import your data? \nNOTE: this will overwrite your current data.',
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: <Widget>[
                                              TextButton(
                                                child: Text(
                                                  'CANCEL',
                                                  style: TextStyle(
                                                    fontSize: 13.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                onPressed: () {
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
                                                  if (await Permission.storage
                                                      .request()
                                                      .isGranted) {
                                                    setState(() {
                                                      isImporting = true;
                                                    });

                                                    Random rand = new Random();

                                                    int millisSeconds =
                                                        rand.nextInt(2500) +
                                                            1500;

                                                    try {
                                                      FilePickerResult result =
                                                          await FilePicker
                                                              .platform
                                                              .pickFiles();

                                                      if (result != null) {
                                                        File file = File(result
                                                            .files.single.path);

                                                        dynamic readResult =
                                                            await readFromFile(
                                                                file);

                                                        if (readResult !=
                                                            null) {
                                                          dynamic dbResult =
                                                              await globals
                                                                  .sqlDatabase
                                                                  .importDatabase(
                                                                      readResult
                                                                          .toString());

                                                          if (dbResult !=
                                                              null) {
                                                            Future.delayed(
                                                              Duration(
                                                                  milliseconds:
                                                                      millisSeconds),
                                                              () {
                                                                updateSettings(
                                                                  globals
                                                                      .sqlDatabase
                                                                      .settings,
                                                                );

                                                                setState(() {
                                                                  isCompleted =
                                                                      true;
                                                                  isImporting =
                                                                      false;
                                                                  isFailed =
                                                                      false;

                                                                  errorMessage =
                                                                      "";
                                                                });
                                                              },
                                                            );
                                                          } else {
                                                            Future.delayed(
                                                              Duration(
                                                                  milliseconds:
                                                                      millisSeconds),
                                                              () {
                                                                setState(() {
                                                                  isFailed =
                                                                      true;
                                                                  isImporting =
                                                                      false;
                                                                  isCompleted =
                                                                      false;

                                                                  errorMessage =
                                                                      "Failed to import data. Please try again.";
                                                                });
                                                              },
                                                            );
                                                          }
                                                        } else {
                                                          Future.delayed(
                                                            Duration(
                                                                milliseconds:
                                                                    millisSeconds),
                                                            () {
                                                              setState(() {
                                                                isFailed = true;
                                                                isImporting =
                                                                    false;
                                                                isCompleted =
                                                                    false;

                                                                errorMessage =
                                                                    "Failed to read file. Please try again.";
                                                              });
                                                            },
                                                          );
                                                        }
                                                      } else {
                                                        Future.delayed(
                                                          Duration(
                                                              milliseconds:
                                                                  millisSeconds),
                                                          () {
                                                            setState(() {
                                                              isFailed = true;
                                                              isImporting =
                                                                  false;
                                                              isCompleted =
                                                                  false;

                                                              errorMessage =
                                                                  "No file selected. Please try again.";
                                                            });
                                                          },
                                                        );
                                                      }
                                                    } catch (e) {
                                                      Future.delayed(
                                                        Duration(
                                                            milliseconds:
                                                                millisSeconds),
                                                        () {
                                                          setState(() {
                                                            isFailed = true;
                                                            isImporting = false;
                                                            isCompleted = false;

                                                            errorMessage =
                                                                "Something went wrong. Please try again.";
                                                          });
                                                        },
                                                      );
                                                    }
                                                  }
                                                },
                                              ),
                                            ],
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
