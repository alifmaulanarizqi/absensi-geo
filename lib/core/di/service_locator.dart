import 'package:absensigeo/core/database/app_database.dart';
import 'package:absensigeo/core/database/dao/location_dao.dart';
import 'package:absensigeo/core/services/location_permission_service.dart';
import 'package:absensigeo/features/location/data/datasources/location_device_data_source.dart';
import 'package:absensigeo/features/location/data/datasources/location_local_data_source.dart';
import 'package:absensigeo/features/location/data/repositories/location_repository_impl.dart';
import 'package:absensigeo/features/location/domain/repositories/location_repository.dart';
import 'package:absensigeo/features/location/domain/usecases/create_location.dart';
import 'package:absensigeo/features/location/domain/usecases/get_current_location.dart';
import 'package:absensigeo/features/location/domain/usecases/get_locations.dart';
import 'package:absensigeo/features/location/domain/usecases/set_active_location.dart';
import 'package:absensigeo/features/location/presentation/bloc/add_location/add_location_bloc.dart';
import 'package:absensigeo/features/location/presentation/bloc/manage_location/manage_location_bloc.dart';
import 'package:get_it/get_it.dart';

final serviceLocator = GetIt.instance;

void setupServiceLocator(AppDatabase database) {
  if (serviceLocator.isRegistered<AppDatabase>()) {
    return;
  }

  serviceLocator.registerSingleton<AppDatabase>(database);
  serviceLocator.registerLazySingleton<LocationDao>(
    () => serviceLocator<AppDatabase>().locationDao,
  );
  serviceLocator.registerLazySingleton<LocationPermissionService>(
    () => const LocationPermissionService(),
  );
  serviceLocator.registerLazySingleton<LocationLocalDataSource>(
    () => FloorLocationLocalDataSource(serviceLocator()),
  );
  serviceLocator.registerLazySingleton<LocationDeviceDataSource>(
    () => GeolocatorLocationDeviceDataSource(
      permissionService: serviceLocator(),
    ),
  );
  serviceLocator.registerLazySingleton<LocationRepository>(
    () => LocationRepositoryImpl(
      localDataSource: serviceLocator(),
      deviceDataSource: serviceLocator(),
    ),
  );
  serviceLocator.registerLazySingleton(
    () => GetLocationsUseCase(serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => GetCurrentLocationUseCase(serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => CreateLocationUseCase(serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => SetActiveLocationUseCase(serviceLocator()),
  );
  serviceLocator.registerFactory(
    () => AddLocationBloc(
      getCurrentLocationUseCase: serviceLocator(),
      createLocationUseCase: serviceLocator(),
    ),
  );
  serviceLocator.registerFactory(
    () => ManageLocationBloc(
      getLocationsUseCase: serviceLocator(),
      setActiveLocationUseCase: serviceLocator(),
    ),
  );
}
