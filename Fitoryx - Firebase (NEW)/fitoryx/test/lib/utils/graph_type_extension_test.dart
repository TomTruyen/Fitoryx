import 'package:fitoryx/models/graph_type.dart';
import 'package:fitoryx/utils/graph_type_extension.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('toDecimalPlaces should round to given decimals spaces', () {
    List<GraphType> types = [
      GraphType.calories,
      GraphType.volume,
    ];

    expect(types.has(GraphType.calories), true);
    expect(types.has(GraphType.volume), true);
    expect(types.has(GraphType.workouts), false);
  });
}
