import 'package:AbsenDulu/core/constants/api_endpoints.dart';
import 'package:AbsenDulu/core/network/api_client.dart';
import 'package:AbsenDulu/data/models/attendance_model.dart';
import 'package:AbsenDulu/data/models/attendance_stats_model.dart';

class AttendanceRepository {
  final ApiClient _apiClient = ApiClient();

  Future<AttendanceModel> checkIn({
    required String date,
    required String time,
    required double lat,
    required double lng,
    required String address,
  }) async {
    final response = await _apiClient.post(
      ApiEndpoints.checkIn,
      body: {
        'attendance_date': date,
        'check_in': time,
        'check_in_lat': lat,
        'check_in_lng': lng,
        'check_in_address': address,
        'status': 'masuk',
      },
    );

    if (response is Map<String, dynamic>) {
      final rawData = response.containsKey('data')
          ? response['data']
          : response;
      if (rawData is Map<String, dynamic>) {
        final model = AttendanceModel.fromJson(rawData);
        if ((model.checkIn == null || model.checkIn!.isEmpty) &&
            (model.checkInTime == null || model.checkInTime!.isEmpty)) {
          return AttendanceModel(
            id: model.id,
            userId: model.userId,
            attendanceDate: model.attendanceDate ?? date,
            checkIn: time,
            checkInTime: time,
            checkInLat: model.checkInLat ?? lat,
            checkInLng: model.checkInLng ?? lng,
            checkInAddress: model.checkInAddress ?? address,
            status: model.status ?? 'masuk',
          );
        }
        return model;
      }
    }
    throw Exception('Gagal melakukan absen masuk');
  }

  Future<AttendanceModel> checkOut({
    required String date,
    required String time,
    required double lat,
    required double lng,
    required String address,
  }) async {
    final response = await _apiClient.post(
      ApiEndpoints.checkOut,
      body: {
        'attendance_date': date,
        'check_out': time,
        'check_out_lat': lat.toString(),
        'check_out_lng': lng.toString(),
        'check_out_location': '$lat, $lng',
        'check_out_address': address,
      },
    );

    if (response is Map<String, dynamic>) {
      final rawData = response.containsKey('data')
          ? response['data']
          : response;
      if (rawData is Map<String, dynamic>) {
        final model = AttendanceModel.fromJson(rawData);
        if ((model.checkOut == null || model.checkOut!.isEmpty) &&
            (model.checkOutTime == null || model.checkOutTime!.isEmpty)) {
          return AttendanceModel(
            id: model.id,
            userId: model.userId,
            attendanceDate: model.attendanceDate ?? date,
            checkIn: model.checkIn,
            checkInTime: model.checkInTime,
            checkOut: time,
            checkOutTime: time,
            checkInLat: model.checkInLat,
            checkInLng: model.checkInLng,
            checkOutLat: lat,
            checkOutLng: lng,
            checkInAddress: model.checkInAddress,
            checkOutAddress: address,
            status: 'pulang',
            alasanIzin: model.alasanIzin,
          );
        }
        return model;
      }
    }
    throw Exception('Gagal melakukan absen keluar');
  }

  Future<AttendanceModel> submitIzin({
    required String date,
    required String reason,
  }) async {
    final response = await _apiClient.post(
      ApiEndpoints.izin,
      body: {'date': date, 'alasan_izin': reason},
    );

    if (response is Map<String, dynamic>) {
      final rawData = response.containsKey('data')
          ? response['data']
          : response;
      if (rawData is Map<String, dynamic>) {
        final model = AttendanceModel.fromJson(rawData);
        return AttendanceModel(
          id: model.id,
          userId: model.userId,
          attendanceDate: model.attendanceDate ?? date,
          status: 'izin',
          alasanIzin: reason,
        );
      }
    }
    throw Exception('Gagal mengajukan izin');
  }

  Future<AttendanceModel?> getTodayAttendance(String date) async {
    try {
      final response = await _apiClient.get(
        '${ApiEndpoints.today}?attendance_date=$date',
      );
      if (response is Map<String, dynamic>) {
        final rawData = response.containsKey('data')
            ? response['data']
            : response;
        if (rawData is Map<String, dynamic>) {
          return AttendanceModel.fromJson(rawData);
        } else if (rawData is List && rawData.isNotEmpty) {
          final first = rawData.first;
          if (first is Map<String, dynamic>) {
            return AttendanceModel.fromJson(first);
          }
        }
      } else if (response is List && response.isNotEmpty) {
        final first = response.first;
        if (first is Map<String, dynamic>) {
          return AttendanceModel.fromJson(first);
        }
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<AttendanceStatsModel> getAttendanceStats(
    String startDate,
    String endDate,
  ) async {
    try {
      final response = await _apiClient.get(
        '${ApiEndpoints.stats}?start=$startDate&end=$endDate',
      );
      if (response is Map<String, dynamic> && response.containsKey('data')) {
        final data = response['data'];
        if (data is Map<String, dynamic>) {
          return AttendanceStatsModel.fromJson(data);
        }
      }
      return AttendanceStatsModel();
    } catch (_) {
      return AttendanceStatsModel();
    }
  }

  Future<List<AttendanceModel>> getHistory({
    String? startDate,
    String? endDate,
  }) async {
    String url = ApiEndpoints.history;
    if (startDate != null && endDate != null) {
      url += '?start=$startDate&end=$endDate';
    }

    final response = await _apiClient.get(url);
    if (response is Map<String, dynamic> && response.containsKey('data')) {
      final list = response['data'];
      if (list is List) {
        return list
            .map((e) => AttendanceModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    }
    return [];
  }

  Future<void> deleteAttendance(int id) async {
    await _apiClient.delete(ApiEndpoints.deleteAbsen(id));
  }
}
