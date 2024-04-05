import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DateTimeProvider extends ChangeNotifier {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  DateTime? get selectedDate => _selectedDate;
  TimeOfDay? get selectedTime => _selectedTime;

  void setDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  void setTime(TimeOfDay time) {
    _selectedTime = time;
    notifyListeners();
  }
}

final dateTimeProvider =
    ChangeNotifierProvider<DateTimeProvider>((ref) => DateTimeProvider());
