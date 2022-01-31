import 'package:fitoryx/models/settings.dart';
import 'package:fitoryx/services/settings_service.dart';
import 'package:fitoryx/utils/utils.dart';
import 'package:fitoryx/widgets/form_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NutritionGoalsPage extends StatefulWidget {
  final Settings settings;
  final Function() updateSettings;

  const NutritionGoalsPage(
      {Key? key, required this.settings, required this.updateSettings})
      : super(key: key);

  @override
  State<NutritionGoalsPage> createState() => _NutritionGoalsPageState();
}

class _NutritionGoalsPageState extends State<NutritionGoalsPage> {
  final SettingsService _settingsService = SettingsService();
  Settings _settings = Settings();

  final _inputFormatters = <TextInputFormatter>[
    LengthLimitingTextInputFormatter(5),
    FilteringTextInputFormatter.digitsOnly,
  ];

  @override
  void initState() {
    super.initState();
    setState(() {
      _settings = widget.settings;
    });
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
            title: const Text('Nutrition Goals'),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.check),
                onPressed: () async {
                  await _settingsService.setKcal(_settings.kcal);
                  await _settingsService.setCarbs(_settings.carbs);
                  await _settingsService.setProtein(_settings.protein);
                  await _settingsService.setFat(_settings.fat);

                  widget.updateSettings();

                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
          SliverFillRemaining(
            child: Form(
              child: Container(
                margin: const EdgeInsets.all(16),
                child: Column(
                  children: <Widget>[
                    FormInput(
                      hintText: '0',
                      initialValue: _settings.kcal?.toString() ?? "",
                      inputFormatters: _inputFormatters,
                      inputType: TextInputType.number,
                      inputAction: TextInputAction.next,
                      suffix: const Padding(
                        padding: EdgeInsets.all(15),
                        child: Text('KCAL'),
                      ),
                      onChanged: (String value) {
                        _settings.kcal = convertStringToInt(value);
                      },
                    ),
                    const SizedBox(height: 20),
                    FormInput(
                      hintText: '0',
                      initialValue: _settings.carbs?.toString() ?? "",
                      inputFormatters: _inputFormatters,
                      inputType: TextInputType.number,
                      inputAction: TextInputAction.next,
                      suffix: const Padding(
                        padding: EdgeInsets.all(15),
                        child: Text('CARBS'),
                      ),
                      onChanged: (String value) {
                        _settings.carbs = convertStringToInt(value);
                      },
                    ),
                    const SizedBox(height: 20),
                    FormInput(
                      hintText: '0',
                      initialValue: _settings.protein?.toString() ?? "",
                      inputFormatters: _inputFormatters,
                      inputType: TextInputType.number,
                      inputAction: TextInputAction.next,
                      suffix: const Padding(
                        padding: EdgeInsets.all(15),
                        child: Text('PROTEIN'),
                      ),
                      onChanged: (String value) {
                        _settings.protein = convertStringToInt(value);
                      },
                    ),
                    const SizedBox(height: 20),
                    FormInput(
                      hintText: '0',
                      initialValue: _settings.fat?.toString() ?? "",
                      inputFormatters: _inputFormatters,
                      inputType: TextInputType.number,
                      inputAction: TextInputAction.next,
                      suffix: const Padding(
                        padding: EdgeInsets.all(15),
                        child: Text('FAT'),
                      ),
                      onChanged: (String value) {
                        _settings.fat = convertStringToInt(value);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
