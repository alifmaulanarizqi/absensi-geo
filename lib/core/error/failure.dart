import 'package:equatable/equatable.dart';

abstract final class FailureCodes {
  static const String gpsDisabled = 'gps_disabled';
}

class Failure extends Equatable {
  const Failure(
    this.message, {
    this.code,
  });

  final String message;
  final String? code;

  @override
  List<Object?> get props => [
        message,
        code,
      ];
}
