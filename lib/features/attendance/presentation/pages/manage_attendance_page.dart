import 'package:absensigeo/core/di/service_locator.dart';
import 'package:absensigeo/core/error/failure.dart';
import 'package:absensigeo/core/navigation/app_router.dart';
import 'package:absensigeo/core/theme/app_color_scheme.dart';
import 'package:absensigeo/core/theme/app_typography.dart';
import 'package:absensigeo/core/utils/app_date_time_formatter.dart';
import 'package:absensigeo/features/attendance/domain/entities/attendance_log.dart';
import 'package:absensigeo/features/attendance/presentation/bloc/manage_attendance/manage_attendance_bloc.dart';
import 'package:absensigeo/shared/widgets/app_primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

class ManageAttendancePage extends StatelessWidget {
  const ManageAttendancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          serviceLocator<ManageAttendanceBloc>()
            ..add(const ManageAttendanceRequested()),
      child: const _ManageAttendanceView(),
    );
  }
}

class _ManageAttendanceView extends StatelessWidget {
  const _ManageAttendanceView();

  @override
  Widget build(BuildContext context) {
    final colorScheme = AppColorScheme.light;
    final textTheme = AppTypography.textTheme;

    return BlocListener<ManageAttendanceBloc, ManageAttendanceState>(
      listenWhen: (previous, current) =>
          previous.message != current.message ||
          previous.failureCode != current.failureCode,
      listener: (context, state) async {
        if (state.failureCode == FailureCodes.gpsDisabled) {
          await _showEnableGpsDialog(context);
          return;
        }

        if (state.message.isNotEmpty) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: BlocBuilder<ManageAttendanceBloc, ManageAttendanceState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(title: const Text('Manage Attendance')),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Lokasi Aktif',
                      style: textTheme.titleLarge?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildActiveLocationCard(
                      context: context,
                      state: state,
                      colorScheme: colorScheme,
                      textTheme: textTheme,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Log Absensi',
                            style: textTheme.titleLarge?.copyWith(
                              color: colorScheme.onSurface,
                            ),
                          ),
                        ),
                        TextButton.icon(
                          onPressed: state.isSubmitting
                              ? null
                              : () {
                                  context.read<ManageAttendanceBloc>().add(
                                    const ManageAttendanceRequested(),
                                  );
                                },
                          icon: const Icon(Icons.refresh),
                          label: const Text('Refresh'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: _buildLogContent(
                        state: state,
                        colorScheme: colorScheme,
                        textTheme: textTheme,
                      ),
                    ),
                    const SizedBox(height: 16),
                    AppPrimaryButton(
                      label: state.isSubmitting ? 'Memproses...' : 'Absensi',
                      onPressed:
                          state.isLoading ||
                              state.isSubmitting ||
                              !state.hasActiveLocation
                          ? null
                          : () {
                              context.read<ManageAttendanceBloc>().add(
                                const ManageAttendanceSubmitted(),
                              );
                            },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildActiveLocationCard({
    required BuildContext context,
    required ManageAttendanceState state,
    required ColorScheme colorScheme,
    required TextTheme textTheme,
  }) {
    final activeLocation = state.activeLocation;

    return Card(
      color: colorScheme.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: state.isLoading
            ? Row(
                children: [
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Memuat lokasi aktif...',
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              )
            : activeLocation == null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Belum ada lokasi absensi aktif.',
                    style: textTheme.titleMedium?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Pilih satu lokasi aktif terlebih dahulu sebelum melakukan absensi.',
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: () async {
                      await Navigator.of(
                        context,
                      ).pushNamed(AppRoutes.manageLocation);

                      if (!context.mounted) {
                        return;
                      }

                      context.read<ManageAttendanceBloc>().add(
                        const ManageAttendanceRequested(),
                      );
                    },
                    icon: const Icon(Icons.place_outlined),
                    label: const Text('Atur Lokasi'),
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activeLocation.name,
                    style: textTheme.titleMedium?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Radius absensi ${_formatDistance(activeLocation.radiusMeter)}',
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${activeLocation.latitude.toStringAsFixed(6)}, ${activeLocation.longitude.toStringAsFixed(6)}',
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildLogContent({
    required ManageAttendanceState state,
    required ColorScheme colorScheme,
    required TextTheme textTheme,
  }) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.logs.isEmpty) {
      final message =
          state.status == ManageAttendanceStatus.failure &&
              state.message.isNotEmpty
          ? state.message
          : 'Belum ada riwayat absensi.';

      return Center(
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }

    return ListView.separated(
      itemCount: state.logs.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final log = state.logs[index];

        return Card(
          color: colorScheme.surface,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: colorScheme.outlineVariant),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            log.locationName,
                            style: textTheme.titleMedium?.copyWith(
                              color: colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            _formatDateTime(log.attendanceTime),
                            style: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    _buildStatusChip(
                      log: log,
                      colorScheme: colorScheme,
                      textTheme: textTheme,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Jarak ${_formatDistance(log.distanceMeter)} dari radius ${_formatDistance(log.allowedRadiusMeter)}',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Akurasi GPS ${_formatDistance(log.gpsAccuracyMeter)}',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                if (log.rejectionReason != null &&
                    log.rejectionReason!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    log.rejectionReason!,
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.error,
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusChip({
    required AttendanceLog log,
    required ColorScheme colorScheme,
    required TextTheme textTheme,
  }) {
    final isAccepted = log.isAccepted;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isAccepted
            ? colorScheme.primaryContainer
            : colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        isAccepted ? 'Diterima' : 'Ditolak',
        style: textTheme.labelLarge?.copyWith(
          color: isAccepted ? colorScheme.primary : colorScheme.error,
        ),
      ),
    );
  }

  String _formatDateTime(DateTime value) {
    return AppDateTimeFormatter.formatDateTimeUtcPlus7(value);
  }

  String _formatDistance(double meter) {
    if (meter >= 1000) {
      return '${(meter / 1000).toStringAsFixed(2)} km';
    }

    return '${meter.toStringAsFixed(1)} m';
  }

  Future<void> _showEnableGpsDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Aktifkan GPS'),
          content: const Text(
            'GPS perangkat belum aktif. Aktifkan GPS untuk melakukan absensi.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Nanti'),
            ),
            FilledButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                await Geolocator.openLocationSettings();
              },
              child: const Text('Aktifkan GPS'),
            ),
          ],
        );
      },
    );
  }
}
