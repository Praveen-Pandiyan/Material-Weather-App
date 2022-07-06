import 'package:flutter/material.dart';

import '../components/resizeable_container.dart';
import 'package:fl_chart/fl_chart.dart';

import '../components/sliding_drawer.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isDrawerOpen = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SlidingDrawer(
      isOpen: isDrawerOpen,
      onCloseDrawer: () => setState(() {
        isDrawerOpen = false;
      }),
      drawer: Column(
        children: List.generate(10, (index) => Text("$index")),
      ),
      child: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
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
              const SizedBox(
                height: 10.0,
              ),
              const ResizeableContainer(),
              const TemperatureChart()
            ],
          ),
        ),
      ),
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
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: Colors.blue.shade600,
        ),
        height: 100,
        width: MediaQuery.of(context).size.width,
        child: LineChart(
          LineChartData(
              // read about it in the LineChartData section

              ),
          swapAnimationDuration: Duration(milliseconds: 150), // Optional
          swapAnimationCurve: Curves.linear, // Optional
        ));
  }
}
