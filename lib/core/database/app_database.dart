import 'dart:async';

import 'package:absensigeo/core/database/converters/attendance_status_converter.dart';
import 'package:absensigeo/core/database/converters/date_time_converter.dart';
import 'package:absensigeo/core/database/dao/attendance_log_dao.dart';
import 'package:absensigeo/core/database/dao/location_dao.dart';
import 'package:absensigeo/core/database/entities/attendance_log_model.dart';
import 'package:absensigeo/core/database/entities/location_model.dart';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'app_database.g.dart';

@TypeConverters([
  DateTimeConverter,
  AttendanceStatusConverter,
])
@Database(
  version: 1,
  entities: [
    LocationModel,
    AttendanceLogModel,
  ],
)
abstract class AppDatabase extends FloorDatabase {
  LocationDao get locationDao;
  AttendanceLogDao get attendanceLogDao;
}
