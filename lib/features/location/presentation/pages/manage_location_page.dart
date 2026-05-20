import 'package:absensigeo/core/di/service_locator.dart';
import 'package:absensigeo/core/navigation/app_router.dart';
import 'package:absensigeo/core/theme/app_color_scheme.dart';
import 'package:absensigeo/core/theme/app_typography.dart';
import 'package:absensigeo/features/location/domain/entities/location.dart';
import 'package:absensigeo/features/location/presentation/bloc/manage_location/manage_location_bloc.dart';
import 'package:absensigeo/shared/widgets/app_primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ManageLocationPage extends StatelessWidget {
  const ManageLocationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<ManageLocationBloc>()
        ..add(const ManageLocationRequested()),
      child: const _ManageLocationView(),
    );
  }
}

class _ManageLocationView extends StatelessWidget {
  const _ManageLocationView();

  @override
  Widget build(BuildContext context) {
    final colorScheme = AppColorScheme.light;
    final textTheme = AppTypography.textTheme;

    return BlocListener<ManageLocationBloc, ManageLocationState>(
      listenWhen: (previous, current) =>
          previous.message != current.message && current.message.isNotEmpty,
      listener: (context, state) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.message),
          ),
        );
      },
      child: BlocBuilder<ManageLocationBloc, ManageLocationState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Manage Location'),
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'List Lokasi',
                      style: textTheme.titleLarge?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Pilih satu lokasi yang akan digunakan sebagai lokasi absensi.',
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: _buildContent(
                        context: context,
                        state: state,
                        colorScheme: colorScheme,
                        textTheme: textTheme,
                      ),
                    ),
                    const SizedBox(height: 16),
                    AppPrimaryButton(
                      label: 'Tambah Lokasi',
                      onPressed: () async {
                        final result = await Navigator.of(context).pushNamed(
                          AppRoutes.addLocation,
                        );

                        if (!context.mounted) {
                          return;
                        }

                        if (result == true) {
                          context.read<ManageLocationBloc>().add(
                                const ManageLocationRequested(),
                              );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Lokasi berhasil ditambahkan.'),
                            ),
                          );
                        }
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

  Widget _buildContent({
    required BuildContext context,
    required ManageLocationState state,
    required ColorScheme colorScheme,
    required TextTheme textTheme,
  }) {
    if (state.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (state.locations.isEmpty) {
      final message = state.status == ManageLocationStatus.failure
          ? state.message
          : 'Belum ada lokasi tersimpan.';

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
      itemCount: state.locations.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final location = state.locations[index];
        final isSelected = location.isActive;

        return Card(
          color: isSelected
              ? colorScheme.primaryContainer
              : colorScheme.surface,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: isSelected
                  ? colorScheme.primary
                  : colorScheme.outlineVariant,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  location.name,
                  style: textTheme.titleMedium?.copyWith(
                    color: isSelected
                        ? colorScheme.onPrimaryContainer
                        : colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _formatCoordinate(location),
                  style: textTheme.bodyMedium?.copyWith(
                    color: isSelected
                        ? colorScheme.onPrimaryContainer
                        : colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        isSelected
                            ? 'Lokasi absensi aktif'
                            : 'Belum dipilih sebagai lokasi absensi',
                        style: textTheme.labelLarge?.copyWith(
                          color: isSelected
                              ? colorScheme.primary
                              : colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    isSelected
                        ? Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.primary,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              'Dipilih',
                              style: textTheme.labelLarge?.copyWith(
                                color: colorScheme.onPrimary,
                              ),
                            ),
                          )
                        : OutlinedButton(
                            onPressed: state.isUpdating || location.id == null
                                ? null
                                : () {
                                    context.read<ManageLocationBloc>().add(
                                          ManageLocationActiveLocationChanged(
                                            location.id!,
                                          ),
                                        );
                                  },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: colorScheme.primary,
                              side: BorderSide(
                                color: colorScheme.primary,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text('Pilih'),
                          ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatCoordinate(Location location) {
    return '${location.latitude.toStringAsFixed(6)}, ${location.longitude.toStringAsFixed(6)}';
  }
}
