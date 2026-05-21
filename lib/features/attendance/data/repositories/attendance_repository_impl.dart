import 'package:absensigeo/core/database/entities/attendance_log_model.dart';
import 'package:absensigeo/core/error/app_exception.dart';
import 'package:absensigeo/core/error/failure.dart';
import 'package:absensigeo/features/attendance/data/datasources/attendance_local_data_source.dart';
import 'package:absensigeo/features/attendance/data/mappers/attendance_mapper.dart';
import 'package:absensigeo/features/attendance/data/repositories/attendance_repository.dart';
import 'package:absensigeo/features/attendance/domain/entities/attendance_log.dart';
import 'package:absensigeo/features/attendance/domain/entities/attendance_overview.dart';
import 'package:absensigeo/features/location/data/datasources/location_device_data_source.dart';
import 'package:absensigeo/features/location/data/mappers/location_mapper.dart';
import 'package:dartz/dartz.dart';
import 'package:geolocator/geolocator.dart';

class AttendanceRepositoryImpl implements AttendanceRepository {
  const AttendanceRepositoryImpl({
    required AttendanceLocalDataSource localDataSource,
    required LocationDeviceDataSource deviceDataSource,
  }) : _localDataSource = localDataSource,
       _deviceDataSource = deviceDataSource;

  final AttendanceLocalDataSource _localDataSource;
  final LocationDeviceDataSource _deviceDataSource;

  @override
  Future<Either<Failure, AttendanceOverview>> getAttendanceOverview() async {
    try {
      final logs = await _localDataSource.getAttendanceLogs();
      final locations = await _localDataSource.getLocations();
      final activeLocation = await _localDataSource.getActiveLocation();

      final locationNames = <int, String>{
        for (final location in locations)
          if (location.id != null) location.id!: location.name,
      };

      return Right(
        AttendanceOverview(
          logs: logs
              .map(
                (log) => log.toEntity(
                  locationName:
                      locationNames[log.locationId] ??
                      'Lokasi #${log.locationId}',
                ),
              )
              .toList(),
          activeLocation: activeLocation?.toEntity(),
        ),
      );
    } on AppException catch (exception) {
      return Left(Failure(exception.message, code: exception.code));
    } on Exception {
      return const Left(Failure('Gagal memuat data absensi.'));
    }
  }

  @override
  Future<Either<Failure, AttendanceLog>> recordAttendance() async {
    try {
      final activeLocationModel = await _localDataSource.getActiveLocation();

      if (activeLocationModel == null) {
        return const Left(
          Failure(
            'Belum ada lokasi absensi aktif. Pilih lokasi aktif terlebih dahulu.',
          ),
        );
      }

      if (activeLocationModel.id == null) {
        return const Left(Failure('Lokasi absensi tidak valid.'));
      }

      final activeLocation = activeLocationModel.toEntity();
      final coordinate = await _deviceDataSource.getCurrentLocation();
      final distanceMeter = Geolocator.distanceBetween(
        coordinate.latitude,
        coordinate.longitude,
        activeLocation.latitude,
        activeLocation.longitude,
      );
      final status = distanceMeter <= activeLocation.radiusMeter
          ? AttendanceStatus.accepted
          : AttendanceStatus.rejected;
      final rejectionReason = status == AttendanceStatus.rejected
          ? 'Anda berada di luar radius lokasi absensi.'
          : null;
      final now = DateTime.now();

      final insertedId = await _localDataSource.insertAttendanceLog(
        AttendanceLogModel(
          locationId: activeLocationModel.id!,
          attendanceTime: now,
          userLatitude: coordinate.latitude,
          userLongitude: coordinate.longitude,
          gpsAccuracyMeter: coordinate.accuracyMeter,
          distanceMeter: distanceMeter,
          allowedRadiusMeter: activeLocation.radiusMeter,
          status: status,
          rejectionReason: rejectionReason,
          createdAt: now,
        ),
      );

      return Right(
        AttendanceLog(
          id: insertedId,
          locationId: activeLocationModel.id!,
          locationName: activeLocation.name,
          attendanceTime: now,
          userLatitude: coordinate.latitude,
          userLongitude: coordinate.longitude,
          gpsAccuracyMeter: coordinate.accuracyMeter,
          distanceMeter: distanceMeter,
          allowedRadiusMeter: activeLocation.radiusMeter,
          status: status.toDomain(),
          rejectionReason: rejectionReason,
          createdAt: now,
        ),
      );
    } on AppException catch (exception) {
      return Left(Failure(exception.message, code: exception.code));
    } on Exception {
      return const Left(Failure('Gagal mencatat absensi.'));
    }
  }
}
