import 'package:absensigeo/core/theme/app_color_scheme.dart';
import 'package:absensigeo/core/theme/app_typography.dart';
import 'package:absensigeo/features/attendance/data/models/attendance_log_item_model.dart';
import 'package:absensigeo/shared/widgets/app_primary_button.dart';
import 'package:flutter/material.dart';

class ManageAttendancePage extends StatelessWidget {
  const ManageAttendancePage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = AppColorScheme.light;
    final textTheme = AppTypography.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Attendance'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Log Absensi',
                style: textTheme.titleLarge?.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.separated(
                  itemCount: _attendanceLogs.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final log = _attendanceLogs[index];

                    return Card(
                      color: colorScheme.surface,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: colorScheme.outlineVariant,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              log.title,
                              style: textTheme.titleMedium?.copyWith(
                                color: colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              log.time,
                              style: textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: log.status == 'Accepted'
                                    ? colorScheme.primaryContainer
                                    : colorScheme.errorContainer,
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                log.status,
                                style: textTheme.labelLarge?.copyWith(
                                  color: log.status == 'Accepted'
                                      ? colorScheme.primary
                                      : colorScheme.error,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              AppPrimaryButton(
                label: 'Absensi',
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}

const List<AttendanceLogItemModel> _attendanceLogs = [
  AttendanceLogItemModel(
    title: 'Kantor Pusat',
    time: '20 Mei 2026 08:03',
    status: 'Accepted',
  ),
  AttendanceLogItemModel(
    title: 'Kantor Pusat',
    time: '19 Mei 2026 08:11',
    status: 'Accepted',
  ),
  AttendanceLogItemModel(
    title: 'Warehouse',
    time: '18 Mei 2026 08:27',
    status: 'Rejected',
  ),
];
