import 'package:fitoryx/models/graph_type.dart';

extension GraphTypeExtension on List<GraphType> {
  bool has(GraphType type) {
    return indexWhere((t) => t.name == type.name) > -1;
  }
}
