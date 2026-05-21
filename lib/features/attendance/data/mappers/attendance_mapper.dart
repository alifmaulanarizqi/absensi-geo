import 'package:absensigeo/core/database/entities/attendance_log_model.dart';
import 'package:absensigeo/features/attendance/domain/entities/attendance_log.dart';

extension AttendanceLogModelMapper on AttendanceLogModel {
  AttendanceLog toEntity({required String locationName}) {
    return AttendanceLog(
      id: id,
      locationId: locationId,
      locationName: locationName,
      attendanceTime: attendanceTime,
      userLatitude: userLatitude,
      userLongitude: userLongitude,
      gpsAccuracyMeter: gpsAccuracyMeter,
      distanceMeter: distanceMeter,
      allowedRadiusMeter: allowedRadiusMeter,
      status: status.toDomain(),
      rejectionReason: rejectionReason,
      createdAt: createdAt,
    );
  }
}

extension AttendanceStatusMapper on AttendanceStatus {
  AttendanceRecordStatus toDomain() {
    switch (this) {
      case AttendanceStatus.accepted:
        return AttendanceRecordStatus.accepted;
      case AttendanceStatus.rejected:
        return AttendanceRecordStatus.rejected;
    }
  }
}

extension AttendanceRecordStatusMapper on AttendanceRecordStatus {
  AttendanceStatus toModel() {
    switch (this) {
      case AttendanceRecordStatus.accepted:
        return AttendanceStatus.accepted;
      case AttendanceRecordStatus.rejected:
        return AttendanceStatus.rejected;
    }
  }
}
