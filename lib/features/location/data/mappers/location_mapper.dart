import 'package:absensigeo/core/database/entities/location_model.dart';
import 'package:absensigeo/features/location/domain/entities/location.dart';

extension LocationModelMapper on LocationModel {
  Location toEntity() {
    return Location(
      id: id,
      name: name,
      latitude: latitude,
      longitude: longitude,
      radiusMeter: radiusMeter,
      isActive: isActive,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

extension LocationEntityMapper on Location {
  LocationModel toModel() {
    return LocationModel(
      id: id,
      name: name,
      latitude: latitude,
      longitude: longitude,
      radiusMeter: radiusMeter,
      isActive: isActive,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
