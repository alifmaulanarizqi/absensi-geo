// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  LocationDao? _locationDaoInstance;

  AttendanceLogDao? _attendanceLogDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `locations` (`id` INTEGER, `name` TEXT NOT NULL, `latitude` REAL NOT NULL, `longitude` REAL NOT NULL, `radius_meter` REAL NOT NULL, `is_active` INTEGER NOT NULL, `created_at` TEXT NOT NULL, `updated_at` TEXT NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `attendance_logs` (`id` INTEGER, `location_id` INTEGER NOT NULL, `attendance_time` TEXT NOT NULL, `user_latitude` REAL NOT NULL, `user_longitude` REAL NOT NULL, `gps_accuracy_meter` REAL NOT NULL, `distance_meter` REAL NOT NULL, `allowed_radius_meter` REAL NOT NULL, `status` TEXT NOT NULL, `rejection_reason` TEXT, `created_at` TEXT NOT NULL, FOREIGN KEY (`location_id`) REFERENCES `locations` (`id`) ON UPDATE CASCADE ON DELETE NO ACTION, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE INDEX `index_locations_name` ON `locations` (`name`)');
        await database.execute(
            'CREATE INDEX `index_attendance_logs_location_id` ON `attendance_logs` (`location_id`)');
        await database.execute(
            'CREATE INDEX `index_attendance_logs_attendance_time` ON `attendance_logs` (`attendance_time`)');
        await database.execute(
            'CREATE INDEX `index_attendance_logs_location_id_attendance_time` ON `attendance_logs` (`location_id`, `attendance_time`)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  LocationDao get locationDao {
    return _locationDaoInstance ??= _$LocationDao(database, changeListener);
  }

  @override
  AttendanceLogDao get attendanceLogDao {
    return _attendanceLogDaoInstance ??=
        _$AttendanceLogDao(database, changeListener);
  }
}

class _$LocationDao extends LocationDao {
  _$LocationDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _locationModelInsertionAdapter = InsertionAdapter(
            database,
            'locations',
            (LocationModel item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'latitude': item.latitude,
                  'longitude': item.longitude,
                  'radius_meter': item.radiusMeter,
                  'is_active': item.isActive ? 1 : 0,
                  'created_at': _dateTimeConverter.encode(item.createdAt),
                  'updated_at': _dateTimeConverter.encode(item.updatedAt)
                }),
        _locationModelUpdateAdapter = UpdateAdapter(
            database,
            'locations',
            ['id'],
            (LocationModel item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'latitude': item.latitude,
                  'longitude': item.longitude,
                  'radius_meter': item.radiusMeter,
                  'is_active': item.isActive ? 1 : 0,
                  'created_at': _dateTimeConverter.encode(item.createdAt),
                  'updated_at': _dateTimeConverter.encode(item.updatedAt)
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<LocationModel> _locationModelInsertionAdapter;

  final UpdateAdapter<LocationModel> _locationModelUpdateAdapter;

  @override
  Future<List<LocationModel>> findAll() async {
    return _queryAdapter.queryList('SELECT * FROM locations ORDER BY id DESC',
        mapper: (Map<String, Object?> row) => LocationModel(
            id: row['id'] as int?,
            name: row['name'] as String,
            latitude: row['latitude'] as double,
            longitude: row['longitude'] as double,
            radiusMeter: row['radius_meter'] as double,
            isActive: (row['is_active'] as int) != 0,
            createdAt: _dateTimeConverter.decode(row['created_at'] as String),
            updatedAt: _dateTimeConverter.decode(row['updated_at'] as String)));
  }

  @override
  Future<List<LocationModel>> findAllActive() async {
    return _queryAdapter.queryList(
        'SELECT * FROM locations WHERE is_active = 1 ORDER BY id DESC',
        mapper: (Map<String, Object?> row) => LocationModel(
            id: row['id'] as int?,
            name: row['name'] as String,
            latitude: row['latitude'] as double,
            longitude: row['longitude'] as double,
            radiusMeter: row['radius_meter'] as double,
            isActive: (row['is_active'] as int) != 0,
            createdAt: _dateTimeConverter.decode(row['created_at'] as String),
            updatedAt: _dateTimeConverter.decode(row['updated_at'] as String)));
  }

  @override
  Future<LocationModel?> findById(int id) async {
    return _queryAdapter.query('SELECT * FROM locations WHERE id = ?1 LIMIT 1',
        mapper: (Map<String, Object?> row) => LocationModel(
            id: row['id'] as int?,
            name: row['name'] as String,
            latitude: row['latitude'] as double,
            longitude: row['longitude'] as double,
            radiusMeter: row['radius_meter'] as double,
            isActive: (row['is_active'] as int) != 0,
            createdAt: _dateTimeConverter.decode(row['created_at'] as String),
            updatedAt: _dateTimeConverter.decode(row['updated_at'] as String)),
        arguments: [id]);
  }

  @override
  Future<int> insertLocation(LocationModel location) {
    return _locationModelInsertionAdapter.insertAndReturnId(
        location, OnConflictStrategy.abort);
  }

  @override
  Future<int> updateLocation(LocationModel location) {
    return _locationModelUpdateAdapter.updateAndReturnChangedRows(
        location, OnConflictStrategy.abort);
  }
}

class _$AttendanceLogDao extends AttendanceLogDao {
  _$AttendanceLogDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _attendanceLogModelInsertionAdapter = InsertionAdapter(
            database,
            'attendance_logs',
            (AttendanceLogModel item) => <String, Object?>{
                  'id': item.id,
                  'location_id': item.locationId,
                  'attendance_time':
                      _dateTimeConverter.encode(item.attendanceTime),
                  'user_latitude': item.userLatitude,
                  'user_longitude': item.userLongitude,
                  'gps_accuracy_meter': item.gpsAccuracyMeter,
                  'distance_meter': item.distanceMeter,
                  'allowed_radius_meter': item.allowedRadiusMeter,
                  'status': _attendanceStatusConverter.encode(item.status),
                  'rejection_reason': item.rejectionReason,
                  'created_at': _dateTimeConverter.encode(item.createdAt)
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<AttendanceLogModel>
      _attendanceLogModelInsertionAdapter;

  @override
  Future<List<AttendanceLogModel>> findAll() async {
    return _queryAdapter.queryList(
        'SELECT * FROM attendance_logs ORDER BY attendance_time DESC',
        mapper: (Map<String, Object?> row) => AttendanceLogModel(
            id: row['id'] as int?,
            locationId: row['location_id'] as int,
            attendanceTime:
                _dateTimeConverter.decode(row['attendance_time'] as String),
            userLatitude: row['user_latitude'] as double,
            userLongitude: row['user_longitude'] as double,
            gpsAccuracyMeter: row['gps_accuracy_meter'] as double,
            distanceMeter: row['distance_meter'] as double,
            allowedRadiusMeter: row['allowed_radius_meter'] as double,
            status: _attendanceStatusConverter.decode(row['status'] as String),
            rejectionReason: row['rejection_reason'] as String?,
            createdAt: _dateTimeConverter.decode(row['created_at'] as String)));
  }

  @override
  Future<List<AttendanceLogModel>> findByLocationId(int locationId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM attendance_logs WHERE location_id = ?1 ORDER BY attendance_time DESC',
        mapper: (Map<String, Object?> row) => AttendanceLogModel(id: row['id'] as int?, locationId: row['location_id'] as int, attendanceTime: _dateTimeConverter.decode(row['attendance_time'] as String), userLatitude: row['user_latitude'] as double, userLongitude: row['user_longitude'] as double, gpsAccuracyMeter: row['gps_accuracy_meter'] as double, distanceMeter: row['distance_meter'] as double, allowedRadiusMeter: row['allowed_radius_meter'] as double, status: _attendanceStatusConverter.decode(row['status'] as String), rejectionReason: row['rejection_reason'] as String?, createdAt: _dateTimeConverter.decode(row['created_at'] as String)),
        arguments: [locationId]);
  }

  @override
  Future<int> insertAttendanceLog(AttendanceLogModel attendanceLog) {
    return _attendanceLogModelInsertionAdapter.insertAndReturnId(
        attendanceLog, OnConflictStrategy.abort);
  }
}

// ignore_for_file: unused_element
final _dateTimeConverter = DateTimeConverter();
final _attendanceStatusConverter = AttendanceStatusConverter();
