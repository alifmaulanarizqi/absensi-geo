import 'package:absensigeo/core/error/failure.dart';
import 'package:absensigeo/features/attendance/domain/entities/attendance_log.dart';
import 'package:absensigeo/features/attendance/domain/entities/attendance_overview.dart';
import 'package:dartz/dartz.dart';

abstract class AttendanceRepository {
  Future<Either<Failure, AttendanceOverview>> getAttendanceOverview();
  Future<Either<Failure, AttendanceLog>> recordAttendance();
}
