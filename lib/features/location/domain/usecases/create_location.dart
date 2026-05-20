import 'package:absensigeo/core/error/failure.dart';
import 'package:absensigeo/features/location/domain/entities/location.dart';
import 'package:absensigeo/features/location/domain/entities/location_coordinate.dart';
import 'package:absensigeo/features/location/domain/repositories/location_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class CreateLocationUseCase {
  const CreateLocationUseCase(this._repository);

  final LocationRepository _repository;

  Future<Either<Failure, Location>> call(CreateLocationParams params) {
    final trimmedName = params.name.trim();

    if (trimmedName.isEmpty) {
      return Future.value(
        const Left(Failure('Nama lokasi wajib diisi.')),
      );
    }

    return _repository.createLocation(
      name: trimmedName,
      coordinate: params.coordinate,
    );
  }
}

class CreateLocationParams extends Equatable {
  const CreateLocationParams({
    required this.name,
    required this.coordinate,
  });

  final String name;
  final LocationCoordinate coordinate;

  @override
  List<Object?> get props => [
        name,
        coordinate,
      ];
}
