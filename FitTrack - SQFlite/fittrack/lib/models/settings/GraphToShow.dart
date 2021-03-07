import 'dart:convert';

class GraphToShow {
  String title;
  bool show;

  GraphToShow({
    this.title,
    this.show = true,
  });

  static fromJSON(Map<String, dynamic> json) {
    return new GraphToShow(
      title: json['title'] ?? '',
      show: json['show'] ?? false,
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      'title': title,
      'show': show,
    };
  }

  static List<GraphToShow> getDefaultGraphs() {
    return [
      GraphToShow(title: 'workoutsPerWeek', show: true),
      GraphToShow(title: 'userWeight', show: true),
      GraphToShow(title: 'totalVolume', show: true),
      GraphToShow(title: 'caloriesGraph', show: true),
    ];
  }
}

int foundGraphsToShowInListIndex(
  List<GraphToShow> graphToShowList,
  GraphToShow graphToShow,
) {
  int index = -1;

  for (int i = 0; i < graphToShowList.length; i++) {
    if (graphToShowList[i].title.toLowerCase() ==
        graphToShow.title.toLowerCase()) {
      index = i;
      break;
    }
  }

  return index;
}

List<GraphToShow> getGraphsToShowListFromJson(Map<String, dynamic> settings) {
  List<GraphToShow> _graphsToShowList = GraphToShow.getDefaultGraphs();

  if (settings != null) {
    List<dynamic> _graphsToShowJsonList = [];
    if (settings['graphsToShow'] != null) {
      _graphsToShowJsonList = jsonDecode(settings['graphsToShow']) ?? [];
    }

    for (int i = 0; i < _graphsToShowJsonList.length; i++) {
      GraphToShow graphToShow = GraphToShow.fromJSON(_graphsToShowJsonList[i]);

      int foundIndex = foundGraphsToShowInListIndex(
        _graphsToShowList,
        graphToShow,
      );

      if (foundIndex == -1) {
        _graphsToShowList.add(graphToShow);
      } else {
        _graphsToShowList[foundIndex] = graphToShow;
      }
    }
  }

  return _graphsToShowList;
}
