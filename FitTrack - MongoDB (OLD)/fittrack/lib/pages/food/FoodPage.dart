// Dart Packages
import 'dart:isolate';
import 'dart:math';

// Flutter Packages
import 'package:fittrack/misc/Functions.dart';
import 'package:flutter/material.dart';

// PubDev Packages
import 'package:charts_flutter/flutter.dart' as charts;

// My Packages
import 'package:fittrack/model/food/Nutrition.dart';
import 'package:fittrack/pages/food/FoodAddPage.dart';
import 'package:fittrack/services/Database.dart';
import 'package:fittrack/shared/Globals.dart' as globals;

class FoodPage extends StatefulWidget {
  @override
  _FoodPageState createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage> {
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  Future<bool> refreshNutrition() async {
    ReceivePort receivePort = ReceivePort();
    Isolate isolate = await Isolate.spawn(
      _loadNutrition,
      {"sendPort": receivePort.sendPort, "uid": globals.uid},
    );

    receivePort.listen((data) {
      List<Nutrition> _nutritionHistory = data;

      globals.nutritionHistory = _nutritionHistory;

      receivePort.close();
      isolate.kill();
      isolate = null;
    });

    bool isCompleted = false;

    await Future.doWhile(() async {
      return await Future.delayed(Duration(milliseconds: 500), () {
        return isolate != null;
      });
    });

    setState(() {});

    return isCompleted;
  }

  static void _loadNutrition(Map<String, dynamic> map) async {
    SendPort _sendPort = map['sendPort'];
    String _uid = map['uid'];

    List<Nutrition> nutritionHistory =
        await Database(uid: _uid).getNutritionHistory() ?? [];

    _sendPort.send(nutritionHistory);
  }

  @override
  Widget build(BuildContext context) {
    return _FoodPageView(this);
  }
}

class _FoodPageView extends StatelessWidget {
  final _FoodPageState state;

  final Nutrition nutrition = globals.nutritionHistory.length > 0
      ? globals.nutritionHistory[globals.nutritionHistory.length - 1].date ==
              convertDateTimeToStringDate(DateTime.now())
          ? globals.nutritionHistory[globals.nutritionHistory.length - 1]
          : Nutrition()
      : Nutrition();

  _FoodPageView(this.state);

