import 'package:fittrack/shared/GradientText.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:fittrack/models/exercises/ExerciseFilter.dart';
import 'package:fittrack/shared/Functions.dart';
import 'package:fittrack/shared/GradientButton.dart';
import 'package:fittrack/shared/Loader.dart';
import 'package:fittrack/shared/CategoryList.dart';
import 'package:fittrack/shared/EquipmentList.dart';

class ExerciseFilterPage extends StatefulWidget {
  @override
  _ExerciseFilterPageState createState() => _ExerciseFilterPageState();
}

class _ExerciseFilterPageState extends State<ExerciseFilterPage> {
  List<Widget> buildFilterWidgets(ExerciseFilter filter, String type) {
    if (type == 'userCreated') {
      return [
        InkWell(
          borderRadius: BorderRadius.circular(12.0),
          child: FilterWidget(
            value: 'User Created Exercise',
            selected: filter.isUserCreated == 0 ? false : true,
          ),
          onTap: () {
            filter.toggleUserCreated();
          },
        ),
      ];
    }

    List<Widget> filterWidgets = [];

    List<String> items = type == 'category' ? categories : equipment;
    List<String> selectedItems = type == 'category'
        ? filter.selectedCategories
        : filter.selectedEquipment;

    for (int i = 0; i < items.length; i++) {
      bool selected = false;

      for (int j = 0; j < selectedItems.length; j++) {
        if (selectedItems[j] == items[i]) {
          selected = true;
          break;
        }
      }

      filterWidgets.add(
        InkWell(
          borderRadius: BorderRadius.circular(12.0),
          child: FilterWidget(
            value: items[i],
            selected: selected,
          ),
          onTap: () {
            if (selected) {
              if (type == 'category') {
                filter.removeCategory(items[i]);
              } else {
                filter.removeEquipment(items[i]);
              }
            } else {
              if (type == 'category') {
                filter.addCategory(items[i]);
              } else {
                filter.addEquipment(items[i]);
              }
            }
          },
        ),
      );
    }

    return filterWidgets;
  }

  @override
  Widget build(BuildContext context) {
    ExerciseFilter filter = Provider.of<ExerciseFilter>(context) ?? null;

    return filter == null
        ? Loader()
        : Scaffold(
            body: ScrollConfiguration(
              behavior: ScrollBehavior(),
              child: CustomScrollView(
                physics: BouncingScrollPhysics(),
                slivers: <Widget>[
                  SliverAppBar(
                    backgroundColor: Colors.grey[50],
                    floating: false,
                    pinned: true,
                    leading: IconButton(
                      icon: Icon(
                        Icons.close,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        tryPopContext(context);
                      },
                    ),
                    title: Text(
                      'Filter (${filter.exerciseCount})',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SliverFillRemaining(
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Category'),
                          SizedBox(height: 20.0),
                          Wrap(
                            spacing: 10.0,
                            runSpacing: 10.0,
                            children: buildFilterWidgets(filter, 'category'),
                          ),
                          SizedBox(height: 20.0),
                          Text('Equipment'),
                          SizedBox(height: 20.0),
                          Wrap(
                            spacing: 10.0,
                            runSpacing: 10.0,
                            children: buildFilterWidgets(filter, 'equipment'),
                          ),
                          SizedBox(height: 20.0),
                          Text('User Created'),
                          SizedBox(height: 20.0),
                          Wrap(
                            spacing: 10.0,
                            runSpacing: 10.0,
                            children: buildFilterWidgets(filter, 'userCreated'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: Container(
              color: Colors.transparent,
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
              width: MediaQuery.of(context).size.width,
              child: GradientButton(
                text: 'Clear Filters',
                onPressed: () {
                  filter.clearAllFilters();
                },
              ),
            ),
          );
  }
}

class FilterWidget extends StatelessWidget {
  final String value;
  final bool selected;

  FilterWidget({this.value, this.selected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      decoration: BoxDecoration(
        gradient: selected
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[
                  Colors.blueAccent[700],
                  Colors.blueAccent[400],
                  Colors.blueAccent[200],
                ],
                tileMode: TileMode.repeated,
              )
            : null,
        color: !selected ? Colors.white : null,
        border: !selected
            ? Border.all(color: Colors.blueAccent[400])
            : Border.all(color: Colors.transparent),
        borderRadius: BorderRadius.all(
          Radius.circular(12.0),
        ),
      ),
      child: !selected
          ? GradientText(
              text: value,
              fontSize: Theme.of(context).textTheme.bodyText2.fontSize * 0.8,
            )
          : Text(
              value,
              style: TextStyle(
                color: Colors.white,
                fontSize: Theme.of(context).textTheme.bodyText2.fontSize * 0.8,
              ),
              textAlign: TextAlign.center,
            ),
    );
  }
}
