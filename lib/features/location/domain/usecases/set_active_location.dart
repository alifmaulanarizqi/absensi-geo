import 'package:absensigeo/core/error/failure.dart';
import 'package:absensigeo/features/location/data/repositories/location_repository.dart';
import 'package:dartz/dartz.dart';

class SetActiveLocationUseCase {
  const SetActiveLocationUseCase(this._repository);

  final LocationRepository _repository;

  Future<Either<Failure, Unit>> call(int locationId) {
    if (locationId <= 0) {
      return Future.value(const Left(Failure('Lokasi tidak valid.')));
    }

    return _repository.setActiveLocation(locationId);
  }
}
