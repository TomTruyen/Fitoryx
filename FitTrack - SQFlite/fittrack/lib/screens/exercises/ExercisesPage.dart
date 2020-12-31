import 'package:flutter/material.dart';

import 'package:fittrack/shared/ExerciseList.dart';

class ExercisesPage extends StatefulWidget {
  final bool isSelectActive;

  ExercisesPage({this.isSelectActive = false});

  @override
  _ExercisesPageState createState() => _ExercisesPageState();
}

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
          onPressed: () {},
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

  SliverAppBar searchAppBar() {
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
            // Clear text field
          },
        ),
        IconButton(
          icon: Icon(
            Icons.filter_list_outlined,
            color: Colors.black,
          ),
          onPressed: () {},
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
    return CustomScrollView(
      slivers: <Widget>[
        isSearchActive ? searchAppBar() : defaultAppBar(),
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
