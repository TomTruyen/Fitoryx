import 'package:fitoryx/models/nutrition.dart';
import 'package:fitoryx/services/firestore_service.dart';
import 'package:fitoryx/utils/string_extension.dart';
import 'package:fitoryx/widgets/alert.dart';
import 'package:fitoryx/widgets/form_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddNutritionPage extends StatefulWidget {
  final Nutrition nutrition;
  final Function(Nutrition) updateNutrition;

  const AddNutritionPage(
      {Key? key, required this.nutrition, required this.updateNutrition})
      : super(key: key);

  @override
  State<AddNutritionPage> createState() => _AddNutritionPageState();
}

class _AddNutritionPageState extends State<AddNutritionPage> {
  final FirestoreService _firestoreService = FirestoreService();

  final Nutrition _nutrition = Nutrition();

  final _inputFormatters = <TextInputFormatter>[
    LengthLimitingTextInputFormatter(5),
    FilteringTextInputFormatter.digitsOnly,
  ];

  @override
  void initState() {
    super.initState();
    _nutrition.id = widget.nutrition.id;
    _nutrition.date = widget.nutrition.date;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Colors.grey[50],
            floating: true,
            pinned: true,
            title: const Text('Add Nutrition'),
            leading: const CloseButton(),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.check),
                onPressed: () async {
                  try {
                    Nutrition nutrition = await _firestoreService.saveNutrition(
                      _nutrition,
                    );

                    widget.updateNutrition(nutrition);

                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                  } catch (e) {
                    showAlert(
                      context,
                      content: "Failed to add nutrition. Please try again.",
                    );
                  }
                },
              )
            ],
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(16),
              child: Column(
                children: <Widget>[
                  FormInput(
                    hintText: '0',
                    inputFormatters: _inputFormatters,
                    inputType: TextInputType.number,
                    inputAction: TextInputAction.next,
                    suffix: const Padding(
                      padding: EdgeInsets.all(15),
                      child: Text('KCAL'),
                    ),
                    onChanged: (String value) {
                      _nutrition.kcal = value.toInt() ?? 0;
                    },
                  ),
                  const SizedBox(height: 20),
                  FormInput(
                    hintText: '0',
                    inputFormatters: _inputFormatters,
                    inputType: TextInputType.number,
                    inputAction: TextInputAction.next,
                    suffix: const Padding(
                      padding: EdgeInsets.all(15),
                      child: Text('CARBS'),
                    ),
                    onChanged: (String value) {
                      _nutrition.carbs = value.toInt() ?? 0;
                    },
                  ),
                  const SizedBox(height: 20),
                  FormInput(
                    hintText: '0',
                    inputFormatters: _inputFormatters,
                    inputType: TextInputType.number,
                    inputAction: TextInputAction.next,
                    suffix: const Padding(
                      padding: EdgeInsets.all(15),
                      child: Text('PROTEIN'),
                    ),
                    onChanged: (String value) {
                      _nutrition.protein = value.toInt() ?? 0;
                    },
                  ),
                  const SizedBox(height: 20),
                  FormInput(
                    hintText: '0',
                    inputFormatters: _inputFormatters,
                    inputType: TextInputType.number,
                    inputAction: TextInputAction.next,
                    suffix: const Padding(
                      padding: EdgeInsets.all(15),
                      child: Text('FAT'),
                    ),
                    onChanged: (String value) {
                      _nutrition.fat = value.toInt() ?? 0;
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
