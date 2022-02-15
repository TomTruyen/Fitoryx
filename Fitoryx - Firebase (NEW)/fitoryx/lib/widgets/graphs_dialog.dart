import 'package:fitoryx/models/graph_type.dart';
import 'package:fitoryx/utils/graph_type_extension.dart';
import 'package:flutter/material.dart';

Future<List<GraphType>> showGraphsDialog(
  BuildContext context,
  List<GraphType> graphs,
) async {
  bool shouldUpdate = false;
  List<GraphType> newGraphs = List.of(graphs);

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
                      'Graphs',
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
                          for (var graphType in GraphType.values)
                            CheckboxListTile(
                              activeColor: Theme.of(context).primaryColor,
                              contentPadding: EdgeInsets.zero,
                              controlAffinity: ListTileControlAffinity.leading,
                              title: Text(
                                GraphTypeHelper.toValue(graphType),
                              ),
                              value: newGraphs.has(graphType),
                              onChanged: (value) {
                                if (value != null) {
                                  if (newGraphs.has(graphType)) {
                                    setState(() {
                                      newGraphs.remove(graphType);
                                    });
                                  } else {
                                    setState(() {
                                      newGraphs.add(graphType);
                                    });
                                  }
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

  if (shouldUpdate) return newGraphs;

  return graphs;
}
