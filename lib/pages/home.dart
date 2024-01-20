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
  const MyHomePage({super.key, this.triggerDrawer});

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

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: (!isFirst && commonState.currentData.current != null)
          ? SingleChildScrollView(
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
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                    ),
                    child: Column(
                      children: [
                        const SecondaryData(),
                        // Text(
                        //   "In Next 1 Hour",
                        //   style: Theme.of(context).textTheme.headline4,
                        // ),
                        // if (commonState.currentData.minutely?.first != null)
                        //   TemperatureChart(
                        //     chartData: commonState.currentData.minutely
                        //             ?.map((e) => e.precipitation ?? 0)
                        //             .toList() ??
                        //         [],
                        //   ),
                        const SizedBox(
                          height: 16,
                        ),
                        if (commonState.currentData.daily?.first != null)
                          TonggleChart(
                            title: "Next 48 hours",
                            hourly: commonState.currentData.hourly,
                          ),
                        const SizedBox(
                          height: 16,
                        ),
                        if (commonState.currentData.daily?.first != null)
                          TonggleChart(
                            title: "Next 4 days",
                            daily: commonState.currentData.daily,
                          ),
                      ],
                    ),
                  )
                ],
              ),
            )
          : Container(
              alignment: Alignment.center,
              color: Colors.white,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: Colors.blue,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Loading...")
                ],
              )),
    );
  }
}

class TonggleChart extends StatefulWidget {
  final String title;
  final List<Hourly>? hourly;
  final List<Daily>? daily;
  const TonggleChart({
    super.key,
    this.hourly,
    this.daily,
    required this.title,
  });

  @override
  State<TonggleChart> createState() => _TonggleChartState();
}

enum Toggle { temp, clouds, pressure }

class ToggleOptions {
  String title;
  Toggle option;
  IconData icons;
  List<Color> listColor;
  ToggleOptions(
      {required this.title,
      required this.option,
      required this.icons,
      this.listColor = const [Colors.orange, Colors.red]});
}

class _TonggleChartState extends State<TonggleChart> {
  static List<ToggleOptions> options = [
    ToggleOptions(
        title: "Temperature",
        option: Toggle.temp,
        icons: Icons.thermostat_rounded,
        listColor: [Colors.red, Colors.orange]),
    ToggleOptions(
        title: "Clouds",
        option: Toggle.clouds,
        icons: Icons.cloud,
        listColor: [Colors.purple, Colors.blue]),
    ToggleOptions(
        title: "Pressure",
        option: Toggle.pressure,
        icons: Icons.speed_rounded,
        listColor: [Colors.green, const Color.fromARGB(255, 182, 166, 23)]),
  ];
  ToggleOptions selectOption = options.first;
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        widget.title,
        style: Theme.of(context).textTheme.headlineMedium,
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
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 7.0, vertical: 2.5),
                            margin: const EdgeInsets.symmetric(horizontal: 3.0),
                            decoration: BoxDecoration(
                                gradient: LinearGradient(colors: e.listColor),
                                borderRadius: BorderRadius.circular(20.0)),
                            child: Row(
                              children: [
                                Icon(
                                  e.icons,
                                  size: 13.0,
                                  color: Colors.white,
                                ),
                                const SizedBox(
                                  width: 7.0,
                                ),
                                Text(
                                  e.title,
                                  style: const TextStyle(
                                    fontSize: 13.0,
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ))
                    .toList()),
            TemperatureChart(
              chartData: () {
                if (widget.daily != null) {
                  switch (selectOption.option) {
                    case Toggle.temp:
                      return ChartData(
                          data: widget.daily!.map((e) => e.temp!.day).toList(),
                          colorList: selectOption.listColor);
                    case Toggle.clouds:
                      return ChartData(
                          data: widget.daily!.map((e) => e.clouds).toList(),
                          colorList: selectOption.listColor);
                    case Toggle.pressure:
                      return ChartData(
                          data: widget.daily!.map((e) => e.pressure).toList(),
                          colorList: selectOption.listColor);
                    default:
                      return ChartData(
                          data: widget.daily!.map((e) => e.temp!.day).toList(),
                          colorList: []);
                  }
                } else if (widget.hourly != null) {
                  switch (selectOption.option) {
                    case Toggle.temp:
                      return ChartData(
                          data: widget.hourly!.map((e) => e.temp).toList(),
                          colorList: selectOption.listColor);
                    case Toggle.clouds:
                      return ChartData(
                          data: widget.hourly!.map((e) => e.clouds).toList(),
                          colorList: selectOption.listColor);
                    case Toggle.pressure:
                      return ChartData(
                          data: widget.hourly!.map((e) => e.pressure).toList(),
                          colorList: selectOption.listColor);
                    default:
                      return ChartData(
                          data: widget.hourly!.map((e) => e.temp).toList(),
                          colorList: []);
                  }
                } else {
                  return ChartData(
                    data: widget.hourly!.map((e) => e.temp).toList(),
                  );
                  
                }
              }(),
            ),
          ],
        ),
      )
    ]);
  }
}

//model class

class ChartData {
  final List<num?> data;
  final List<Color> colorList;
  ChartData(
      {required this.data, this.colorList = const [Colors.orange, Colors.red]});
}

class TemperatureChart extends StatefulWidget {
  final ChartData chartData;

  const TemperatureChart({super.key, required this.chartData});

  @override
  State<TemperatureChart> createState() => _TemperatureChartState();
}

class _TemperatureChartState extends State<TemperatureChart> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(top: 30.0),
        width: MediaQuery.of(context).size.width,
        child: DefaultTextStyle(
          style: const TextStyle(color: Colors.black, fontSize: 6.0),
          child: SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                lineTouchData: const LineTouchData(
                  enabled: true,
                ),
                gridData: const FlGridData(show: false),
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
                    gradient: LinearGradient(
                        colors: widget.chartData.colorList,
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter),
                    barWidth: 2,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(show: false),
                    spots: [
                      ...widget.chartData.data.asMap().entries.map(
                          (e) => FlSpot(e.key.toDouble(), e.value!.toDouble()))
                    ],
                  ),
                ],
                titlesData: const  FlTitlesData(
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

              duration:
                  const Duration(milliseconds: 150), // Optional
              curve: Curves.linear, // Optional
            ),
          ),
        ));
  }
}
