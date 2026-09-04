import 'package:flutter/material.dart';
import 'package:akuhadir/core/utils/date_formatter.dart';import 'package:akuhadir/data/models/attendance_model.dart';import 'package:akuhadir/data/repositories/attendance_repository.dart';
class HistoryProvider extends ChangeNotifier {
  final AttendanceRepository _repository = AttendanceRepository();

  List<AttendanceModel> _historyList = [];
  bool _isLoading = false;
  String? _errorMessage;
  DateTime _currentMonth = DateTime.now();

  List<AttendanceModel> get historyList => _historyList;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  DateTime get currentMonth => _currentMonth;

  HistoryProvider() {
    loadHistory();
  }

  Future<void> loadHistory() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final start = DateTime(_currentMonth.year, _currentMonth.month, 1);
      final end = DateTime(_currentMonth.year, _currentMonth.month + 1, 0);

      _historyList = await _repository.getHistory(
        startDate: DateFormatter.formatApiDate(start),
        endDate: DateFormatter.formatApiDate(end),
      );
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
    }
  }

  void changeMonth(DateTime newMonth) {
    _currentMonth = newMonth;
    loadHistory();
  }

  Future<bool> deleteAttendance(int id) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _repository.deleteAttendance(id);
      _historyList.removeWhere((item) => item.id == id);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
