import 'package:absensigeo/features/location/domain/entities/location.dart';
import 'package:equatable/equatable.dart';

enum ManageLocationStatus { initial, loading, success, failure }

class ManageLocationState extends Equatable {
  const ManageLocationState({
    this.status = ManageLocationStatus.initial,
    this.locations = const [],
    this.isUpdating = false,
    this.message = '',
  });

  final ManageLocationStatus status;
  final List<Location> locations;
  final bool isUpdating;
  final String message;

  bool get isLoading =>
      status == ManageLocationStatus.loading && locations.isEmpty;

  ManageLocationState copyWith({
    ManageLocationStatus? status,
    List<Location>? locations,
    bool? isUpdating,
    String? message,
  }) {
    return ManageLocationState(
      status: status ?? this.status,
      locations: locations ?? this.locations,
      isUpdating: isUpdating ?? this.isUpdating,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [status, locations, isUpdating, message];
}
