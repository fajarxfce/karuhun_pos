import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import 'package:go_router/go_router.dart';
import '../../../../core/di/injection.dart';
import '../../domain/entities/product.dart';
import '../../domain/usecases/get_products_usecase.dart';
import '../widgets/product_card.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class ProductListView extends StatefulWidget {
  const ProductListView({super.key});

  @override
  State<ProductListView> createState() => _ProductListViewState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Produk'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Tambah produk - Coming soon!')),
              );
            },
          ),
        ],
      ),
      body: const ProductListView(),
    );
  }
}

class _ProductListViewState extends State<ProductListView> {
  static const _pageSize = 10;

  final PagingController<int, Product> _pagingController = PagingController(
    firstPageKey: 1,
  );

  late final GetProductsUseCase _getProductsUseCase;

  @override
  void initState() {
    super.initState();
    _getProductsUseCase = getIt<GetProductsUseCase>();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final result = await _getProductsUseCase(
        GetProductsParams(
          page: pageKey,
          perPage: _pageSize,
          orderBy: 'products.id',
          order: 'asc',
        ),
      );

      result.fold(
        (failure) {
          _pagingController.error = failure.toString();
        },
        (paginatedProducts) {
          final newItems = paginatedProducts.data;
          final isLastPage = pageKey >= paginatedProducts.lastPage;

          if (isLastPage) {
            _pagingController.appendLastPage(newItems);
          } else {
            final nextPageKey = pageKey + 1;
            _pagingController.appendPage(newItems, nextPageKey);
          }
        },
      );
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Produk'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Tambah produk - Coming soon!')),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => Future.sync(() => _pagingController.refresh()),
        child: PagedListView<int, Product>(
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate<Product>(
            itemBuilder: (context, product, index) => Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
              child: ProductCard(
                product: product,
                onTap: () => _onProductTap(context, product),
              ),
            ),
            firstPageErrorIndicatorBuilder: (context) => _buildErrorState(
              context,
              _pagingController.error.toString(),
              () => _pagingController.refresh(),
            ),
            newPageErrorIndicatorBuilder: (context) => _buildErrorState(
              context,
              _pagingController.error.toString(),
              () => _pagingController.retryLastFailedRequest(),
            ),
            noItemsFoundIndicatorBuilder: (context) =>
                _buildEmptyState(context),
            firstPageProgressIndicatorBuilder: (context) =>
                const Center(child: CircularProgressIndicator()),
            newPageProgressIndicatorBuilder: (context) => const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(
    BuildContext context,
    String error,
    VoidCallback onRetry,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
          const SizedBox(height: 16),
          Text(
            'Oops! Terjadi kesalahan',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            error,
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Coba Lagi'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Belum ada produk',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            'Tambahkan produk pertama Anda',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              // TODO: Navigate to add product page
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Tambah produk - Coming soon!')),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('Tambah Produk'),
          ),
        ],
      ),
    );
  }

  void _onProductTap(BuildContext context, Product product) {
    context.pushNamed(
      'product-detail',
      pathParameters: {'id': product.id.toString()},
      extra: product,
    );
  }
}
