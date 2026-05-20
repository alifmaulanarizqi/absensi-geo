import 'package:absensigeo/core/theme/app_color_scheme.dart';
import 'package:absensigeo/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

class ManageLocationPage extends StatelessWidget {
  const ManageLocationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = AppColorScheme.light;
    final textTheme = AppTypography.textTheme;

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
              const SizedBox(height: 12),
              Expanded(
                child: ListView.separated(
                  itemCount: _locationItems.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final location = _locationItems[index];

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
                              location.name,
                              style: textTheme.titleMedium?.copyWith(
                                color: colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              location.coordinate,
                              style: textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant,
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
              FilledButton(
                onPressed: () {},
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  textStyle: textTheme.titleMedium,
                ),
                child: const Text('Tambah Lokasi'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LocationItem {
  const _LocationItem({
    required this.name,
    required this.coordinate,
  });

  final String name;
  final String coordinate;
}

const List<_LocationItem> _locationItems = [
  _LocationItem(
    name: 'Kantor Pusat',
    coordinate: '-6.200000, 106.816666',
  ),
  _LocationItem(
    name: 'Warehouse',
    coordinate: '-6.174465, 106.822745',
  ),
  _LocationItem(
    name: 'Cabang Selatan',
    coordinate: '-6.261493, 106.810600',
  ),
];
