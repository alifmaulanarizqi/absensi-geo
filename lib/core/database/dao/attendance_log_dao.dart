import 'package:absensigeo/core/database/entities/attendance_log_model.dart';
import 'package:floor/floor.dart';

@dao
abstract class AttendanceLogDao {
  @Query('SELECT * FROM attendance_logs ORDER BY attendance_time DESC')
  Future<List<AttendanceLogModel>> findAll();

  @insert
  Future<int> insertAttendanceLog(AttendanceLogModel attendanceLog);
}
