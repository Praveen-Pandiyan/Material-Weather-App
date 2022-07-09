import "package:flutter/material.dart";
import 'package:provider/provider.dart';

import '../providers/common_state.dart';

class SecondaryData extends StatefulWidget {
  const SecondaryData({Key? key}) : super(key: key);

  @override
  State<SecondaryData> createState() => _SecondaryDataState();
}

class _SecondaryDataState extends State<SecondaryData> {
  late CommonState _commonState;
  @override
  Widget build(BuildContext context) {
    CommonState _commonState = Provider.of<CommonState>(context);
    return Container(
      padding: const EdgeInsets.all(8.0),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [const BoxShadow(blurRadius: 2.0, color: Colors.grey)]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Details",
            style: Theme.of(context).textTheme.headline4,
          ),
          Table(
            children: [
              TableRow(children: [
                _WeatherData(
                  title: "humidity",
                  icons: Icons.water_drop_outlined,
                  value: "36",
                ),
                _WeatherData(
                  title: "Pressure",
                  icons: Icons.water_drop_outlined,
                  value: "36",
                ),
              ]),
              TableRow(children: [
                _WeatherData(
                  title: "humidity",
                  icons: Icons.water_drop_outlined,
                  value: "36",
                ),
                _WeatherData(
                  title: "humidity",
                  icons: Icons.water_drop_outlined,
                  value: "36",
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
  const _WeatherData(
      {required this.icons, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon((icons)),
          Column(
            children: [
              Text(
                title,
                style: const TextStyle(
                    color: Colors.black38,
                    fontWeight: FontWeight.w400,
                    fontSize: 10.0),
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
