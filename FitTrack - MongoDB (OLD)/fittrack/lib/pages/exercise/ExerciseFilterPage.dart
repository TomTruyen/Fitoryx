// Flutter Packages
import 'package:fittrack/misc/exercises/ExerciseFilterPageFunctions.dart';
import 'package:flutter/material.dart';

// PubDev Packages
import 'package:provider/provider.dart';

// My Packages
import 'package:fittrack/misc/Functions.dart';
import 'package:fittrack/shared/Loader.dart';
import 'package:fittrack/model/exercise/ExerciseFilter.dart';
import 'package:fittrack/shared/Globals.dart' as globals;

class ExerciseFilterPage extends StatefulWidget {
  @override
  _ExerciseFilterPageState createState() => _ExerciseFilterPageState();
}

class _ExerciseFilterPageState extends State<ExerciseFilterPage> {
  ExerciseFilter exerciseFilter;

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  Widget build(BuildContext context) {
    exerciseFilter = Provider.of<ExerciseFilter>(context) ?? null;

    return _ExerciseFilterPageView(this);
  }
}

class _ExerciseFilterPageView extends StatelessWidget {
  final _ExerciseFilterPageState state;

  _ExerciseFilterPageView(this.state);

  @override
  Widget build(BuildContext context) {
    final ExerciseFilter _exerciseFilter = state.exerciseFilter;

    return _exerciseFilter == null
        ? Loader()
        : Scaffold(
            body: ScrollConfiguration(
              behavior: ScrollBehavior(),
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    floating: false,
                    pinned: true,
                    leading: IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        popContextWhenPossible(context);
                      },
                    ),
                  ),
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Filter (${_exerciseFilter.exerciseCount})',
                            style: TextStyle(fontSize: 24.0),
                          ),
                          SizedBox(height: 20.0),
                          Text('Category'),
                          SizedBox(height: 20.0),
                          Wrap(
                            spacing: 10.0,
                            runSpacing: 15.0,
                            children: buildFilterCategories(
                              _exerciseFilter,
                              globals.categories,
                            ),
                          ),
                          SizedBox(height: 20.0),
                          Text('Equipment'),
                          SizedBox(height: 20.0),
                          Wrap(
                            spacing: 10.0,
                            runSpacing: 15.0,
                            children: buildFilterEquipment(
                              _exerciseFilter,
                              globals.equipment,
                            ),
                          ),
                          SizedBox(height: 20.0),
                          Text('Exercise Type'),
                          SizedBox(height: 20.0),
                          Wrap(
                            spacing: 10.0,
                            runSpacing: 15.0,
                            children: buildExerciseType(
                              _exerciseFilter,
                            ),
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
              child: TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    side: BorderSide(
                      width: 1,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                  padding: EdgeInsets.all(14.0),
                  backgroundColor: Theme.of(context).accentColor,
                ),
                child: Text(
                  'Clear Filters',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  _exerciseFilter.clearFilters();
                },
              ),
            ),
          );
  }
}

class FilterWidget extends StatelessWidget {
  final String muscleGroup;
  final bool selected;

  FilterWidget({this.muscleGroup, this.selected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      height: 35.0,
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
        muscleGroup,
        style: TextStyle(
          color: selected ? Colors.white : Theme.of(context).accentColor,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
