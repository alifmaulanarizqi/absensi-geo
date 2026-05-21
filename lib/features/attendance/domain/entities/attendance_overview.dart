import 'package:absensigeo/features/attendance/domain/entities/attendance_log.dart';
import 'package:absensigeo/features/location/domain/entities/location.dart';
import 'package:equatable/equatable.dart';

class AttendanceOverview extends Equatable {
  const AttendanceOverview({required this.logs, this.activeLocation});

  final List<AttendanceLog> logs;
  final Location? activeLocation;

  bool get hasActiveLocation => activeLocation != null;

  @override
  List<Object?> get props => [logs, activeLocation];
}
