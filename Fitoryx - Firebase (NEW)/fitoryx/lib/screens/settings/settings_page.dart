import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:fitoryx/models/settings_item.dart';
import 'package:fitoryx/models/settings_type.dart';
import 'package:fitoryx/screens/sign_in.dart';
import 'package:fitoryx/services/auth_service.dart';
import 'package:fitoryx/widgets/gradient_button.dart';
import 'package:fitoryx/widgets/settings_group.dart';
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
                // Profile
                SettingsGroup(
                  title: 'Profile',
                  items: <SettingsItem>[
                    SettingsItem(
                      title: 'Edit Profile',
                      subtitle: 'Edit your weight, height, body fat,...',
                      onTap: () {},
                    )
                  ],
                ),
                // Units
                SettingsGroup(
                  title: 'Units',
                  items: <SettingsItem>[
                    SettingsItem(
                      title: 'Weight Unit',
                      subtitle: 'Metric (kg)',
                      onTap: () {},
                    ),
                    SettingsItem(
                      title: 'Height Unit',
                      subtitle: 'Metric (cm)',
                      onTap: () {},
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
                      onTap: () {},
                    ),
                  ],
                ),
                // Rest Timer
                SettingsGroup(
                  title: 'Rest Timer',
                  items: <SettingsItem>[
                    SettingsItem(
                      title: 'Default rest time',
                      subtitle: '60s',
                      onTap: () {},
                    ),
                    SettingsItem(
                      title: 'Rest timer enabled',
                      enabled: true,
                      type: SettingsType.switchTile,
                      onChanged: (bool value) {},
                    ),
                    SettingsItem(
                      title: 'Vibrate upon finish',
                      enabled: true,
                      type: SettingsType.switchTile,
                      onChanged: (bool value) {},
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
