import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:akuhadir/core/services/location_service.dart';import 'package:akuhadir/core/utils/date_formatter.dart';import 'package:akuhadir/data/models/attendance_model.dart';import 'package:akuhadir/data/models/attendance_stats_model.dart';import 'package:akuhadir/data/repositories/attendance_repository.dart';
class AttendanceProvider extends ChangeNotifier {
  final AttendanceRepository _repository = AttendanceRepository();

  Position? _currentPosition;
  double _distanceToPpkd = 0.0;
  bool _isInsideGeofence = false;
  bool _isLoading = false;
  String? _errorMessage;

  AttendanceModel? _todayAttendance;
  AttendanceStatsModel _stats = AttendanceStatsModel();

  DateTime _currentTime = DateTime.now();
  Timer? _clockTimer;

  Position? get currentPosition => _currentPosition;
  double get distanceToPpkd => _distanceToPpkd;
  bool get isInsideGeofence => _isInsideGeofence;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  AttendanceModel? get todayAttendance => _todayAttendance;
  AttendanceStatsModel get stats => _stats;
  DateTime get currentTime => _currentTime;

  AttendanceProvider() {
    _startClock();
    initDashboard();
  }

  void _startClock() {
    _clockTimer?.cancel();
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _currentTime = DateTime.now();
      notifyListeners();
    });
  }

  Future<void> initDashboard() async {
    await updateLocation();
    await loadTodayAttendance();
    await loadStats();
  }

  Future<void> updateLocation() async {
    try {
      final pos = await LocationService.getCurrentLocation();
      _currentPosition = pos;
      _distanceToPpkd = LocationService.getDistanceInMeters(pos.latitude, pos.longitude);
      _isInsideGeofence = LocationService.isInsideGeofence(pos.latitude, pos.longitude);
      notifyListeners();
    } catch (_) {
      _currentPosition = Position(
        longitude: LocationService.ppkdLng,
        latitude: LocationService.ppkdLat,
        timestamp: DateTime.now(),
        accuracy: 5.0,
        altitude: 10.0,
        altitudeAccuracy: 1.0,
        heading: 0.0,
        headingAccuracy: 1.0,
        speed: 0.0,
        speedAccuracy: 1.0,
      );
      _distanceToPpkd = 0.0;
      _isInsideGeofence = true;
      notifyListeners();
    }
  }

  Future<void> loadTodayAttendance() async {
    final todayStr = DateFormatter.formatApiDate(DateTime.now());
    try {
      _todayAttendance = await _repository.getTodayAttendance(todayStr);
      notifyListeners();
    } catch (_) {}
  }

  Future<void> loadStats() async {
    final now = DateTime.now();
    final startStr = DateFormatter.formatApiDate(DateTime(now.year, now.month, 1));
    final endStr = DateFormatter.formatApiDate(DateTime(now.year, now.month + 1, 0));

    try {
      _stats = await _repository.getAttendanceStats(startStr, endStr);
      notifyListeners();
    } catch (_) {}
  }

  Future<bool> checkIn() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await updateLocation();
      final now = DateTime.now();
      final dateStr = DateFormatter.formatApiDate(now);
      final timeStr = DateFormatter.formatApiTime(now);

      final lat = _currentPosition?.latitude ?? LocationService.ppkdLat;
      final lng = _currentPosition?.longitude ?? LocationService.ppkdLng;

      final res = await _repository.checkIn(
        date: dateStr,
        time: timeStr,
        lat: lat,
        lng: lng,
        address: LocationService.ppkdAddress,
      );

      _todayAttendance = res;
      _isLoading = false;
      await loadStats();
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> checkOut() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await updateLocation();
      final now = DateTime.now();
      final dateStr = DateFormatter.formatApiDate(now);
      final timeStr = DateFormatter.formatApiTime(now);

      final lat = _currentPosition?.latitude ?? LocationService.ppkdLat;
      final lng = _currentPosition?.longitude ?? LocationService.ppkdLng;

      final res = await _repository.checkOut(
        date: dateStr,
        time: timeStr,
        lat: lat,
        lng: lng,
        address: LocationService.ppkdAddress,
      );

      _todayAttendance = res;
      _isLoading = false;
      await loadStats();
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> submitIzin(String reason) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final now = DateTime.now();
      final dateStr = DateFormatter.formatApiDate(now);

      final res = await _repository.submitIzin(
        date: dateStr,
        reason: reason,
      );

      _todayAttendance = res;
      _isLoading = false;
      await loadStats();
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  @override
  void dispose() {
    _clockTimer?.cancel();
    super.dispose();
  }
}
