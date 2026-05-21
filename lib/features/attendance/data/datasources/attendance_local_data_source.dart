import 'package:absensigeo/core/database/dao/attendance_log_dao.dart';
import 'package:absensigeo/core/database/dao/location_dao.dart';
import 'package:absensigeo/core/database/entities/attendance_log_model.dart';
import 'package:absensigeo/core/database/entities/location_model.dart';

abstract class AttendanceLocalDataSource {
  Future<List<AttendanceLogModel>> getAttendanceLogs();
  Future<int> insertAttendanceLog(AttendanceLogModel attendanceLog);
  Future<LocationModel?> getActiveLocation();
  Future<List<LocationModel>> getLocations();
}

class FloorAttendanceLocalDataSource implements AttendanceLocalDataSource {
  const FloorAttendanceLocalDataSource({
    required AttendanceLogDao attendanceLogDao,
    required LocationDao locationDao,
  }) : _attendanceLogDao = attendanceLogDao,
       _locationDao = locationDao;

  final AttendanceLogDao _attendanceLogDao;
  final LocationDao _locationDao;

  @override
  Future<List<AttendanceLogModel>> getAttendanceLogs() {
    return _attendanceLogDao.findAll();
  }

  @override
  Future<int> insertAttendanceLog(AttendanceLogModel attendanceLog) {
    return _attendanceLogDao.insertAttendanceLog(attendanceLog);
  }

  @override
  Future<LocationModel?> getActiveLocation() async {
    final locations = await _locationDao.findAllActive();

    if (locations.isEmpty) {
      return null;
    }

    return locations.first;
  }

  @override
  Future<List<LocationModel>> getLocations() {
    return _locationDao.findAll();
  }
}
