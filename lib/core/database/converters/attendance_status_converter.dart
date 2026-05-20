import 'package:absensigeo/core/database/entities/attendance_log_model.dart';
import 'package:floor/floor.dart';

class AttendanceStatusConverter extends TypeConverter<AttendanceStatus, String> {
  @override
  AttendanceStatus decode(String databaseValue) {
    return AttendanceStatus.values.firstWhere(
      (value) => value.name == databaseValue,
      orElse: () => AttendanceStatus.rejected,
    );
  }

  @override
  String encode(AttendanceStatus value) {
    return value.name;
  }
}
