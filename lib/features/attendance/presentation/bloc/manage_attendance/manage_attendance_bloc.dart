import 'package:absensigeo/features/attendance/domain/entities/attendance_log.dart';
import 'package:absensigeo/features/attendance/domain/usecases/get_attendance_overview.dart';
import 'package:absensigeo/features/attendance/domain/usecases/record_attendance.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'manage_attendance_event.dart';
import 'manage_attendance_state.dart';

export 'manage_attendance_event.dart';
export 'manage_attendance_state.dart';

class ManageAttendanceBloc
    extends Bloc<ManageAttendanceEvent, ManageAttendanceState> {
  ManageAttendanceBloc({
    required GetAttendanceOverviewUseCase getAttendanceOverviewUseCase,
    required RecordAttendanceUseCase recordAttendanceUseCase,
  }) : _getAttendanceOverviewUseCase = getAttendanceOverviewUseCase,
       _recordAttendanceUseCase = recordAttendanceUseCase,
       super(const ManageAttendanceState()) {
    on<ManageAttendanceRequested>(_onRequested);
    on<ManageAttendanceSubmitted>(_onSubmitted);
  }

  final GetAttendanceOverviewUseCase _getAttendanceOverviewUseCase;
  final RecordAttendanceUseCase _recordAttendanceUseCase;

  Future<void> _onRequested(
    ManageAttendanceRequested event,
    Emitter<ManageAttendanceState> emit,
  ) async {
    emit(
      state.copyWith(
        status: ManageAttendanceStatus.loading,
        message: '',
        failureCode: null,
      ),
    );

    final result = await _getAttendanceOverviewUseCase();

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: ManageAttendanceStatus.failure,
            isSubmitting: false,
            message: failure.message,
            failureCode: failure.code,
          ),
        );
      },
      (overview) {
        emit(
          state.copyWith(
            status: ManageAttendanceStatus.success,
            activeLocation: overview.activeLocation,
            logs: overview.logs,
            isSubmitting: false,
            message: '',
            failureCode: null,
          ),
        );
      },
    );
  }

  Future<void> _onSubmitted(
    ManageAttendanceSubmitted event,
    Emitter<ManageAttendanceState> emit,
  ) async {
    emit(state.copyWith(isSubmitting: true, message: '', failureCode: null));

    final result = await _recordAttendanceUseCase();

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: state.logs.isEmpty && state.activeLocation == null
                ? ManageAttendanceStatus.failure
                : state.status,
            isSubmitting: false,
            message: failure.message,
            failureCode: failure.code,
          ),
        );
      },
      (attendanceLog) {
        emit(
          state.copyWith(
            status: ManageAttendanceStatus.success,
            logs: [attendanceLog, ...state.logs],
            isSubmitting: false,
            message: _buildResultMessage(attendanceLog),
            failureCode: null,
          ),
        );
      },
    );
  }

  String _buildResultMessage(AttendanceLog attendanceLog) {
    if (attendanceLog.isAccepted) {
      return 'Absensi berhasil dicatat.';
    }

    return attendanceLog.rejectionReason ?? 'Absensi ditolak.';
  }
}
