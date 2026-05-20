import 'package:absensigeo/core/error/app_exception.dart';
import 'package:absensigeo/core/error/failure.dart';
import 'package:absensigeo/core/services/location_permission_service.dart';
import 'package:absensigeo/features/location/domain/entities/location_coordinate.dart';
import 'package:geolocator/geolocator.dart';

abstract class LocationDeviceDataSource {
  Future<LocationCoordinate> getCurrentLocation();
}

class GeolocatorLocationDeviceDataSource implements LocationDeviceDataSource {
  const GeolocatorLocationDeviceDataSource({
    required LocationPermissionService permissionService,
  }) : _permissionService = permissionService;

  final LocationPermissionService _permissionService;

  @override
  Future<LocationCoordinate> getCurrentLocation() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      throw const AppException(
        'GPS belum aktif. Aktifkan layanan lokasi lalu coba lagi.',
        code: FailureCodes.gpsDisabled,
      );
    }

    final permissionResult =
        await _permissionService.requestLocationPermission();

    if (permissionResult == LocationPermissionResult.permanentlyDenied) {
      throw const AppException(
        'Izin lokasi ditolak permanen. Aktifkan kembali dari pengaturan aplikasi.',
      );
    }

    if (permissionResult != LocationPermissionResult.granted) {
      throw const AppException(
        'Izin lokasi dibutuhkan untuk mengambil koordinat.',
      );
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      return LocationCoordinate(
        latitude: position.latitude,
        longitude: position.longitude,
        accuracyMeter: position.accuracy,
      );
    } on Exception {
      throw const AppException(
        'Gagal mengambil lokasi saat ini. Coba lagi.',
      );
    }
  }
}
