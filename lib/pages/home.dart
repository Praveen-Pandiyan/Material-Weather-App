import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/providers/common_state.dart';

import '../components/resizeable_container.dart';
import 'package:fl_chart/fl_chart.dart';

import '../components/secondary_weather_data.dart';
import '../components/sliding_drawer.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isDrawerOpen = false, isFirst = true;
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
                        child: Text(
                          "Today",
                          style: Theme.of(context).textTheme.headline2,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    const ResizeableContainer(),
                    const SecondaryData(),
                    const TemperatureChart(),
                  ],
                ),
              ),
            )
          : const CircularProgressIndicator(),
    );
  }
}

class TemperatureChart extends StatefulWidget {
  const TemperatureChart({Key? key}) : super(key: key);

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
            boxShadow: [BoxShadow(blurRadius: 2.0)]),
        width: MediaQuery.of(context).size.width,
        child: DefaultTextStyle(
          style: TextStyle(color: Colors.black, fontSize: 6.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Temperature",
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
                      enabled: true,
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
                        curveSmoothness: .5,
                        gradient:
                            LinearGradient(colors: [Colors.red, Colors.orange]),
                        barWidth: 2,
                        isStrokeCapRound: true,
                        dotData: FlDotData(show: false),
                        belowBarData: BarAreaData(show: false),
                        spots: const [
                          FlSpot(1, 1),
                          FlSpot(3, 4),
                          FlSpot(5, 1.8),
                          FlSpot(7, 5),
                          FlSpot(10, 2),
                          FlSpot(12, 2.2),
                          FlSpot(13, 1.8),
                        ],
                      ),
                    ],
                    minX: 0,
                    maxX: 14,
                    maxY: 6,
                    minY: 0,
                    titlesData: FlTitlesData(
                      show: true,
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 3,
                          reservedSize: 10,
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
