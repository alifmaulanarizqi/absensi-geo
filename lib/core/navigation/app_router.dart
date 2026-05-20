import 'package:absensigeo/features/attendance/presentation/pages/manage_attendance_page.dart';
import 'package:absensigeo/features/location/presentation/pages/add_location_page.dart';
import 'package:absensigeo/features/location/presentation/pages/manage_location_page.dart';
import 'package:flutter/material.dart';

abstract final class AppRoutes {
  static const String manageLocation = '/manage-location';
  static const String manageAttendance = '/manage-attendance';
  static const String addLocation = '/add-location';
}

abstract final class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.manageLocation:
        return MaterialPageRoute<void>(
          builder: (_) => const ManageLocationPage(),
          settings: settings,
        );
      case AppRoutes.manageAttendance:
        return MaterialPageRoute<void>(
          builder: (_) => const ManageAttendancePage(),
          settings: settings,
        );
      case AppRoutes.addLocation:
        return MaterialPageRoute<void>(
          builder: (_) => const AddLocationPage(),
          settings: settings,
        );
      default:
        return MaterialPageRoute<void>(
          builder: (_) => const _UnknownRoutePage(),
          settings: settings,
        );
    }
  }
}

class _UnknownRoutePage extends StatelessWidget {
  const _UnknownRoutePage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page Not Found'),
      ),
      body: const Center(
        child: Text('Page Not Found'),
      ),
    );
  }
}
