import 'package:absensigeo/core/di/service_locator.dart';
import 'package:absensigeo/core/error/failure.dart';
import 'package:absensigeo/core/theme/app_color_scheme.dart';
import 'package:absensigeo/core/theme/app_typography.dart';
import 'package:absensigeo/features/location/presentation/bloc/add_location/add_location_bloc.dart';
import 'package:absensigeo/shared/widgets/app_primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

class AddLocationPage extends StatelessWidget {
  const AddLocationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<AddLocationBloc>(),
      child: const _AddLocationView(),
    );
  }
}

class _AddLocationView extends StatelessWidget {
  const _AddLocationView();

  @override
  Widget build(BuildContext context) {
    final colorScheme = AppColorScheme.light;
    final textTheme = AppTypography.textTheme;

    return BlocListener<AddLocationBloc, AddLocationState>(
      listenWhen: (previous, current) =>
          previous.message != current.message ||
          previous.status != current.status,
      listener: (context, state) async {
        if (state.status == AddLocationStatus.success) {
          Navigator.of(context).pop(true);
          return;
        }

        if (state.failureCode == FailureCodes.gpsDisabled) {
          await _showEnableGpsDialog(context);
          return;
        }

        if (state.message.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );
        }
      },
      child: BlocBuilder<AddLocationBloc, AddLocationState>(
        builder: (context, state) {
          final coordinate = state.coordinate;

          return Scaffold(
            appBar: AppBar(
              title: const Text('Tambah Lokasi'),
            ),
            body: SafeArea(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Text(
                    'Informasi Lokasi',
                    style: textTheme.titleLarge?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Masukkan nama lokasi dan lakukan geotagging untuk menentukan titik lokasi absensi.',
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
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
                          Text(
                            'Nama Lokasi',
                            style: textTheme.titleMedium?.copyWith(
                              color: colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            onChanged: (value) {
                              context.read<AddLocationBloc>().add(
                                    AddLocationNameChanged(value),
                                  );
                            },
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                              hintText: 'Contoh: Kantor Pusat',
                              hintStyle: textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                              filled: true,
                              fillColor: colorScheme.surface,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                  color: colorScheme.outlineVariant,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                  color: colorScheme.outlineVariant,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                  color: colorScheme.primary,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
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
                          Text(
                            'Geotagging Lokasi',
                            style: textTheme.titleMedium?.copyWith(
                              color: colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Ambil koordinat lokasi saat ini untuk dijadikan titik lokasi absensi.',
                            style: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.place_outlined,
                                  size: 40,
                                  color: colorScheme.primary,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  coordinate == null
                                      ? 'Koordinat belum diambil'
                                      : '${coordinate.latitude.toStringAsFixed(6)}, ${coordinate.longitude.toStringAsFixed(6)}',
                                  style: textTheme.titleSmall?.copyWith(
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  coordinate == null
                                      ? 'Tekan tombol di bawah untuk mengambil titik lokasi.'
                                      : 'Akurasi GPS ${coordinate.accuracyMeter.toStringAsFixed(1)} meter',
                                  textAlign: TextAlign.center,
                                  style: textTheme.bodySmall?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          OutlinedButton.icon(
                            onPressed:
                                state.isFetchingLocation || state.isSaving
                                    ? null
                                    : () {
                                        context.read<AddLocationBloc>().add(
                                              const AddLocationCurrentLocationRequested(),
                                            );
                                      },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: colorScheme.primary,
                              side: BorderSide(color: colorScheme.primary),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              textStyle: textTheme.titleSmall,
                            ),
                            icon: const Icon(Icons.my_location_outlined),
                            label: Text(
                              state.isFetchingLocation
                                  ? 'Mengambil Lokasi...'
                                  : 'Ambil Lokasi Saat Ini',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  AppPrimaryButton(
                    label: state.isSaving ? 'Menyimpan...' : 'Simpan Lokasi',
                    onPressed: state.isSaving
                        ? null
                        : () {
                            context.read<AddLocationBloc>().add(
                                  const AddLocationSubmitted(),
                                );
                          },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _showEnableGpsDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Aktifkan GPS'),
          content: const Text(
            'GPS perangkat belum aktif. Aktifkan GPS untuk mengambil lokasi saat ini.',
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
