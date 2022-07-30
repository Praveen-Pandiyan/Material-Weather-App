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
                  lat: 28.613895,
                  lon: 77.209006,
                  name: "New Delhi",
                  secondaryName: "Delhi");
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      commonState.isDrawerOpen = true;
                                    });
                                    widget.triggerDrawer!(true);
                                  },
                                  icon: const Icon(Icons.menu),
                                ),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      commonState.currentPage =
                                          CurrentPage.search;
                                    });
                                  },
                                  icon: const Icon(Icons.search),
                                ),
                              ],
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
                      title: "Next 48 hours",
                      hourly: commonState.currentData.hourly,
                    ),
                  if (commonState.currentData.daily?.first != null)
                    TonggleChart(
                      title: "Next 4 days",
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

enum Toggle { temp, clouds, pressure }

class ToggleOptions {
  String title;
  Toggle option;
  IconData icons;
  ToggleOptions(
      {required this.title, required this.option, required this.icons});
}

class _TonggleChartState extends State<TonggleChart> {
  static List<ToggleOptions> options = [
    ToggleOptions(
        title: "Temperature",
        option: Toggle.temp,
        icons: Icons.thermostat_rounded),
    ToggleOptions(title: "Clouds", option: Toggle.clouds, icons: Icons.cloud),
    ToggleOptions(
        title: "Pressure", option: Toggle.pressure, icons: Icons.speed_rounded),
  ];
  ToggleOptions selectOption = options.first;
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        widget.title,
        style: Theme.of(context).textTheme.headline4,
      ),
      Container(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: Colors.white,
            boxShadow: const [BoxShadow(blurRadius: 1.0)]),
        child: Column(
          children: [
            Row(
                children: options
                    .map((e) => InkWell(
                          onTap: () {
                            setState(() {
                              selectOption = e;
                            });
                          },
                          child: Row(
                            children: [Icon(e.icons), Text(e.title)],
                          ),
                        ))
                    .toList()),
            TemperatureChart(
              chartData: () {
                if (widget.daily != null) {
                  return widget.daily!.map((e) => e.temp!.day).toList()
                      as List<num?>;
                } else if (widget.hourly != null) {
                  switch (selectOption.option) {
                    case Toggle.temp:
                      return widget.hourly!.map((e) => e.temp).toList();
                    case Toggle.clouds:
                      return widget.hourly!.map((e) => e.clouds).toList();
                    case Toggle.pressure:
                      return widget.hourly!.map((e) => e.pressure).toList();
                    default:
                      return widget.hourly!.map((e) => e.clouds).toList();
                  }
                } else {
                  return [] as List<num>;
                }
              }(),
            ),
          ],
        ),
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
    return SizedBox(
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
                          reservedSize: 20,
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
