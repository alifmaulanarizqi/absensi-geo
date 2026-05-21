import 'package:absensigeo/features/attendance/domain/entities/attendance_log.dart';
import 'package:absensigeo/features/location/domain/entities/location.dart';
import 'package:equatable/equatable.dart';

enum ManageAttendanceStatus { initial, loading, success, failure }

class ManageAttendanceState extends Equatable {
  const ManageAttendanceState({
    this.status = ManageAttendanceStatus.initial,
    this.activeLocation,
    this.logs = const [],
    this.isSubmitting = false,
    this.message = '',
    this.failureCode,
  });

  final ManageAttendanceStatus status;
  final Location? activeLocation;
  final List<AttendanceLog> logs;
  final bool isSubmitting;
  final String message;
  final String? failureCode;

  bool get isLoading =>
      status == ManageAttendanceStatus.loading &&
      activeLocation == null &&
      logs.isEmpty;

  bool get hasActiveLocation => activeLocation != null;

  static const Object _activeLocationSentinel = Object();
  static const Object _failureCodeSentinel = Object();

  ManageAttendanceState copyWith({
    ManageAttendanceStatus? status,
    Object? activeLocation = _activeLocationSentinel,
    List<AttendanceLog>? logs,
    bool? isSubmitting,
    String? message,
    Object? failureCode = _failureCodeSentinel,
  }) {
    return ManageAttendanceState(
      status: status ?? this.status,
      activeLocation: activeLocation == _activeLocationSentinel
          ? this.activeLocation
          : activeLocation as Location?,
      logs: logs ?? this.logs,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      message: message ?? this.message,
      failureCode: failureCode == _failureCodeSentinel
          ? this.failureCode
          : failureCode as String?,
    );
  }

  @override
  List<Object?> get props => [
    status,
    activeLocation,
    logs,
    isSubmitting,
    message,
    failureCode,
  ];
}
