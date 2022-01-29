import 'package:fitoryx/models/settings_type.dart';

class SettingsItem {
  final String title;
  final String? subtitle;
  final bool? enabled;
  final void Function()? onTap;
  final void Function(bool)? onChanged;
  final SettingsType type;

  SettingsItem({
    required this.title,
    this.subtitle,
    this.enabled,
    this.onTap,
    this.onChanged,
    this.type = SettingsType.listTile,
  });
}
