import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final String id;
  final String name;
  final String description;
  final bool requiresWeight;
  final bool requiresExpiry;
  final List<String> allowedUnits;
  final double? taxRate;

  const Category({
    required this.id,
    required this.name,
    required this.description,
    required this.requiresWeight,
    required this.requiresExpiry,
    required this.allowedUnits,
    this.taxRate,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    requiresWeight,
    requiresExpiry,
    allowedUnits,
    taxRate,
  ];
}
