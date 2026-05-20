import 'package:absensigeo/core/theme/app_color_scheme.dart';
import 'package:absensigeo/core/theme/app_typography.dart';
import 'package:absensigeo/core/navigation/app_router.dart';
import 'package:absensigeo/core/services/location_permission_service.dart';
import 'package:absensigeo/shared/widgets/home_action_card.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const AbsensiGeoApp());
}

class AbsensiGeoApp extends StatelessWidget {
  const AbsensiGeoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Absensi Geo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: AppColorScheme.light,
        textTheme: AppTypography.textTheme,
        scaffoldBackgroundColor: AppColorScheme.light.surface,
        appBarTheme: AppBarTheme(
          backgroundColor: AppColorScheme.light.surface,
          foregroundColor: AppColorScheme.light.onSurface,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: AppTypography.textTheme.titleLarge?.copyWith(
            color: AppColorScheme.light.onSurface,
          ),
        ),
        useMaterial3: true,
      ),
      onGenerateRoute: AppRouter.onGenerateRoute,
      home: const ProjectBootstrapPage(),
    );
  }
}

class ProjectBootstrapPage extends StatefulWidget {
  const ProjectBootstrapPage({super.key});

  @override
  State<ProjectBootstrapPage> createState() => _ProjectBootstrapPageState();
}

class _ProjectBootstrapPageState extends State<ProjectBootstrapPage> {
  final LocationPermissionService _locationPermissionService =
      const LocationPermissionService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _requestLocationPermission();
    });
  }

  Future<void> _requestLocationPermission() async {
    final result = await _locationPermissionService.requestLocationPermission();

    if (!mounted || result == LocationPermissionResult.granted) {
      return;
    }

    if (result == LocationPermissionResult.permanentlyDenied) {
      await showDialog<void>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Location Permission'),
            content: const Text(
              'Izin lokasi ditolak permanen. Buka pengaturan untuk mengaktifkannya.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Nanti'),
              ),
              FilledButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  await _locationPermissionService.openSettings();
                },
                child: const Text('Buka Pengaturan'),
              ),
            ],
          );
        },
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Izin lokasi dibutuhkan untuk fitur absensi.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Absensi Geo'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: 16,
            runSpacing: 16,
            children: [
              HomeActionCard(
                icon: Icons.place_outlined,
                title: 'Manage Location',
                onTap: () {
                  Navigator.of(context).pushNamed(AppRoutes.manageLocation);
                },
              ),
              HomeActionCard(
                icon: Icons.fact_check_outlined,
                title: 'Manage Attendance',
                onTap: () {
                  Navigator.of(context).pushNamed(AppRoutes.manageAttendance);
                },
              ),
            ],
          ),
        )
      ),
    );
  }
}
