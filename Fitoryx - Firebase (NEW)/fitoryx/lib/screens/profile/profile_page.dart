import 'package:fitoryx/models/settings.dart';
import 'package:fitoryx/screens/settings/settings_page.dart';
import 'package:fitoryx/services/settings_service.dart';
import 'package:fitoryx/widgets/graphs_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final SettingsService _settingsService = SettingsService();
  Settings _settings = Settings();

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
            title: const Text('Profile'),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.settings_outlined),
                onPressed: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      fullscreenDialog: true,
                      builder: (context) => const SettingsPage(),
                    ),
                  );
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Container(
              alignment: Alignment.centerRight,
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  primary: Theme.of(context).textTheme.bodyText2?.color,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const <Widget>[
                    Icon(Icons.remove_red_eye),
                    SizedBox(width: 5.0),
                    Text('Toggle graphs'),
                  ],
                ),
                onPressed: () async {
                  _settings.graphs =
                      await showGraphsDialog(context, _settings.graphs);

                  await _settingsService.setGraphs(_settings.graphs);

                  _updateSettings();
                },
              ),
            ),
          ),
          if (_settings.graphs.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Container(
                  margin: const EdgeInsets.only(
                    bottom: 56,
                  ),
                  child: const Text('No graphs to show'),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _init() async {
    var settings = await _settingsService.getSettings();

    setState(() {
      _settings = settings;
    });
  }

  void _updateSettings() async {
    setState(() {
      _settings = _settings;
    });
  }
}
