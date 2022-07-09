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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(Icons.water_drop_rounded),
              Text("Air Quality"),
            ],
          ),
          Table(
            children: [
              TableRow(children: [
                _WeatherData(
                  text: "humidity",
                  icons: Icons.water_drop_outlined,
                ),
                _WeatherData(
                  text: "Pressure",
                  icons: Icons.water_drop_outlined,
                ),
              ]),
              TableRow(children: [
                _WeatherData(
                  text: "humidity",
                  icons: Icons.water_drop_outlined,
                ),
                _WeatherData(
                  text: "humidity",
                  icons: Icons.water_drop_outlined,
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
  final String text;
  final IconData icons;
  const _WeatherData({required this.icons, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Row(
        children: [
          Icon((icons)),
          Text(
            text,
            style: const TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }
}
