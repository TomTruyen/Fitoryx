import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:fittrack/models/exercises/ExerciseFilter.dart';
import 'package:fittrack/shared/Functions.dart';
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
                  ),
                  SliverFillRemaining(
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Filter (${filter.exerciseCount})',
                            style: TextStyle(fontSize: 24.0),
                          ),
                          SizedBox(height: 20.0),
                          Text('Category'),
                          SizedBox(height: 20.0),
                          Wrap(
                            spacing: 10.0,
                            runSpacing: 15.0,
                            children: buildFilterWidgets(filter, 'category'),
                          ),
                          SizedBox(height: 20.0),
                          Text('Equipment'),
                          SizedBox(height: 20.0),
                          Wrap(
                            spacing: 10.0,
                            runSpacing: 15.0,
                            children: buildFilterWidgets(filter, 'equipment'),
                          ),
                          SizedBox(height: 20.0),
                          Text('User Created'),
                          SizedBox(height: 20.0),
                          Wrap(
                            spacing: 10.0,
                            runSpacing: 15.0,
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
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  side: BorderSide(
                    width: 1,
                    color: Theme.of(context).accentColor,
                  ),
                ),
                padding: EdgeInsets.all(14.0),
                child: Text(
                  'Clear Filters',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
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
      height: 38.0,
      decoration: BoxDecoration(
        color: selected ? Theme.of(context).accentColor : Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(12.0),
        ),
        border: Border.all(
          color: Theme.of(context).accentColor,
          width: 1.0,
        ),
      ),
      child: Text(
        value,
        style: TextStyle(
          color: selected ? Colors.white : Theme.of(context).accentColor,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
