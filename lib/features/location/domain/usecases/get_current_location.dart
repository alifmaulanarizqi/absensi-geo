import 'package:absensigeo/core/error/failure.dart';
import 'package:absensigeo/features/location/data/repositories/location_repository.dart';
import 'package:absensigeo/features/location/domain/entities/location_coordinate.dart';
import 'package:dartz/dartz.dart';

class GetCurrentLocationUseCase {
  const GetCurrentLocationUseCase(this._repository);

  final LocationRepository _repository;

  Future<Either<Failure, LocationCoordinate>> call() {
    return _repository.getCurrentLocation();
  }
}
