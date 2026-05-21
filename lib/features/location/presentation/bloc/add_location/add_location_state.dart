import 'package:absensigeo/features/location/domain/entities/location_coordinate.dart';
import 'package:equatable/equatable.dart';

enum AddLocationStatus {
  initial,
  fetchingLocation,
  locationReady,
  saving,
  success,
  failure,
}

class AddLocationState extends Equatable {
  const AddLocationState({
    this.status = AddLocationStatus.initial,
    this.name = '',
    this.coordinate,
    this.message = '',
    this.failureCode,
  });

  final AddLocationStatus status;
  final String name;
  final LocationCoordinate? coordinate;
  final String message;
  final String? failureCode;

  bool get isFetchingLocation => status == AddLocationStatus.fetchingLocation;
  bool get isSaving => status == AddLocationStatus.saving;

  static const Object _coordinateSentinel = Object();
  static const Object _failureCodeSentinel = Object();

  AddLocationState copyWith({
    AddLocationStatus? status,
    String? name,
    Object? coordinate = _coordinateSentinel,
    String? message,
    Object? failureCode = _failureCodeSentinel,
  }) {
    return AddLocationState(
      status: status ?? this.status,
      name: name ?? this.name,
      coordinate: coordinate == _coordinateSentinel
          ? this.coordinate
          : coordinate as LocationCoordinate?,
      message: message ?? this.message,
      failureCode: failureCode == _failureCodeSentinel
          ? this.failureCode
          : failureCode as String?,
    );
  }

  @override
  List<Object?> get props => [status, name, coordinate, message, failureCode];
}
