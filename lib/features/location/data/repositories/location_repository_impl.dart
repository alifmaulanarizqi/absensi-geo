import 'package:absensigeo/core/error/app_exception.dart';
import 'package:absensigeo/core/error/failure.dart';
import 'package:absensigeo/features/location/data/datasources/location_device_data_source.dart';
import 'package:absensigeo/features/location/data/datasources/location_local_data_source.dart';
import 'package:absensigeo/features/location/data/mappers/location_mapper.dart';
import 'package:absensigeo/features/location/domain/entities/location.dart';
import 'package:absensigeo/features/location/domain/entities/location_coordinate.dart';
import 'package:absensigeo/features/location/domain/repositories/location_repository.dart';
import 'package:dartz/dartz.dart';

class LocationRepositoryImpl implements LocationRepository {
  const LocationRepositoryImpl({
    required LocationLocalDataSource localDataSource,
    required LocationDeviceDataSource deviceDataSource,
  })  : _localDataSource = localDataSource,
        _deviceDataSource = deviceDataSource;

  static const double _defaultRadiusMeter = 50;

  final LocationLocalDataSource _localDataSource;
  final LocationDeviceDataSource _deviceDataSource;

  @override
  Future<Either<Failure, List<Location>>> getLocations() async {
    try {
      final locations = await _localDataSource.getLocations();
      return Right(
        locations.map((location) => location.toEntity()).toList(),
      );
    } on AppException catch (exception) {
      return Left(
        Failure(
          exception.message,
          code: exception.code,
        ),
      );
    } on Exception {
      return const Left(Failure('Gagal memuat daftar lokasi.'));
    }
  }

  @override
  Future<Either<Failure, LocationCoordinate>> getCurrentLocation() async {
    try {
      final coordinate = await _deviceDataSource.getCurrentLocation();
      return Right(coordinate);
    } on AppException catch (exception) {
      return Left(
        Failure(
          exception.message,
          code: exception.code,
        ),
      );
    } on Exception {
      return const Left(Failure('Gagal mengambil lokasi saat ini.'));
    }
  }

  @override
  Future<Either<Failure, Location>> createLocation({
    required String name,
    required LocationCoordinate coordinate,
  }) async {
    try {
      final existingLocations = await _localDataSource.getLocations();
      final now = DateTime.now();

      for (final existingLocation
          in existingLocations.where((location) => location.isActive)) {
        await _localDataSource.updateLocation(
          existingLocation.copyWith(
            isActive: false,
            updatedAt: now,
          ),
        );
      }

      final location = Location(
        name: name,
        latitude: coordinate.latitude,
        longitude: coordinate.longitude,
        radiusMeter: _defaultRadiusMeter,
        isActive: true,
        createdAt: now,
        updatedAt: now,
      );

      final insertedId = await _localDataSource.insertLocation(
        location.toModel(),
      );

      return Right(
        location.copyWith(id: insertedId),
      );
    } on AppException catch (exception) {
      return Left(
        Failure(
          exception.message,
          code: exception.code,
        ),
      );
    } on Exception {
      return const Left(Failure('Gagal menyimpan lokasi.'));
    }
  }

  @override
  Future<Either<Failure, Unit>> setActiveLocation(int locationId) async {
    try {
      final locations = await _localDataSource.getLocations();

      if (!locations.any((location) => location.id == locationId)) {
        return const Left(Failure('Lokasi tidak ditemukan.'));
      }

      final now = DateTime.now();

      for (final location in locations) {
        final nextIsActive = location.id == locationId;

        if (location.isActive != nextIsActive) {
          await _localDataSource.updateLocation(
            location.copyWith(
              isActive: nextIsActive,
              updatedAt: now,
            ),
          );
        }
      }

      return Right(unit);
    } on AppException catch (exception) {
      return Left(
        Failure(
          exception.message,
          code: exception.code,
        ),
      );
    } on Exception {
      return const Left(Failure('Gagal memperbarui lokasi aktif.'));
    }
  }
}
