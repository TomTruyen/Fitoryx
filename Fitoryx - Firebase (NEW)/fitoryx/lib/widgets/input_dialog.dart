import 'package:fitoryx/widgets/form_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<void> showInputDialog(
  BuildContext context,
  String title,
  String suffix,
  double value,
  Function(double) onPressed,
) async {
  double newValue = value;

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
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Center(
                      child: Container(
                        margin: const EdgeInsets.only(top: 16.0),
                        height: 100.0,
                        child: FormInput(
                          hintText: '0',
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(5),
                            FilteringTextInputFormatter.allow(
                              RegExp(r'(^\d*\.?\d{0,1})'),
                            )
                          ],
                          inputType: TextInputType.number,
                          inputAction: TextInputAction.next,
                          suffix: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Text(
                              suffix.toUpperCase(),
                            ),
                          ),
                          onChanged: (String value) {
                            if (value == "") value = "0";

                            newValue = double.parse(value);
                          },
                        ),
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
                          onPressed.call(newValue);

                          if (Navigator.canPop(context)) {
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
}
