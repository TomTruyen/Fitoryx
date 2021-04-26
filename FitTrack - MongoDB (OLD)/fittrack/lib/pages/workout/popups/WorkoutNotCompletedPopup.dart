import 'package:fittrack/misc/Functions.dart';
import 'package:flutter/material.dart';

Future<void> workoutNotCompletedPopup(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
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
                    Container(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'You are not done',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'You haven\'t finished every set in your workout.',
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.all(8.0),
                      child: TextButton(
                        child: Text(
                          'OK',
                          style: TextStyle(
                            fontSize: 13.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {
                          popContextWhenPossible(context);
                        },
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
}
