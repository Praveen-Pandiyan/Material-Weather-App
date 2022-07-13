import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/providers/common_state.dart';

import '../components/resizeable_container.dart';
import 'package:fl_chart/fl_chart.dart';

import '../components/secondary_weather_data.dart';
import '../components/sliding_drawer.dart';
import 'dart:math';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isDrawerOpen = false, isFirst = true;
  Map<int, int> chartData = {};
  late CommonState _commonState;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CommonState _commonState = Provider.of<CommonState>(context);
    if (_commonState != null && isFirst) {
      _commonState.getWeatherData().then((value) {
        setState(() {
          isFirst = false;
        });
      });
    }

    return SlidingDrawer(
      isOpen: isDrawerOpen,
      onCloseDrawer: () => setState(() {
        isDrawerOpen = false;
      }),
      drawer: Column(
        children: List.generate(10, (index) => Text("$index")),
      ),
      // to-do , show error msg from api
      child: !isFirst
          ? Scaffold(
              backgroundColor: Theme.of(context).backgroundColor,
              body: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SafeArea(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            isDrawerOpen = !isDrawerOpen;
                          });
                        },
                        child: Icon(Icons.menu),
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    const ResizeableContainer(),
                    const SizedBox(
                      height: 10,
                    ),
                    const SecondaryData(),
                    Text(
                      "In Next 1 Hour",
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    if (_commonState.currentData.minutely?.first != null)
                      TemperatureChart(
                        chartData: _commonState.currentData.minutely
                                ?.map((e) => e.precipitation ?? 0)
                                .toList() ??
                            [],
                      ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "In Next 48 Hours",
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    if (_commonState.currentData.hourly?.first != null)
                      TemperatureChart(
                        chartData: _commonState.currentData.hourly
                                ?.map((e) => e.temp ?? 0)
                                .toList() ??
                            [],
                      ),
                  ],
                ),
              ),
            )
          : const CircularProgressIndicator(),
    );
  }
}

class TemperatureChart extends StatefulWidget {
  final List<num> chartData;

  const TemperatureChart({Key? key, required this.chartData}) : super(key: key);

  @override
  State<TemperatureChart> createState() => _TemperatureChartState();
}

class _TemperatureChartState extends State<TemperatureChart> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: Colors.white,
            boxShadow: [BoxShadow(blurRadius: 1.0)]),
        width: MediaQuery.of(context).size.width,
        child: DefaultTextStyle(
          style: TextStyle(color: Colors.black, fontSize: 6.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
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
                        curveSmoothness: .01,
                        gradient: LinearGradient(
                            colors: [Colors.red, Colors.orange],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter),
                        barWidth: 2,
                        isStrokeCapRound: true,
                        dotData: FlDotData(show: false),
                        belowBarData: BarAreaData(show: false),
                        spots: [
                          ...widget.chartData.asMap().entries.map((e) =>
                              FlSpot(e.key.toDouble(), e.value.toDouble()))
                        ],
                      ),
                    ],
                    maxY: widget.chartData.reduce(max).toDouble() + 2,
                    minY: widget.chartData.reduce(min).toDouble() - 2,
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
                      Duration(milliseconds: 150), // Optional
                  swapAnimationCurve: Curves.linear, // Optional
                ),
              ),
            ],
          ),
        ));
  }
}
