import 'package:fitoryx/widgets/popup_menu.dart';
import 'package:flutter/material.dart';

class GraphCard extends StatelessWidget {
  final String title;
  final Widget graph;
  final PopupMenu popup;

  const GraphCard(
      {Key? key, required this.title, required this.graph, required this.popup})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      margin: const EdgeInsets.symmetric(
        horizontal: 12.0,
        vertical: 4.0,
      ),
      child: Container(
        height: MediaQuery.of(context).size.height / 3.0,
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 16.0),
                    child: Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  popup,
                ],
              ),
            ),
            Expanded(
              flex: 4,
              child: Container(
                margin: const EdgeInsets.only(top: 16.0),
                child: graph,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
