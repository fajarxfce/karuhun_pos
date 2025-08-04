import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/paginated_products.dart';
import '../../domain/entities/product.dart';
import '../../domain/usecases/get_products_usecase.dart';

part 'product_event.dart';
part 'product_state.dart';

@injectable
class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetProductsUseCase getProductsUseCase;

  ProductBloc({required this.getProductsUseCase})
    : super(const ProductInitial()) {
    on<LoadProducts>(_onLoadProducts);
    on<LoadMoreProducts>(_onLoadMoreProducts);
    on<RefreshProducts>(_onRefreshProducts);
  }

  Future<void> _onLoadProducts(
    LoadProducts event,
    Emitter<ProductState> emit,
  ) async {
    if (event.refresh || state is ProductInitial) {
      emit(const ProductLoading());
    }

    final result = await getProductsUseCase(const GetProductsParams(page: 1));

    result.fold(
      (failure) => emit(ProductError(_mapFailureToMessage(failure))),
      (paginatedProducts) => emit(
        ProductLoaded(
          products: paginatedProducts.data,
          hasReachedMax:
              paginatedProducts.currentPage >= paginatedProducts.lastPage,
          currentPage: paginatedProducts.currentPage,
          totalPages: paginatedProducts.lastPage,
        ),
      ),
    );
  }

  Future<void> _onLoadMoreProducts(
    LoadMoreProducts event,
    Emitter<ProductState> emit,
  ) async {
    if (state is ProductLoaded) {
      final currentState = state as ProductLoaded;

      if (currentState.hasReachedMax || currentState.isLoadingMore) {
        return;
      }

      emit(currentState.copyWith(isLoadingMore: true));

      final result = await getProductsUseCase(
        GetProductsParams(page: currentState.currentPage + 1),
      );

      result.fold(
        (failure) => emit(ProductError(_mapFailureToMessage(failure))),
        (paginatedProducts) {
          final allProducts = List<Product>.from(currentState.products)
            ..addAll(paginatedProducts.data);

          emit(
            ProductLoaded(
              products: allProducts,
              hasReachedMax:
                  paginatedProducts.currentPage >= paginatedProducts.lastPage,
              currentPage: paginatedProducts.currentPage,
              totalPages: paginatedProducts.lastPage,
            ),
          );
        },
      );
    }
  }

  Future<void> _onRefreshProducts(
    RefreshProducts event,
    Emitter<ProductState> emit,
  ) async {
    add(const LoadProducts(refresh: true));
  }

  String _mapFailureToMessage(Failure failure) {
    debugPrint(
      'Mapping failure: ${failure.runtimeType} - ${failure.toString()}',
    );

    if (failure is UnauthorizedFailure) {
      return 'Sesi Anda telah berakhir, silakan login kembali';
    } else if (failure is ValidationFailure) {
      return failure.message;
    } else if (failure is NetworkFailure) {
      return 'Tidak ada koneksi internet';
    } else if (failure is ServerFailure) {
      String message = failure.message;
      if (message.contains('ServerException:')) {
        message = message.replaceAll('ServerException:', '').trim();
      }
      if (message.contains('Unexpected error occurred:')) {
        message = message.replaceAll('Unexpected error occurred:', '').trim();
      }
      return message.isNotEmpty ? message : 'Terjadi kesalahan pada server';
    } else {
      return 'Terjadi kesalahan yang tidak terduga';
    }
  }
}
