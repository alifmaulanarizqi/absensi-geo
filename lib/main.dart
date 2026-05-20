import 'package:absensigeo/core/theme/app_color_scheme.dart';
import 'package:absensigeo/core/theme/app_typography.dart';
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
      home: const ProjectBootstrapPage(),
    );
  }
}

class ProjectBootstrapPage extends StatelessWidget {
  const ProjectBootstrapPage({super.key});

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
            children: const [
              HomeActionCard(
                icon: Icons.place_outlined,
                title: 'Manage Location',
              ),
              HomeActionCard(
                icon: Icons.fact_check_outlined,
                title: 'Manage Attendance',
              ),
            ],
          ),
        )
      ),
    );
  }
}
