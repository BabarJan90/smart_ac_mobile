import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_ac/app_theme.dart';
import 'package:smart_ac/features/dashboard/cubit/product_cubit.dart';

class ProductSidebarWidget extends StatelessWidget {
  const ProductSidebarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductCubit, ProductState>(
      builder: (context, state) {
        return Container(
          width: 220,
          decoration: BoxDecoration(
            color: AppTheme.surface,
            border: Border(left: BorderSide(color: AppTheme.border)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              Expanded(child: _buildBody(state)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader() => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      border: Border(bottom: BorderSide(color: AppTheme.border)),
    ),
    child: Row(
      children: [
        const Icon(
          Icons.shopping_bag_outlined,
          color: AppTheme.accent,
          size: 18,
        ),
        const SizedBox(width: 8),
        const Text(
          'Recommended',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );

  Widget _buildBody(ProductState state) => switch (state) {
    ProductInitial() => _buildEmpty(),
    ProductLoading() => _buildLoading(),
    ProductLoaded() => _buildProducts(state.recommendation.products),
    ProductError() => _buildError(state.message),
  };

  Widget _buildEmpty() => const Center(
    child: Padding(
      padding: EdgeInsets.all(16),
      child: Text(
        'Use the Assistant to get product recommendations',
        style: TextStyle(color: AppTheme.textSecond, fontSize: 12),
        textAlign: TextAlign.center,
      ),
    ),
  );

  Widget _buildLoading() =>
      const Center(child: CircularProgressIndicator(color: AppTheme.accent));

  Widget _buildError(String message) => Center(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        message,
        style: const TextStyle(color: AppTheme.danger, fontSize: 12),
        textAlign: TextAlign.center,
      ),
    ),
  );

  Widget _buildProducts(List<dynamic> products) {
    if (products.isEmpty) {
      return _buildEmpty();
    }
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: products.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) => _buildProductCard(products[index]),
    );
  }

  Widget _buildProductCard(dynamic product) => Container(
    decoration: BoxDecoration(
      color: AppTheme.surfaceLight,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppTheme.border),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Product Image
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
          child: Image.network(
            product.image,
            height: 120,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              height: 120,
              color: AppTheme.surface,
              child: const Icon(
                Icons.image_not_supported,
                color: AppTheme.textSecond,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                product.title,
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              // Price
              Text(
                '£${product.price.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: AppTheme.accent,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              // Rating
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 12),
                  const SizedBox(width: 2),
                  Text(
                    product.rating.toStringAsFixed(1),
                    style: const TextStyle(
                      color: AppTheme.textSecond,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              // Reason
              Text(
                product.reason,
                style: const TextStyle(
                  color: AppTheme.textSecond,
                  fontSize: 10,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
