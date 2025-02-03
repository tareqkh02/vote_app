import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class DateTimeProvider with ChangeNotifier {
  DateTime? _startDateTime;
  DateTime? _endDateTime;

  DateTime? get startDateTime => _startDateTime;
  DateTime? get endDateTime => _endDateTime;

  void setStartDateTime(DateTime date, TimeOfDay time) {
    _startDateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    notifyListeners();
  }

  void setEndDateTime(DateTime date, TimeOfDay time) {
    _endDateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    notifyListeners();
  }

  Duration getRemainingTime() {
    if (_endDateTime == null) return Duration.zero;
    return _endDateTime!.difference(DateTime.now());
  }
}



class ElectionProvider with ChangeNotifier {
  String _electionName = '';

  String get electionName => _electionName;

  void setElectionName(String name) {
    _electionName = name;
    notifyListeners();
  }
}