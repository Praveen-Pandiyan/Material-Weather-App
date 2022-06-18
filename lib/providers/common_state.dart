import 'package:flutter/widgets.dart';
import "package:provider/provider.dart";
import "../models/current_data.dart";

class CommonState extends ChangeNotifier {
  late CurrentData _currentData;

  set currentData(CurrentData val) {
    _currentData = val;
  }

  CurrentData get currentData => _currentData;
}
