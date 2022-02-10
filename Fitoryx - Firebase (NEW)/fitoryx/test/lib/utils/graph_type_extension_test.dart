import 'package:fitoryx/models/graph_type.dart';
import 'package:fitoryx/utils/graph_type_extension.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('has should return true if found', () {
    List<GraphType> types = [
      GraphType.calories,
      GraphType.volume,
      GraphType.workouts
    ];

    expect(types.has(GraphType.calories), true);
    expect(types.has(GraphType.volume), true);
    expect(types.has(GraphType.workouts), true);
  });

  test('has should return false if not found', () {
    List<GraphType> types = [];

    expect(types.has(GraphType.calories), false);
    expect(types.has(GraphType.volume), false);
    expect(types.has(GraphType.workouts), false);
  });
}
