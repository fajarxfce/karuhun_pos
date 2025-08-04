import 'package:equatable/equatable.dart';

import 'product.dart';

class PaginatedProducts extends Equatable {
  final List<Product> data;
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;
  final int? from;
  final int? to;

  const PaginatedProducts({
    required this.data,
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
    this.from,
    this.to,
  });

  @override
  List<Object?> get props => [
    data,
    currentPage,
    lastPage,
    perPage,
    total,
    from,
    to,
  ];
}
