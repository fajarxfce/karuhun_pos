import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;

  const ProductCard({super.key, required this.product, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 80,
                  height: 80,
                  color: Colors.grey[200],
                  child: product.media.isNotEmpty
                      ? Image.network(
                          'http://192.168.1.19:8000${product.media.first.originalUrl}',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return _buildPlaceholder();
                          },
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const Center(
                              child: CircularProgressIndicator(strokeWidth: 2),
                            );
                          },
                        )
                      : _buildPlaceholder(),
                ),
              ),

              const SizedBox(width: 12),

              // Product Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Name
                    Text(
                      product.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 4),

                    // SKU
                    Text(
                      'SKU: ${product.sku}',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                    ),

                    const SizedBox(height: 8),

                    // Price and Stock Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Price
                        Text(
                          _formatCurrency(product.price),
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                        ),

                        // Stock
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _getStockColor(
                              product.stock,
                            ).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _getStockColor(product.stock),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            'Stock: ${product.stock}',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: _getStockColor(product.stock),
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Category and Brand
                    if (product.category != null || product.merk != null)
                      Wrap(
                        spacing: 8,
                        children: [
                          if (product.category != null)
                            Chip(
                              label: Text(
                                product.category!.name,
                                style: const TextStyle(fontSize: 11),
                              ),
                              backgroundColor: Colors.blue[50],
                              side: BorderSide(color: Colors.blue[200]!),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              visualDensity: VisualDensity.compact,
                            ),
                          if (product.merk != null)
                            Chip(
                              label: Text(
                                product.merk!.name,
                                style: const TextStyle(fontSize: 11),
                              ),
                              backgroundColor: Colors.green[50],
                              side: BorderSide(color: Colors.green[200]!),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              visualDensity: VisualDensity.compact,
                            ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: 80,
      height: 80,
      color: Colors.grey[200],
      child: Icon(Icons.image_outlined, size: 32, color: Colors.grey[400]),
    );
  }

  String _formatCurrency(int amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  Color _getStockColor(int stock) {
    if (stock == 0) {
      return Colors.red;
    } else if (stock < 10) {
      return Colors.orange;
    } else {
      return Colors.green;
    }
  }
}
