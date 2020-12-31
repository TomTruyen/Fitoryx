import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:fittrack/screens/exercises/ExerciseFilterPage.dart';
import 'package:fittrack/models/exercises/ExerciseFilter.dart';
import 'package:fittrack/shared/ExerciseList.dart';
import 'package:fittrack/shared/Loader.dart';

class ExercisesPage extends StatefulWidget {
  final bool isSelectActive;

  ExercisesPage({this.isSelectActive = false});

  @override
  _ExercisesPageState createState() => _ExercisesPageState();
}

// TODO

// 1. ExerciseFilter Function (voor ExerciseFilterPage) ==> Zorg ook dat de exercises dividers hebben van alfabaet (A, B, C,...)
// 1.1 Use ExerciseCount value for filterwidget
// 1.2 User filtered exercises to display
// 2. Start using SearchValue to filter through exercises

class _ExercisesPageState extends State<ExercisesPage> {
  bool isSearchActive = false;

  SliverAppBar defaultAppBar() {
    return SliverAppBar(
      backgroundColor: Colors.grey[50],
      floating: true,
      pinned: true,
      title: Text(
        'Exercises',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.search_outlined,
            color: Colors.black,
          ),
          onPressed: () {
            setState(() {
              isSearchActive = true;
            });
          },
        ),
        IconButton(
          icon: Icon(
            Icons.filter_list_outlined,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => ExerciseFilterPage(),
              ),
            );
          },
        ),
        if (!widget.isSelectActive)
          IconButton(
            icon: Icon(
              Icons.more_vert_outlined,
              color: Colors.black,
            ),
            onPressed: () {},
          ),
      ],
    );
  }

  SliverAppBar searchAppBar(ExerciseFilter filter) {
    return SliverAppBar(
      backgroundColor: Colors.grey[50],
      floating: true,
      pinned: true,
      title: Text(
        'searchbar hier',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
      ),
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_outlined,
          color: Colors.black,
        ),
        onPressed: () {
          setState(() {
            isSearchActive = false;
          });
        },
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.close_outlined,
            color: Colors.black,
          ),
          onPressed: () {
            filter.updateSearchValue("");
          },
        ),
        IconButton(
          icon: Icon(
            Icons.filter_list_outlined,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => ExerciseFilterPage(),
              ),
            );
          },
        ),
        if (!widget.isSelectActive)
          IconButton(
            icon: Icon(
              Icons.more_vert_outlined,
              color: Colors.black,
            ),
            onPressed: () {},
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final ExerciseFilter filter = Provider.of<ExerciseFilter>(context) ?? null;

    return filter == null
        ? Loader()
        : CustomScrollView(
            slivers: <Widget>[
              isSearchActive ? searchAppBar(filter) : defaultAppBar(),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int i) {
                    String name = exercises[i].name;

                    if (exercises[i].equipment != "") {
                      name += ' (${exercises[i].equipment})';
                    }

                    String category = exercises[i].category;

                    return ListTile(
                      title: Text(name, overflow: TextOverflow.ellipsis),
                      subtitle: Text(category, overflow: TextOverflow.ellipsis),
                      onTap: widget.isSelectActive
                          ? () {
                              print("Tapped Widget Number: $i");
                            }
                          : null,
                    );
                  },
                  childCount: exercises.length,
                ),
              ),
            ],
          );
  }
}
