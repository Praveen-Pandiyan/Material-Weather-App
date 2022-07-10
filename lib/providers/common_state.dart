import 'dart:convert';

import 'package:flutter/widgets.dart';
import "../models/current_data.dart";
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';

class CommonState extends ChangeNotifier {
  CurrentData _currentData = CurrentData();

  set currentData(CurrentData val) {
    _currentData = val;
  }

  CurrentData get currentData => _currentData;

  Future<void> getWeatherData() async {
    final response = await http.get(Uri.parse(
        "https://api.openweathermap.org/data/2.5/onecall?lat=10.8029&lon=78.6988&appid=957252df48b4072773ff5ac52b256ab7&units=metric"));
    if (response.statusCode == 200) {
      currentData = CurrentData.fromJson(json.decode(response.body));
      // print(json.decode(response.body));
    } else {
      print(response.body);
    }
  }
}
