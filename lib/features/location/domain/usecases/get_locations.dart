import 'package:absensigeo/core/error/failure.dart';
import 'package:absensigeo/features/location/domain/entities/location.dart';
import 'package:absensigeo/features/location/domain/repositories/location_repository.dart';
import 'package:dartz/dartz.dart';

class GetLocationsUseCase {
  const GetLocationsUseCase(this._repository);

  final LocationRepository _repository;

  Future<Either<Failure, List<Location>>> call() {
    return _repository.getLocations();
  }
}
