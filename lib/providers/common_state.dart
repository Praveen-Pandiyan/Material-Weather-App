import 'package:flutter/widgets.dart';
import "../models/current_data.dart";
import 'package:http/http.dart' as http;

class CommonState extends ChangeNotifier {
  CurrentData _currentData = CurrentData();

  set currentData(CurrentData val) {
    _currentData = val;
  }

  CurrentData get currentData => _currentData;

  void getWeatherData() {
    http.get(Uri.parse(""));
  }
}
