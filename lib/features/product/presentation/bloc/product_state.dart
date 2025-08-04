part of 'product_bloc.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object> get props => [];
}

class ProductInitial extends ProductState {
  const ProductInitial();
}

class ProductLoading extends ProductState {
  const ProductLoading();
}

class ProductLoaded extends ProductState {
  final List<Product> products;
  final bool hasReachedMax;
  final int currentPage;
  final int totalPages;
  final bool isLoadingMore;

  const ProductLoaded({
    required this.products,
    required this.hasReachedMax,
    required this.currentPage,
    required this.totalPages,
    this.isLoadingMore = false,
  });

  @override
  List<Object> get props => [
        products,
        hasReachedMax,
        currentPage,
        totalPages,
        isLoadingMore,
      ];

  ProductLoaded copyWith({
    List<Product>? products,
    bool? hasReachedMax,
    int? currentPage,
    int? totalPages,
    bool? isLoadingMore,
  }) {
    return ProductLoaded(
      products: products ?? this.products,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

class ProductError extends ProductState {
  final String message;

  const ProductError(this.message);

  @override
  List<Object> get props => [message];
}
