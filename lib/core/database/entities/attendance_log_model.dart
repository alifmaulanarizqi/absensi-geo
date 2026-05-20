import 'package:absensigeo/core/database/entities/location_model.dart';
import 'package:floor/floor.dart';

enum AttendanceStatus {
  accepted,
  rejected,
}

@Entity(
  tableName: 'attendance_logs',
  foreignKeys: [
    ForeignKey(
      childColumns: ['location_id'],
      parentColumns: ['id'],
      entity: LocationModel,
      onDelete: ForeignKeyAction.noAction,
      onUpdate: ForeignKeyAction.cascade,
    ),
  ],
  indices: [
    Index(value: ['location_id']),
    Index(value: ['attendance_time']),
    Index(value: ['location_id', 'attendance_time']),
  ],
)

class AttendanceLogModel {
  const AttendanceLogModel({
    this.id,
    required this.locationId,
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

  @primaryKey
  @ColumnInfo(name: 'id')
  final int? id;

  @ColumnInfo(name: 'location_id')
  final int locationId;

  @ColumnInfo(name: 'attendance_time')
  final DateTime attendanceTime;

  @ColumnInfo(name: 'user_latitude')
  final double userLatitude;

  @ColumnInfo(name: 'user_longitude')
  final double userLongitude;

  @ColumnInfo(name: 'gps_accuracy_meter')
  final double gpsAccuracyMeter;

  @ColumnInfo(name: 'distance_meter')
  final double distanceMeter;

  @ColumnInfo(name: 'allowed_radius_meter')
  final double allowedRadiusMeter;

  @ColumnInfo(name: 'status')
  final AttendanceStatus status;

  @ColumnInfo(name: 'rejection_reason')
  final String? rejectionReason;

  @ColumnInfo(name: 'created_at')
  final DateTime createdAt;
}
