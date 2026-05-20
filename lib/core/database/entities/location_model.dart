import 'package:floor/floor.dart';

@Entity(
  tableName: 'locations',
  indices: [
    Index(value: ['name']),
  ],
)

class LocationModel {
  const LocationModel({
    this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.radiusMeter,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  @primaryKey
  @ColumnInfo(name: 'id')
  final int? id;

  @ColumnInfo(name: 'name')
  final String name;
  @ColumnInfo(name: 'latitude')
  final double latitude;
  @ColumnInfo(name: 'longitude')
  final double longitude;

  @ColumnInfo(name: 'radius_meter')
  final double radiusMeter;

  @ColumnInfo(name: 'is_active')
  final bool isActive;

  @ColumnInfo(name: 'created_at')
  final DateTime createdAt;

  @ColumnInfo(name: 'updated_at')
  final DateTime updatedAt;
}
