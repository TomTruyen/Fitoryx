import 'package:fitoryx/widgets/popup_menu.dart';
import 'package:flutter/material.dart';

class GraphCard extends StatelessWidget {
  final String title;
  final Widget graph;
  final PopupMenu? popup;
  final double height;

  const GraphCard({
    Key? key,
    required this.title,
    required this.graph,
    this.popup,
    this.height = 250,
  }) : super(key: key);

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
        height: height,
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
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
                  popup ?? Container(),
                ],
              ),
            ),
            Container(
              height: 175,
              padding: const EdgeInsets.only(top: 8),
              child: graph,
            ),
          ],
        ),
      ),
    );
  }
}
