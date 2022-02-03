import 'package:fitoryx/models/unit_type.dart';
import 'package:flutter/material.dart';

Future<UnitType> showUnitDialog(
  BuildContext context,
  UnitType? unit,
) async {
  bool shouldUpdate = false;
  UnitType newUnit = unit ?? UnitType.metric;

  await showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, StateSetter setState) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Container(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.width * 0.2,
                maxHeight: MediaQuery.of(context).size.width * 0.6,
              ),
              width: MediaQuery.of(context).size.width * 0.6,
              margin: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: const Text(
                      'Weight unit',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          for (var unitType in UnitType.values)
                            RadioListTile(
                              activeColor: Colors.blue[700],
                              contentPadding: EdgeInsets.zero,
                              title: Text(
                                UnitTypeHelper.toSubtitle(unitType),
                              ),
                              value: unitType,
                              groupValue: newUnit,
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() => newUnit = unitType);
                                }
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        child: const Text(
                          'OK',
                          style: TextStyle(
                            fontSize: 13.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {
                          if (Navigator.canPop(context)) {
                            shouldUpdate = true;
                            Navigator.pop(context);
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );

  if (shouldUpdate) return newUnit;

  return unit!;
}
