import 'dart:convert';

import 'package:flutter/widgets.dart';
import "../models/current_data.dart";
import 'package:http/http.dart' as http;

import '../models/custome_models.dart';

String openWeatherMapey = "957252df48b4072773ff5ac52b256ab7";

String mapBoxKey =
    "pk.eyJ1IjoicHJhdmVlbmFhbmFuZDIyIiwiYSI6ImNqdWJjM2M5YjBhemM0MnBjM2xmcnVnaG4ifQ.F2CMI34BYsWhUkhxwDrYiA";

enum CurrentPage { home, search, settings, about }

class CommonState extends ChangeNotifier {
  CurrentData _currentData = CurrentData();
  bool _isDrawerOpen = false;
  CurrentPage _currentPage = CurrentPage.home;
  Location _selectedLoc = Location();

  set currentData(CurrentData val) {
    _currentData = val;
    notifyListeners();
  }

  set currentPage(CurrentPage val) {
    _currentPage = val;
    notifyListeners();
  }

  set isDrawerOpen(bool val) {
    _isDrawerOpen = val;
    notifyListeners();
  }

  set selectedLoc(Location val) {
    _selectedLoc = val;
    notifyListeners();
  }

  CurrentData get currentData => _currentData;
  CurrentPage get currentPage => _currentPage;
  bool get isDrawerOpen => _isDrawerOpen;
  Location get selectedLoc => _selectedLoc;

  Future<String> getWeatherData() async {
    if (selectedLoc.lon == null) return "please select a location";
    final response = await http.get(Uri.parse(
        "https://api.openweathermap.org/data/2.5/onecall?lat=${selectedLoc.lat}&lon=${selectedLoc.lon}&appid=$openWeatherMapey&units=metric"));
    if (response.statusCode == 200) {
      currentData = CurrentData.fromJson(json.decode(response.body));
      return "s";
      // print(json.decode(response.body));
    } else {
      print(response.body);
      return "f";
    }
  }

  Future<SearchResluts> locationSearch(String query) async {
    final response = await http.get(Uri.parse(
        "https://api.mapbox.com/geocoding/v5/mapbox.places/$query.json?proximity=ip&types=place%2Cpostcode%2Caddress&access_token=$mapBoxKey"));
    print(response.body);
    if (response.statusCode == 200) {
      return SearchResluts.fromJson(json.decode(response.body));
    } else {
      return SearchResluts();
    }
  }
}
