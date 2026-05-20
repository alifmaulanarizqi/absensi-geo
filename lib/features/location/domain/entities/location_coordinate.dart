import 'package:equatable/equatable.dart';

class LocationCoordinate extends Equatable {
  const LocationCoordinate({
    required this.latitude,
    required this.longitude,
    required this.accuracyMeter,
  });

  final double latitude;
  final double longitude;
  final double accuracyMeter;

  @override
  List<Object?> get props => [
        latitude,
        longitude,
        accuracyMeter,
      ];
}
