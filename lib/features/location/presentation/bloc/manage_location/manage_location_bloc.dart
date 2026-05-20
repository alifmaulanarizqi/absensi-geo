import 'package:absensigeo/core/error/failure.dart';
import 'package:absensigeo/features/location/domain/entities/location.dart';
import 'package:absensigeo/features/location/domain/usecases/get_locations.dart';
import 'package:absensigeo/features/location/domain/usecases/set_active_location.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum ManageLocationStatus {
  initial,
  loading,
  success,
  failure,
}

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
  List<Object?> get props => [
        status,
        locations,
        isUpdating,
        message,
      ];
}

class ManageLocationBloc
    extends Bloc<ManageLocationEvent, ManageLocationState> {
  ManageLocationBloc({
    required GetLocationsUseCase getLocationsUseCase,
    required SetActiveLocationUseCase setActiveLocationUseCase,
  })  : _getLocationsUseCase = getLocationsUseCase,
        _setActiveLocationUseCase = setActiveLocationUseCase,
        super(const ManageLocationState()) {
    on<ManageLocationRequested>(_onRequested);
    on<ManageLocationActiveLocationChanged>(_onActiveLocationChanged);
  }

  final GetLocationsUseCase _getLocationsUseCase;
  final SetActiveLocationUseCase _setActiveLocationUseCase;

  Future<void> _onRequested(
    ManageLocationRequested event,
    Emitter<ManageLocationState> emit,
  ) async {
    emit(
      state.copyWith(
        status: ManageLocationStatus.loading,
        message: '',
      ),
    );

    final result = await _getLocationsUseCase();

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: ManageLocationStatus.failure,
            message: failure.message,
          ),
        );
      },
      (locations) {
        emit(
          state.copyWith(
            status: ManageLocationStatus.success,
            locations: locations,
            message: '',
          ),
        );
      },
    );
  }

  Future<void> _onActiveLocationChanged(
    ManageLocationActiveLocationChanged event,
    Emitter<ManageLocationState> emit,
  ) async {
    emit(
      state.copyWith(
        isUpdating: true,
        message: '',
      ),
    );

    final updateResult = await _setActiveLocationUseCase(event.locationId);
    final updateFailure = updateResult.fold<Failure?>(
      (failure) => failure,
      (_) => null,
    );

    if (updateFailure != null) {
      emit(
        state.copyWith(
          isUpdating: false,
          message: updateFailure.message,
        ),
      );
      return;
    }

    final locationsResult = await _getLocationsUseCase();

    locationsResult.fold(
      (failure) {
        emit(
          state.copyWith(
            status: ManageLocationStatus.failure,
            isUpdating: false,
            message: failure.message,
          ),
        );
      },
      (locations) {
        emit(
          state.copyWith(
            status: ManageLocationStatus.success,
            locations: locations,
            isUpdating: false,
            message: 'Lokasi absensi berhasil diperbarui.',
          ),
        );
      },
    );
  }
}
