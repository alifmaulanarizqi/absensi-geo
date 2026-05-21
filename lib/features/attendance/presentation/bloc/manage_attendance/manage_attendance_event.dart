import 'package:equatable/equatable.dart';

abstract class ManageAttendanceEvent extends Equatable {
  const ManageAttendanceEvent();

  @override
  List<Object?> get props => [];
}

class ManageAttendanceRequested extends ManageAttendanceEvent {
  const ManageAttendanceRequested();
}

class ManageAttendanceSubmitted extends ManageAttendanceEvent {
  const ManageAttendanceSubmitted();
}
