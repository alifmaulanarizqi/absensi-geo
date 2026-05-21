import 'package:equatable/equatable.dart';

abstract class ManageLocationEvent extends Equatable {
  const ManageLocationEvent();

  @override
  List<Object?> get props => [];
}

class ManageLocationRequested extends ManageLocationEvent {
  const ManageLocationRequested();
}

class ManageLocationActiveLocationChanged extends ManageLocationEvent {
  const ManageLocationActiveLocationChanged(this.locationId);

  final int locationId;

  @override
  List<Object?> get props => [locationId];
}
