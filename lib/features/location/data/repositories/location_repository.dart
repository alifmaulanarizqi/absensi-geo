import 'package:absensigeo/core/error/failure.dart';
import 'package:absensigeo/features/location/domain/entities/location.dart';
import 'package:absensigeo/features/location/domain/entities/location_coordinate.dart';
import 'package:dartz/dartz.dart';

abstract class LocationRepository {
  Future<Either<Failure, List<Location>>> getLocations();
  Future<Either<Failure, LocationCoordinate>> getCurrentLocation();
  Future<Either<Failure, Location>> createLocation({
    required String name,
    required LocationCoordinate coordinate,
  });
  Future<Either<Failure, Unit>> setActiveLocation(int locationId);
}