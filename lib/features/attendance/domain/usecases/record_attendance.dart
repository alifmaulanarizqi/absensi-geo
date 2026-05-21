import 'package:absensigeo/core/error/failure.dart';
import 'package:absensigeo/features/attendance/data/repositories/attendance_repository.dart';
import 'package:absensigeo/features/attendance/domain/entities/attendance_log.dart';
import 'package:dartz/dartz.dart';

class RecordAttendanceUseCase {
  const RecordAttendanceUseCase(this._repository);

  final AttendanceRepository _repository;

  Future<Either<Failure, AttendanceLog>> call() {
    return _repository.recordAttendance();
  }
}
