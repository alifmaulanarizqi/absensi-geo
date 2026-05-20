import 'package:equatable/equatable.dart';

class Location extends Equatable {
  const Location({
    this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.radiusMeter,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  final int? id;
  final String name;
  final double latitude;
  final double longitude;
  final double radiusMeter;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  Location copyWith({
    int? id,
    String? name,
    double? latitude,
    double? longitude,
    double? radiusMeter,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Location(
      id: id ?? this.id,
      name: name ?? this.name,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      radiusMeter: radiusMeter ?? this.radiusMeter,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        latitude,
        longitude,
        radiusMeter,
        isActive,
        createdAt,
        updatedAt,
      ];
}
