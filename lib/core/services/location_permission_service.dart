import 'package:permission_handler/permission_handler.dart';

enum LocationPermissionResult {
  granted,
  denied,
  permanentlyDenied,
}

class LocationPermissionService {
  const LocationPermissionService();

  Future<LocationPermissionResult> requestLocationPermission() async {
    final status = await Permission.location.status;

    if (status.isGranted) {
      return LocationPermissionResult.granted;
    }

    final requestResult = await Permission.location.request();

    if (requestResult.isGranted) {
      return LocationPermissionResult.granted;
    }

    if (requestResult.isPermanentlyDenied) {
      return LocationPermissionResult.permanentlyDenied;
    }

    return LocationPermissionResult.denied;
  }

  Future<bool> openSettings() {
    return openAppSettings();
  }
}
