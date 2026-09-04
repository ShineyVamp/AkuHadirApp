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

  factory AttendanceModel.fromJson(Map<String, dynamic> json) => _$AttendanceModelFromJson(json);

  Map<String, dynamic> toJson() => _$AttendanceModelToJson(this);
}
