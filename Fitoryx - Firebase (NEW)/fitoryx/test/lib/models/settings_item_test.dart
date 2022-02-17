import 'package:fitoryx/models/settings_item.dart';
import 'package:fitoryx/models/settings_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SettingsItem', () {
    test('constructor should set values', () {
      var result = SettingsItem(
        title: 'Title',
        subtitle: 'Subtitle',
        enabled: true,
        type: SettingsType.listTile,
      );

      expect(result.title, "Title");
      expect(result.subtitle, "Subtitle");
      expect(result.enabled, true);
      expect(result.onTap, null);
      expect(result.onChanged, null);
      expect(result.type, SettingsType.listTile);
    });
  });
}
