import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/models/custome_models.dart';
import 'package:weather_app/providers/common_state.dart';

import '../components/resizeable_container.dart';
import 'package:fl_chart/fl_chart.dart';

import '../components/secondary_weather_data.dart';
import '../models/current_data.dart';

class MyHomePage extends StatefulWidget {
  final Function(bool)? triggerDrawer;
  const MyHomePage({Key? key, this.triggerDrawer}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isFirst = true;
  Map<int, int> chartData = {};
  final LocalStorage storage = LocalStorage('search');
  late CommonState commonState;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    commonState = Provider.of<CommonState>(context);
    if (isFirst) {
      if (commonState.selectedLoc.name == null) {
        storage.ready.then((value) {
          if (value) {
            var temp = storage.getItem("lastSearch");
            print(temp.toString() + "fff");
            if (temp == null) {
              commonState.selectedLoc = Location(
                  lat: 29.949932,
                  lon: -90.070116,
                  name: "Orleans Parish",
                  secondaryName: "");
            } else {
              commonState.selectedLoc = Location.fromJson(jsonDecode(temp));
            }
          }
        });
      }
      if (commonState.selectedLoc.name != null) {
        commonState.getWeatherData().then((value) {});
        isFirst = false;
      }
    }

    return !isFirst
        ? Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MediaQuery.removePadding(
                    context: context,
                    child: Container(
                      color: Colors.blueAccent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SafeArea(
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  commonState.isDrawerOpen = true;
                                });
                                widget.triggerDrawer!(true);
                              },
                              icon: const Icon(Icons.menu),
                            ),
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          const ResizeableContainer(),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const SecondaryData(),
                  Text(
                    "In Next 1 Hour",
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  if (commonState.currentData.minutely?.first != null)
                    TemperatureChart(
                      chartData: commonState.currentData.minutely
                              ?.map((e) => e.precipitation ?? 0)
                              .toList() ??
                          [],
                    ),
                  const SizedBox(
                    height: 10,
                  ),
                  if (commonState.currentData.daily?.first != null)
                    TonggleChart(
                      title: "Next",
                      hourly: commonState.currentData.hourly,
                    ),
                  if (commonState.currentData.daily?.first != null)
                    TonggleChart(
                      title: "Next",
                      daily: commonState.currentData.daily,
                    ),
                ],
              ),
            ),
          )
        : const CircularProgressIndicator();
  }
}

class TonggleChart extends StatefulWidget {
  final String title;
  final List<Hourly>? hourly;
  final List<Daily>? daily;
  const TonggleChart({
    Key? key,
    this.hourly,
    this.daily,
    required this.title,
  }) : super(key: key);

  @override
  State<TonggleChart> createState() => _TonggleChartState();
}

class _TonggleChartState extends State<TonggleChart> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(
        widget.title,
        style: Theme.of(context).textTheme.headline4,
      ),
      TemperatureChart(
        chartData: () {
          if (widget.daily != null) {
            return widget.daily!.map((e) => e.temp!.day).toList() as List<num?>;
          } else if (widget.hourly != null) {
            return widget.hourly!.map((e) => e.temp).toList() as List<num?>;
          } else {
            return [] as List<num>;
          }
        }(),
      )
    ]);
  }
}

class TemperatureChart extends StatefulWidget {
  final List<num?> chartData;

  const TemperatureChart({Key? key, required this.chartData}) : super(key: key);

  @override
  State<TemperatureChart> createState() => _TemperatureChartState();
}

class _TemperatureChartState extends State<TemperatureChart> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: Colors.white,
            boxShadow: const [BoxShadow(blurRadius: 1.0)]),
        width: MediaQuery.of(context).size.width,
        child: DefaultTextStyle(
          style: const TextStyle(color: Colors.black, fontSize: 6.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Temperature Trend",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0),
              ),
              SizedBox(
                height: 200,
                child: LineChart(
                  LineChartData(
                    lineTouchData: LineTouchData(
                      enabled: false,
                    ),
                    gridData: FlGridData(show: false),
                    borderData: FlBorderData(
                      show: false,
                      border: const Border(
                        bottom: BorderSide(color: Color(0xff4e4965), width: 1),
                        left: BorderSide(color: Color(0xff4e4965), width: 1),
                        right: BorderSide(color: Colors.transparent),
                        top: BorderSide(color: Colors.transparent),
                      ),
                    ),
                    baselineX: 30,
                    lineBarsData: [
                      LineChartBarData(
                        isCurved: true,
                        curveSmoothness: 0.5,
                        gradient: const LinearGradient(
                            colors: [Colors.red, Colors.orange],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter),
                        barWidth: 2,
                        isStrokeCapRound: true,
                        dotData: FlDotData(show: false),
                        belowBarData: BarAreaData(show: false),
                        spots: [
                          ...widget.chartData.asMap().entries.map((e) =>
                              FlSpot(e.key.toDouble(), e.value!.toDouble()))
                        ],
                      ),
                    ],
                    titlesData: FlTitlesData(
                      show: true,
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 1,
                          reservedSize: 15,
                        ),
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: false,
                        ),
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: false,
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 1,
                          reservedSize: 20,
                        ),
                      ),
                    ),
                  ),

                  swapAnimationDuration:
                      const Duration(milliseconds: 150), // Optional
                  swapAnimationCurve: Curves.linear, // Optional
                ),
              ),
            ],
          ),
        ));
  }
}
