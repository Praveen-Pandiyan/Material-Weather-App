import "package:flutter/material.dart";
import 'package:provider/provider.dart';

import '../providers/common_state.dart';

class SecondaryData extends StatefulWidget {
  const SecondaryData({super.key});

  @override
  State<SecondaryData> createState() => _SecondaryDataState();
}

class _SecondaryDataState extends State<SecondaryData> {
  @override
  Widget build(BuildContext context) {
    CommonState commonState = Provider.of<CommonState>(context);
    return Container(
      padding: const EdgeInsets.all(8.0),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: const [BoxShadow(blurRadius: 2.0, color: Colors.grey)]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Details",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          Table(
            children: [
              TableRow(children: [
                _WeatherData(
                  title: "humidity",
                  icons: Icons.water_drop_outlined,
                  iconColor: Colors.blueAccent,
                  value: commonState.currentData.current!.humidity.toString(),
                ),
                _WeatherData(
                  title: "Pressure",
                  icons: Icons.speed,
                  iconColor: Colors.redAccent,
                  value: commonState.currentData.current!.pressure.toString(),
                ),
              ]),
              TableRow(children: [
                _WeatherData(
                  title: "Wind",
                  icons: Icons.wind_power,
                  iconColor: Colors.lightGreen,
                  value: commonState.currentData.current!.windSpeed.toString(),
                ),
                _WeatherData(
                  title: "UV index",
                  icons: Icons.sunny,
                  iconColor: Colors.orange,
                  value: commonState.currentData.current!.uvi.toString(),
                ),
              ])
            ],
          ),
        ],
      ),
    );
  }
}

class _WeatherData extends StatelessWidget {
  final String title, value;
  final IconData icons;
  final Color iconColor;
  const _WeatherData(
      {required this.icons,
      required this.title,
      required this.value,
      this.iconColor = Colors.black});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            (icons),
            color: iconColor,
          ),
          Column(
            children: [
              Text(
                title,
                style: const TextStyle(
                    color: Colors.black38,
                    fontWeight: FontWeight.w400,
                    fontSize: 12.0),
              ),
              Text(
                value,
                style: const TextStyle(color: Colors.black),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
