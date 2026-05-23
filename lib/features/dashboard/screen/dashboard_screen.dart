import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_ac/app_theme.dart';
import 'package:smart_ac/features/dashboard/cubit/dashboard_cubit.dart';
import 'package:smart_ac/features/dashboard/cubit/product_cubit.dart';
import 'package:smart_ac/features/dashboard/view/dashboard_stats_view.dart';
import 'package:smart_ac/features/dashboard/view/product_sidebar_widget.dart';
import 'package:smart_ac/features/transactions/view/transaction_item_view.dart';
import 'package:smart_ac/widgets.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    context.read<DashboardCubit>().load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<DashboardCubit, DashboardState>(
        builder: (context, state) {
          return switch (state) {
            DashboardInitial() => const SizedBox.shrink(),
            DashboardLoading() => _buildLoading(),
            DashboardLoaded() => _buildContent(state),
            DashboardError() => _buildError(state.message),
          };
        },
      ),
    );
  }

  Widget _buildLoading() => ListView(
    padding: const EdgeInsets.all(24),
    children: [
      const LoadingCard(height: 100),
      const SizedBox(height: 16),
      GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.0,
        children: List.generate(4, (_) => const LoadingCard()),
      ),
    ],
  );

  Widget _buildError(String message) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.error_outline, color: AppTheme.danger, size: 48),
        const SizedBox(height: 16),
        Text(
          message,
          style: const TextStyle(color: AppTheme.textSecond),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: () => context.read<DashboardCubit>().load(),
          icon: const Icon(Icons.refresh, size: 16),
          label: const Text('Retry'),
        ),
      ],
    ),
  );

  // Widget _buildContent(DashboardLoaded state) => Row(
  //   crossAxisAlignment: CrossAxisAlignment.start,
  //   children: [
  //     // ── Main Content ────────────────────────────────────────────
  //     Expanded(
  //       child: RefreshIndicator(
  //         onRefresh: () => context.read<DashboardCubit>().load(),
  //         color: AppTheme.accent,
  //         child: ListView(
  //           padding: const EdgeInsets.all(24),
  //           children: [
  //             _buildHeader(),
  //             const SizedBox(height: 28),
  //             DashboardStatsView(stats: state.stats),
  //             const SizedBox(height: 28),
  //             SectionHeader(
  //               title: 'Recent Transactions',
  //               subtitle: 'Latest 5 entries',
  //               action: TextButton(
  //                 onPressed: () {},
  //                 child: const Text('View all'),
  //               ),
  //             ),
  //             const SizedBox(height: 16),
  //             ...state.recentTransactions.items.map(
  //               (t) => TransactionItemView(transaction: t),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //     BlocBuilder<ProductCubit, ProductState>(
  //       builder: (context, productState) {
  //         if (productState is ProductLoaded &&
  //             productState.recommendation.products.isNotEmpty) {
  //           return const ProductSidebarWidget();
  //         }
  //         return const SizedBox.shrink();
  //       },
  //     ),
  //   ],
  // );

  Widget _buildContent(DashboardLoaded state) {
    final isWide = MediaQuery.of(context).size.width > 700;

    return BlocBuilder<ProductCubit, ProductState>(
      builder: (context, productState) {
        final hasProducts =
            productState is ProductLoaded &&
            productState.recommendation.products.isNotEmpty;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Main Content ──────────────────────────────────
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => context.read<DashboardCubit>().load(),
                color: AppTheme.accent,
                child: ListView(
                  padding: const EdgeInsets.all(24),
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 28),

                    // ── Mobile horizontal product list ────────
                    if (!isWide && hasProducts) ...[
                      _buildMobileHorizontalProducts(
                        (productState as ProductLoaded).recommendation.products,
                      ),
                      const SizedBox(height: 28),
                    ],

                    DashboardStatsView(stats: state.stats),
                    const SizedBox(height: 28),
                    SectionHeader(
                      title: 'Recent Transactions',
                      subtitle: 'Latest 5 entries',
                      action: TextButton(
                        onPressed: () {},
                        child: const Text('View all'),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...state.recentTransactions.items.map(
                      (t) => TransactionItemView(transaction: t),
                    ),
                  ],
                ),
              ),
            ),

            // ── Web sidebar ───────────────────────────────────
            if (isWide && hasProducts) const ProductSidebarWidget(),
          ],
        );
      },
    );
  }

  Widget _buildMobileHorizontalProducts(List<dynamic> products) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.shopping_bag_outlined,
              color: AppTheme.accent,
              size: 16,
            ),
            const SizedBox(width: 6),
            const Text(
              'Recommended for You',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 160,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final product = products[index];
              return GestureDetector(
                onTap: () => _showSingleProduct(context, product),
                child: Container(
                  width: 110,
                  decoration: BoxDecoration(
                    color: AppTheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                        child: Image.network(
                          product.image,
                          height: 80,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            height: 80,
                            color: AppTheme.surfaceLight,
                            child: const Icon(
                              Icons.image_not_supported,
                              color: AppTheme.textSecond,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.title,
                              style: const TextStyle(
                                color: AppTheme.textPrimary,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '£${product.price.toStringAsFixed(0)}',
                              style: const TextStyle(
                                color: AppTheme.accent,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _showSingleProduct(BuildContext context, dynamic product) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                product.image,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              product.title,
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '£${product.price.toStringAsFixed(2)}',
              style: const TextStyle(
                color: AppTheme.accent,
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 14),
                const SizedBox(width: 4),
                Text(
                  product.rating.toStringAsFixed(1),
                  style: const TextStyle(
                    color: AppTheme.textSecond,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              product.reason,
              style: const TextStyle(
                color: AppTheme.textSecond,
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() => Row(
    children: [
      Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppTheme.accentGlow,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          Icons.account_balance,
          color: AppTheme.accent,
          size: 22,
        ),
      ),
      const SizedBox(width: 12),
      const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SmartAC',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            'AI Accounting Dashboard',
            style: TextStyle(color: AppTheme.textSecond, fontSize: 13),
          ),
        ],
      ),
      const Spacer(),
      IconButton(
        onPressed: () => context.read<DashboardCubit>().load(),
        icon: const Icon(Icons.refresh, color: AppTheme.textSecond),
        tooltip: 'Refresh',
      ),
    ],
  );
}
