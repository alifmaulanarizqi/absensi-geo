import 'package:equatable/equatable.dart';

enum AttendanceRecordStatus { accepted, rejected }

class AttendanceLog extends Equatable {
  const AttendanceLog({
    this.id,
    required this.locationId,
    required this.locationName,
    required this.attendanceTime,
    required this.userLatitude,
    required this.userLongitude,
    required this.gpsAccuracyMeter,
    required this.distanceMeter,
    required this.allowedRadiusMeter,
    required this.status,
    this.rejectionReason,
    required this.createdAt,
  });

  final int? id;
  final int locationId;
  final String locationName;
  final DateTime attendanceTime;
  final double userLatitude;
  final double userLongitude;
  final double gpsAccuracyMeter;
  final double distanceMeter;
  final double allowedRadiusMeter;
  final AttendanceRecordStatus status;
  final String? rejectionReason;
  final DateTime createdAt;

  bool get isAccepted => status == AttendanceRecordStatus.accepted;

  @override
  List<Object?> get props => [
    id,
    locationId,
    locationName,
    attendanceTime,
    userLatitude,
    userLongitude,
    gpsAccuracyMeter,
    distanceMeter,
    allowedRadiusMeter,
    status,
    rejectionReason,
    createdAt,
  ];
}
