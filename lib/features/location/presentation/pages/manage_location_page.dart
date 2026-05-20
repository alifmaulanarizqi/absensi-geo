import 'package:absensigeo/core/theme/app_color_scheme.dart';
import 'package:absensigeo/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

class ManageLocationPage extends StatefulWidget {
  const ManageLocationPage({super.key});

  @override
  State<ManageLocationPage> createState() => _ManageLocationPageState();
}

class _ManageLocationPageState extends State<ManageLocationPage> {
  int _selectedLocationId = _locationItems.first.id;

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
              const SizedBox(height: 8),
              Text(
                'Pilih satu lokasi yang akan digunakan sebagai lokasi absensi.',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.separated(
                  itemCount: _locationItems.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final location = _locationItems[index];
                    final isSelected = location.id == _selectedLocationId;

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
                              location.coordinate,
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
                                        onPressed: () {
                                          setState(() {
                                            _selectedLocationId = location.id;
                                          });
                                        },
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: colorScheme.primary,
                                          side: BorderSide(
                                            color: colorScheme.primary,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                        ),
                                        child: const Text(
                                          'Pilih',
                                        ),
                                      ),
                              ],
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
    required this.id,
    required this.name,
    required this.coordinate,
  });

  final int id;
  final String name;
  final String coordinate;
}

const List<_LocationItem> _locationItems = [
  _LocationItem(
    id: 1,
    name: 'Kantor Pusat',
    coordinate: '-6.200000, 106.816666',
  ),
  _LocationItem(
    id: 2,
    name: 'Warehouse',
    coordinate: '-6.174465, 106.822745',
  ),
  _LocationItem(
    id: 3,
    name: 'Cabang Selatan',
    coordinate: '-6.261493, 106.810600',
  ),
];
