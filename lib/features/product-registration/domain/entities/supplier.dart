import 'package:equatable/equatable.dart';

class Supplier extends Equatable {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String address;
  final List<String> categoryIds;
  final double discountRate;

  const Supplier({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.categoryIds,
    required this.discountRate,
  });

  @override
  List<Object> get props => [
    id,
    name,
    email,
    phone,
    address,
    categoryIds,
    discountRate,
  ];
}
