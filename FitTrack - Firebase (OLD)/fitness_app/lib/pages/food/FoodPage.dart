import 'dart:math';

import 'package:fitness_app/models/food/Nutrition.dart';
import 'package:fitness_app/models/settings/Settings.dart';
import 'package:fitness_app/pages/food/FoodAddPage.dart';
import 'package:fitness_app/shared/Loading.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:provider/provider.dart';

class FoodPage extends StatefulWidget {
  @override
  _FoodPageState createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage> {
  bool loading = true;

  // Fix error: setState() called after dispose()
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    Nutrition nutrition = Provider.of<Nutrition>(context) ?? Nutrition();
    UserSettings settings = Provider.of<UserSettings>(context) ?? null;

    if (nutrition != null && settings != null && loading) {
      Future.delayed(
        Duration(seconds: 1),
        () => {
          setState(() {
            loading = false;
          }),
        },
      );
    }

    return loading
        ? Loading()
        : ScrollConfiguration(
            behavior: ScrollBehavior(),
            child: CustomScrollView(
              slivers: [
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
                    height: MediaQuery.of(context).size.width,
                    child: KcalWidget(
                      kcal: nutrition.kcal,
                      kcalGoal: settings.nutritionGoals != null
                          ? settings.nutritionGoals['kcal']
                          : 0,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    height: MediaQuery.of(context).size.width / 2.0,
                    child: MacroWidget(
                      carbs: nutrition.carbs,
                      carbsGoal: settings.nutritionGoals != null
                          ? settings.nutritionGoals['carbs']
                          : 0,
                      protein: nutrition.protein,
                      proteinGoal: settings.nutritionGoals != null
                          ? settings.nutritionGoals['protein']
                          : 0,
                      fat: nutrition.fat,
                      fatGoal: settings.nutritionGoals != null
                          ? settings.nutritionGoals['fat']
                          : 0,
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}

class KcalWidget extends StatelessWidget {
  final int kcal;
  final int kcalGoal;

  KcalWidget({this.kcal = 0, this.kcalGoal = 0});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width,
            child: GaugeChart(
              _createData(kcal, kcalGoal, Theme.of(context).accentColor),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 50.0),
                Text(
                  kcal.toString(),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50.0),
                ),
                Text(
                  kcalGoal > 0 ? 'OF $kcalGoal KCAL' : 'KCAL',
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
                        builder: (BuildContext context) => FoodAddPage(),
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MacroWidget extends StatelessWidget {
  // Get Macro's
  final int carbs;
  final int protein;
  final int fat;

  final int carbsGoal;
  final int proteinGoal;
  final int fatGoal;

  MacroWidget({
    this.carbs = 0,
    this.protein = 0,
    this.fat = 0,
    this.carbsGoal = 0,
    this.proteinGoal = 0,
    this.fatGoal = 0,
  });

  @override
  Widget build(BuildContext context) {
    // Row of 3 gaugecharts of each macro
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
                        _createData(
                            carbs, carbsGoal, Theme.of(context).accentColor),
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
                        _createData(protein, proteinGoal,
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
                        _createData(
                            fat, fatGoal, Theme.of(context).accentColor),
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
    int kcal, int goal, Color themeAccentColor) {
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
