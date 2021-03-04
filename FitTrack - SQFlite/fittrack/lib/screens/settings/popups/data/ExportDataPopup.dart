// Flutter Packages
import 'dart:io';
import 'dart:math';

import 'package:fittrack/functions/Functions.dart';
import 'package:flutter/material.dart';

// My Packages
import 'package:fittrack/shared/Globals.dart' as globals;
import 'package:permission_handler/permission_handler.dart';

Future<void> showPopupExportData(
  BuildContext context,
  String fileName,
  Function updateSettings,
) async {
  bool isExporting = false;
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
                    child: isExporting
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
                                Text('Exporting...'),
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
                                    child: Container(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        'Failed to export data',
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
                                          errorMessage,
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
                            : isCompleted
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                            'Successfully exported data',
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
                                              'Data has been successfully exported. You can find the file in your Downloads.',
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
                                            'Export data',
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
                                              'This will export your data to \'$fileName\' in your Downloads. Are you sure you want to export your data?',
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
                                                      isExporting = true;
                                                    });

                                                    Random rand = new Random();

                                                    int millisSeconds =
                                                        rand.nextInt(2500) +
                                                            1500;

                                                    try {
                                                      String devicePath =
                                                          await getDevicePath();

                                                      File file = await getFile(
                                                          devicePath, fileName);

                                                      dynamic result =
                                                          await globals
                                                              .sqlDatabase
                                                              .exportDatabase();

                                                      if (result != null) {
                                                        dynamic writeResult =
                                                            await writeToFile(
                                                                file,
                                                                result
                                                                    .toString());

                                                        if (writeResult !=
                                                            null) {
                                                          Future.delayed(
                                                            Duration(
                                                                milliseconds:
                                                                    millisSeconds),
                                                            () {
                                                              setState(() {
                                                                isCompleted =
                                                                    true;
                                                                isExporting =
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
                                                                isFailed = true;
                                                                isExporting =
                                                                    false;
                                                                isCompleted =
                                                                    false;

                                                                errorMessage =
                                                                    "Failed to write file. Please try again.";
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
                                                              isExporting =
                                                                  false;
                                                              isCompleted =
                                                                  false;

                                                              errorMessage =
                                                                  "Failed to export database. Please try again.";
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
                                                            isExporting = false;
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
