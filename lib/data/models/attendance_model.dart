import 'package:json_annotation/json_annotation.dart';

part 'attendance_model.g.dart';

@JsonSerializable()
class AttendanceModel {
  final int? id;
  @JsonKey(name: 'user_id')
  final dynamic userId;
  @JsonKey(name: 'attendance_date')
  final String? attendanceDate;
  @JsonKey(name: 'check_in')
  final String? checkIn;
  @JsonKey(name: 'check_in_time')
  final String? checkInTime;
  @JsonKey(name: 'check_out')
  final String? checkOut;
  @JsonKey(name: 'check_out_time')
  final String? checkOutTime;
  @JsonKey(name: 'check_in_lat')
  final dynamic checkInLat;
  @JsonKey(name: 'check_in_lng')
  final dynamic checkInLng;
  @JsonKey(name: 'check_out_lat')
  final dynamic checkOutLat;
  @JsonKey(name: 'check_out_lng')
  final dynamic checkOutLng;
  @JsonKey(name: 'check_in_address')
  final String? checkInAddress;
  @JsonKey(name: 'check_out_address')
  final String? checkOutAddress;
  @JsonKey(name: 'check_in_location')
  final String? checkInLocation;
  @JsonKey(name: 'check_out_location')
  final String? checkOutLocation;
  final String? status;
  @JsonKey(name: 'alasan_izin')
  final String? alasanIzin;

  AttendanceModel({
    this.id,
    this.userId,
    this.attendanceDate,
    this.checkIn,
    this.checkInTime,
    this.checkOut,
    this.checkOutTime,
    this.checkInLat,
    this.checkInLng,
    this.checkOutLat,
    this.checkOutLng,
    this.checkInAddress,
    this.checkOutAddress,
    this.checkInLocation,
    this.checkOutLocation,
    this.status,
    this.alasanIzin,
  });

  String get effectiveCheckInTime {
    if (checkInTime != null && checkInTime!.isNotEmpty) return checkInTime!;
    if (checkIn != null && checkIn!.isNotEmpty) {
      if (checkIn!.contains(' ')) {
        return checkIn!.split(' ').last;
      }
      return checkIn!;
    }
    return '--:--';
  }

  String get effectiveCheckOutTime {
    if (checkOutTime != null && checkOutTime!.isNotEmpty) return checkOutTime!;
    if (checkOut != null && checkOut!.isNotEmpty) {
      if (checkOut!.contains(' ')) {
        return checkOut!.split(' ').last;
      }
      return checkOut!;
    }
    return '--:--';
  }

  bool get isCheckedIn {
    if (checkIn != null && checkIn!.isNotEmpty) return true;
    if (checkInTime != null && checkInTime!.isNotEmpty) return true;
    if (effectiveCheckInTime != '--:--') return true;
    if (status != null) {
      final s = status!.toLowerCase();
      if (s == 'masuk' || s == 'hadir' || s == 'terlambat' || s == 'telat' || s == 'pulang') return true;
    }
    if (isCheckedOut) return true;
    return false;
  }

  bool get isCheckedOut {
    if (checkOut != null && checkOut!.isNotEmpty) return true;
    if (checkOutTime != null && checkOutTime!.isNotEmpty) return true;
    if (effectiveCheckOutTime != '--:--') return true;
    if (status != null && status!.toLowerCase() == 'pulang') return true;
    return false;
  }

  bool get isIzin {
    if (status != null && status!.toLowerCase() == 'izin') return true;
    if (alasanIzin != null && alasanIzin!.isNotEmpty) return true;
    return false;
  }

  bool get isLate {
    if (isIzin) return false;
    if (status != null) {
      final s = status!.toLowerCase();
      if (s == 'terlambat' || s == 'telat') return true;
    }
    final timeStr = effectiveCheckInTime;
    if (timeStr != '--:--') {
      try {
        final parts = timeStr.split(':');
        final h = int.parse(parts[0]);
        final m = int.parse(parts[1]);
        final s = parts.length > 2 ? int.parse(parts[2]) : 0;
        if (h > 8 || (h == 8 && (m > 0 || s > 0))) {
          return true;
        }
      } catch (_) {}
    }
    return false;
  }

  String get effectiveStatus {
    if (isIzin) return 'izin';
    if (isLate) return 'terlambat';
    if (isCheckedIn) return 'hadir';
    return status ?? 'alfa';
  }

  String? get effectiveCoordinates {
    if (checkInLat != null &&
        checkInLng != null &&
        checkInLat.toString().trim().isNotEmpty &&
        checkInLng.toString().trim().isNotEmpty) {
      return '$checkInLat, $checkInLng';
    }
    if (checkInLocation != null && checkInLocation!.trim().isNotEmpty) {
      return checkInLocation!.trim();
    }
    if (checkOutLat != null &&
        checkOutLng != null &&
        checkOutLat.toString().trim().isNotEmpty &&
        checkOutLng.toString().trim().isNotEmpty) {
      return '$checkOutLat, $checkOutLng';
    }
    if (checkOutLocation != null && checkOutLocation!.trim().isNotEmpty) {
      return checkOutLocation!.trim();
    }
    return null;
  }

  factory AttendanceModel.fromJson(Map<String, dynamic> json) => _$AttendanceModelFromJson(json);

  Map<String, dynamic> toJson() => _$AttendanceModelToJson(this);
}
