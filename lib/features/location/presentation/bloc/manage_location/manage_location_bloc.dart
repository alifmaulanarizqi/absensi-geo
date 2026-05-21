import 'package:absensigeo/core/error/failure.dart';
import 'package:absensigeo/features/location/domain/usecases/get_locations.dart';
import 'package:absensigeo/features/location/domain/usecases/set_active_location.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'manage_location_event.dart';
import 'manage_location_state.dart';

export 'manage_location_event.dart';
export 'manage_location_state.dart';

class ManageLocationBloc
    extends Bloc<ManageLocationEvent, ManageLocationState> {
  ManageLocationBloc({
    required GetLocationsUseCase getLocationsUseCase,
    required SetActiveLocationUseCase setActiveLocationUseCase,
  }) : _getLocationsUseCase = getLocationsUseCase,
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
    emit(state.copyWith(status: ManageLocationStatus.loading, message: ''));

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
    emit(state.copyWith(isUpdating: true, message: ''));

    final updateResult = await _setActiveLocationUseCase(event.locationId);
    final updateFailure = updateResult.fold<Failure?>(
      (failure) => failure,
      (_) => null,
    );

    if (updateFailure != null) {
      emit(state.copyWith(isUpdating: false, message: updateFailure.message));
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
