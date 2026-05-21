import 'package:absensigeo/features/location/domain/usecases/create_location.dart';
import 'package:absensigeo/features/location/domain/usecases/get_current_location.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'add_location_event.dart';
import 'add_location_state.dart';

export 'add_location_event.dart';
export 'add_location_state.dart';

class AddLocationBloc extends Bloc<AddLocationEvent, AddLocationState> {
  AddLocationBloc({
    required GetCurrentLocationUseCase getCurrentLocationUseCase,
    required CreateLocationUseCase createLocationUseCase,
  }) : _getCurrentLocationUseCase = getCurrentLocationUseCase,
       _createLocationUseCase = createLocationUseCase,
       super(const AddLocationState()) {
    on<AddLocationNameChanged>(_onNameChanged);
    on<AddLocationCurrentLocationRequested>(_onCurrentLocationRequested);
    on<AddLocationSubmitted>(_onSubmitted);
  }

  final GetCurrentLocationUseCase _getCurrentLocationUseCase;
  final CreateLocationUseCase _createLocationUseCase;

  void _onNameChanged(
    AddLocationNameChanged event,
    Emitter<AddLocationState> emit,
  ) {
    emit(
      state.copyWith(
        name: event.name,
        status: state.coordinate == null
            ? AddLocationStatus.initial
            : AddLocationStatus.locationReady,
        message: '',
        failureCode: null,
      ),
    );
  }

  Future<void> _onCurrentLocationRequested(
    AddLocationCurrentLocationRequested event,
    Emitter<AddLocationState> emit,
  ) async {
    emit(
      state.copyWith(
        status: AddLocationStatus.fetchingLocation,
        message: '',
        failureCode: null,
      ),
    );

    final result = await _getCurrentLocationUseCase();

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: state.coordinate == null
                ? AddLocationStatus.failure
                : AddLocationStatus.locationReady,
            message: failure.message,
            failureCode: failure.code,
          ),
        );
      },
      (coordinate) {
        emit(
          state.copyWith(
            status: AddLocationStatus.locationReady,
            coordinate: coordinate,
            message: '',
            failureCode: null,
          ),
        );
      },
    );
  }

  Future<void> _onSubmitted(
    AddLocationSubmitted event,
    Emitter<AddLocationState> emit,
  ) async {
    final trimmedName = state.name.trim();

    if (trimmedName.isEmpty) {
      emit(
        state.copyWith(
          status: AddLocationStatus.failure,
          message: 'Nama lokasi wajib diisi.',
          failureCode: null,
        ),
      );
      return;
    }

    final coordinate = state.coordinate;

    if (coordinate == null) {
      emit(
        state.copyWith(
          status: AddLocationStatus.failure,
          message: 'Ambil lokasi saat ini terlebih dahulu.',
          failureCode: null,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        status: AddLocationStatus.saving,
        message: '',
        failureCode: null,
      ),
    );

    final result = await _createLocationUseCase(
      CreateLocationParams(name: trimmedName, coordinate: coordinate),
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: AddLocationStatus.failure,
            message: failure.message,
            failureCode: failure.code,
          ),
        );
      },
      (_) {
        emit(
          state.copyWith(
            status: AddLocationStatus.success,
            message: 'Lokasi berhasil disimpan.',
            failureCode: null,
          ),
        );
      },
    );
  }
}
