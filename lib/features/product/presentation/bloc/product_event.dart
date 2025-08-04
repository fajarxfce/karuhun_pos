part of 'product_bloc.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}

class LoadProducts extends ProductEvent {
  final bool refresh;

  const LoadProducts({this.refresh = false});

  @override
  List<Object> get props => [refresh];
}

class LoadMoreProducts extends ProductEvent {
  const LoadMoreProducts();
}

class RefreshProducts extends ProductEvent {
  const RefreshProducts();
}
