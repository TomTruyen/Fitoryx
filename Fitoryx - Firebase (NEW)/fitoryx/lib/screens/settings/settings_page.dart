import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:fitoryx/models/settings.dart';
import 'package:fitoryx/models/settings_item.dart';
import 'package:fitoryx/models/settings_type.dart';
import 'package:fitoryx/models/unit_type.dart';
import 'package:fitoryx/screens/settings/nutrition_goals_page.dart';
import 'package:fitoryx/screens/sign_in.dart';
import 'package:fitoryx/services/auth_service.dart';
import 'package:fitoryx/services/settings_service.dart';
import 'package:fitoryx/utils/int_extension.dart';
import 'package:fitoryx/widgets/gradient_button.dart';
import 'package:fitoryx/widgets/settings_group.dart';
import 'package:fitoryx/widgets/time_dialog.dart';
import 'package:fitoryx/widgets/unit_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final SettingsService _settingsService = SettingsService();
  Settings _settings = Settings();

  final String toMail = "tom.truyen@gmail.com";
  final AuthService _authService = AuthService();
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();
  PackageInfo? _packageInfo;

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: <Widget>[
          SliverAppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.grey[50],
            floating: true,
            pinned: true,
            leading: const CloseButton(),
            title: const Text('Settings'),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                // Units
                SettingsGroup(
                  title: 'Units',
                  items: <SettingsItem>[
                    SettingsItem(
                      title: 'Weight Unit',
                      subtitle: UnitTypeHelper.toSubtitle(_settings.weightUnit),
                      onTap: () async {
                        var unit = await showUnitDialog(
                          context,
                          _settings.weightUnit,
                        );

                        _settingsService.setWeightUnit(unit);

                        _updateSettings();
                      },
                    ),
                  ],
                ),
                // Nutrition
                SettingsGroup(
                  title: 'Nutrition',
                  items: <SettingsItem>[
                    SettingsItem(
                      title: 'Nutrition Goals',
                      subtitle: 'Set your nutrition goals',
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            fullscreenDialog: true,
                            builder: (context) => NutritionGoalsPage(
                              settings: _settings,
                              updateSettings: _updateSettings,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                // Rest Timer
                SettingsGroup(
                  title: 'Rest Timer',
                  items: <SettingsItem>[
                    SettingsItem(
                      title: 'Default rest time',
                      subtitle: _settings.rest.toMinutesAndSeconds(),
                      onTap: () async {
                        int rest = await showTimeDialog(
                          context,
                          _settings.rest,
                          interval: 5,
                          max: 300,
                        );

                        _settingsService.setRest(rest);
                        _updateSettings();
                      },
                    ),
                    SettingsItem(
                      title: 'Rest timer enabled',
                      enabled: _settings.restEnabled,
                      type: SettingsType.switchTile,
                      onChanged: (bool value) async {
                        await _settingsService.setRestEnabled(value);
                        _updateSettings();
                      },
                    ),
                    SettingsItem(
                      title: 'Vibrate upon finish',
                      enabled: _settings.vibrateEnabled,
                      type: SettingsType.switchTile,
                      onChanged: (bool value) async {
                        await _settingsService.setVibrateEnabled(value);
                        _updateSettings();
                      },
                    ),
                  ],
                ),
                // Contact and support
                SettingsGroup(
                  title: 'Contact and support',
                  items: <SettingsItem>[
                    SettingsItem(
                      title: 'Report an issue',
                      subtitle: 'Found a problem? Send us the details',
                      onTap: _reportBug,
                    ),
                  ],
                ),

                Container(
                  padding: const EdgeInsets.all(16),
                  child: GradientButton(
                    text: 'Sign out',
                    onPressed: () {
                      _authService.signOut();

                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      }

                      Navigator.pushReplacement(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => const SignIn(),
                        ),
                      );
                    },
                  ),
                ),

                const Divider(),
                if (_packageInfo != null)
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      "Version: ${_packageInfo?.version} - Build: ${_packageInfo?.buildNumber}",
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _init() async {
    var packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = packageInfo;
    });

    _updateSettings();
  }

  void _updateSettings() async {
    var settings = await _settingsService.getSettings();

    setState(() {
      _settings = settings;
    });
  }

  void _reportBug() async {
    String subject =
        "Bug Report Version: ${_packageInfo?.version} - Build: ${_packageInfo?.buildNumber}";

    String body =
        "Please write your issue above this line. Don't remove anything below\n\n";

    body += "Device: \n";

    if (Platform.isAndroid) {
      AndroidDeviceInfo info = await _deviceInfo.androidInfo;

      body += 'Android Version: ${info.version.release}\n';
      body += 'SDK Version: ${info.version.sdkInt}\n';
      body += 'Security Patch: ${info.version.securityPatch}\n';
      body += 'Manufacturer: ${info.manufacturer}\n';
      body += 'Brand: ${info.brand}\n';
      body += 'Model: ${info.model}\n';
    }

    String url = "mailto:$toMail?subject=$subject&body=$body";

    if (await canLaunch(url)) {
      launch(url);
    }
  }
}
