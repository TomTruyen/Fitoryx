import 'package:fittrack/models/settings/GraphToShow.dart';
import 'package:fittrack/models/settings/Settings.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    'Settings',
    () {
      shouldShowGraphTests();
      shouldShowNoGraphsTests();
    },
  );
}

void shouldShowGraphTests() {
  List<GraphToShow> graphsToShowList = [
    GraphToShow(title: 'Hi', show: false),
    GraphToShow(title: 'TestGraph', show: true),
  ];

  Settings settings = Settings(graphsToShow: graphsToShowList);

  test(
    'shouldShowGraph should return bool',
    () {
      dynamic result = settings.shouldShowGraph('TestGraph');

      expect(result, isInstanceOf<bool>(),
          reason:
              "Result was expected to be of type 'bool' but was ${result.runtimeType}");
    },
  );

  test(
    'shouldShowGraph should return true if title is found and graph is set to be show',
    () {
      dynamic result = settings.shouldShowGraph('TestGraph');

      expect(result, true,
          reason:
              "Result was expected to be true but was ${result.runtimeType}");
    },
  );

  test(
    'shouldShowGraph should return false if title is not found or title is found, but is set to not show',
    () {
      dynamic result = settings.shouldShowGraph('notFoundTitle');
      dynamic resultNoShow = settings.shouldShowGraph('Hi');

      expect(result, false,
          reason:
              "Result was expected to be false but was ${result.runtimeType}");

      expect(resultNoShow, false,
          reason:
              "Result was expected to be false but was ${result.runtimeType}");
    },
  );
}

void shouldShowNoGraphsTests() {
  List<GraphToShow> graphsToShowList = [
    GraphToShow(title: 'Hi', show: true),
    GraphToShow(title: 'TestGraph', show: false),
  ];

  List<GraphToShow> noGraphsToShowList = [
    GraphToShow(title: 'Hi', show: false),
    GraphToShow(title: 'TestGraph', show: false),
  ];

  Settings settings = Settings(graphsToShow: graphsToShowList);

  test(
    'shouldShowNoGraphs should return bool',
    () {
      dynamic result = settings.shouldShowNoGraphs();

      expect(result, isInstanceOf<bool>(),
          reason:
              "Result was expected to be of type 'bool' but was ${result.runtimeType}");
    },
  );

  test(
    'shouldShowNoGraphs should return true if no graphs should be shown',
    () {
      settings.graphsToShow = noGraphsToShowList;

      dynamic result = settings.shouldShowNoGraphs();

      expect(result, true,
          reason:
              "Result was expected to be true but was ${result.runtimeType}");
    },
  );

  test(
    'shouldShowNoGraphs should return false if at least 1 graph should be shown',
    () {
      settings.graphsToShow = graphsToShowList;

      dynamic result = settings.shouldShowNoGraphs();

      expect(result, false,
          reason:
              "Result was expected to be false but was ${result.runtimeType}");
    },
  );
}
