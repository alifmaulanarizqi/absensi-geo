import 'package:absensigeo/core/error/failure.dart';
import 'package:absensigeo/features/attendance/data/repositories/attendance_repository.dart';
import 'package:absensigeo/features/attendance/domain/entities/attendance_overview.dart';
import 'package:dartz/dartz.dart';

class GetAttendanceOverviewUseCase {
  const GetAttendanceOverviewUseCase(this._repository);

  final AttendanceRepository _repository;

  Future<Either<Failure, AttendanceOverview>> call() {
    return _repository.getAttendanceOverview();
  }
}
