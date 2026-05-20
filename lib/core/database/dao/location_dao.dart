import 'package:absensigeo/core/database/entities/location_model.dart';
import 'package:floor/floor.dart';

@dao
abstract class LocationDao {
  @Query('SELECT * FROM locations ORDER BY id DESC')
  Future<List<LocationModel>> findAll();

  @Query('SELECT * FROM locations WHERE is_active = 1 ORDER BY id DESC')
  Future<List<LocationModel>> findAllActive();

  @Query('SELECT * FROM locations WHERE id = :id LIMIT 1')
  Future<LocationModel?> findById(int id);

  @insert
  Future<int> insertLocation(LocationModel location);

  @update
  Future<int> updateLocation(LocationModel location);
}