  @override
  Widget build(BuildContext context) {
    final Function _refreshNutrition = state.refreshNutrition;

    return Scaffold(
      body: ScrollConfiguration(
        behavior: ScrollBehavior(),
        child: RefreshIndicator(
          displacement: 120.0,
          onRefresh: () async {
            return await _refreshNutrition();
          },
          child: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                expandedHeight: 120.0,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: EdgeInsets.all(16.0),
                  title: Text('Food'),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  height: MediaQuery.of(context).size.width / 1.1,
                  child: KcalWidget(
                      nutrition: nutrition,
                      refreshNutrition: _refreshNutrition),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  height: MediaQuery.of(context).size.width / 2.2,
                  child: MacroWidget(
                    carbs: nutrition.carbs,
                    protein: nutrition.protein,
                    fat: nutrition.fat,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class KcalWidget extends StatelessWidget {
  final Nutrition nutrition;
  final Function refreshNutrition;

  KcalWidget({this.nutrition, this.refreshNutrition});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Stack(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width / 1.1,
              height: MediaQuery.of(context).size.width / 1.1,
              child: GaugeChart(
                _createData(
                  nutrition.kcal,
                  globals.settings.nutritionGoal.kcal,
                  Theme.of(context).accentColor,
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width / 1.1,
              height: MediaQuery.of(context).size.width / 1.1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 50.0),
                  Text(
                    nutrition.kcal.toString(),
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 50.0),
                  ),
                  Text(
                    globals.settings.nutritionGoal.kcal > 0
                        ? 'OF ${globals.settings.nutritionGoal.kcal} KCAL'
                        : 'KCAL',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  SizedBox(height: 20.0),
                  TextButton(
                    style: TextButton.styleFrom(
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(16.0),
                      backgroundColor: Theme.of(context).accentColor,
                    ),
                    child: Icon(Icons.add, color: Colors.grey[50]),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => FoodAddPage(
                            refreshNutrition: refreshNutrition,
                          ),
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MacroWidget extends StatelessWidget {
  // Get Macro's
  final int carbs;
  final int protein;
  final int fat;

  MacroWidget({
    this.carbs = 0,
    this.protein = 0,
    this.fat = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 16.0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  "CARBS",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12.0),
                ),
              ),
              Expanded(
                child: Text(
                  "PROTEIN",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12.0),
                ),
              ),
              Expanded(
                child: Text(
                  "FAT",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12.0),
                ),
              ),
            ],
          ),
          Container(
            height: MediaQuery.of(context).size.width / 3.0,
            child: Row(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width / 3.0,
                  child: Stack(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          "${carbs.toString()}g",
                          style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      GaugeChart(
                        _createData(carbs, globals.settings.nutritionGoal.carbs,
                            Theme.of(context).accentColor),
                        arcWidth: 10,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 3.0,
                  child: Stack(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          "${protein.toString()}g",
                          style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      GaugeChart(
                        _createData(
                            protein,
                            globals.settings.nutritionGoal.protein,
                            Theme.of(context).accentColor),
                        arcWidth: 10,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 3.0,
                  child: Stack(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          "${fat.toString()}g",
                          style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      GaugeChart(
                        _createData(fat, globals.settings.nutritionGoal.fat,
                            Theme.of(context).accentColor),
                        arcWidth: 10,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class GaugeChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final int arcWidth;
  final bool animate;

  GaugeChart(this.seriesList, {this.animate, this.arcWidth = 15});

  @override
  Widget build(BuildContext context) {
    return new charts.PieChart(
      seriesList,
      animate: false,
      defaultRenderer: new charts.ArcRendererConfig(
        strokeWidthPx: 0.0,
        arcWidth: this.arcWidth,
        startAngle: 3 / 2 * pi,
        arcLength: 2 * pi,
      ),
    );
  }
}

List<charts.Series<GaugeSegment, String>> _createData(
  int kcal,
  int goal,
  Color themeAccentColor,
) {
  // final purple = charts.MaterialPalette.purple.shadeDefault;
  final purple = charts.ColorUtil.fromDartColor(themeAccentColor);
  final grey = charts.MaterialPalette.gray.shade300;

  goal -= kcal;
  if (goal < 0) {
    goal = 0;
  }

  if (kcal == 0) {
    final data = [new GaugeSegment('Random', 1)];

    return [
      new charts.Series<GaugeSegment, String>(
          id: 'Segments',
          domainFn: (GaugeSegment segment, _) => segment.segment,
          measureFn: (GaugeSegment segment, _) => segment.size,
          data: data,
          colorFn: (GaugeSegment segment, _) {
            switch (segment.segment) {
              case 'KCAL':
                return purple;
                break;
              case 'GOAL':
                return grey;
                break;
              default:
                return grey;
                break;
            }
          })
    ];
  } else {
    List<GaugeSegment> data = [
      new GaugeSegment('KCAL', kcal.round()),
    ];
    if (goal > 0) {
      data = [
        new GaugeSegment('KCAL', kcal.round()),
        new GaugeSegment('GOAL', goal.round()),
      ];
    }
    return [
      new charts.Series<GaugeSegment, String>(
          id: 'Segments',
          domainFn: (GaugeSegment segment, _) => segment.segment,
          measureFn: (GaugeSegment segment, _) => segment.size,
          data: data,
          colorFn: (GaugeSegment segment, _) {
            switch (segment.segment) {
              case 'KCAL':
                return purple;
                break;
              case 'GOAL':
                return grey;
                break;
              default:
                return grey;
                break;
            }
          })
    ];
  }
}

class GaugeSegment {
  final String segment;
  final int size;

  GaugeSegment(this.segment, this.size);
}
