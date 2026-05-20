import 'package:absensigeo/core/database/dao/location_dao.dart';
import 'package:absensigeo/core/database/entities/location_model.dart';

abstract class LocationLocalDataSource {
  Future<List<LocationModel>> getLocations();
  Future<int> insertLocation(LocationModel location);
  Future<void> updateLocation(LocationModel location);
}

class FloorLocationLocalDataSource implements LocationLocalDataSource {
  const FloorLocationLocalDataSource(this._locationDao);

  final LocationDao _locationDao;

  @override
  Future<List<LocationModel>> getLocations() {
    return _locationDao.findAll();
  }

  @override
  Future<int> insertLocation(LocationModel location) {
    return _locationDao.insertLocation(location);
  }

  @override
  Future<void> updateLocation(LocationModel location) async {
    await _locationDao.updateLocation(location);
  }
}
