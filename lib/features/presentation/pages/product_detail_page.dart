import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:taptap_task_kashif/core/widgets/sidebar.dart';
import 'package:taptap_task_kashif/features/presentation/cubits/product_cubit.dart';
import 'package:taptap_task_kashif/features/presentation/cubits/theme_cubit.dart';
import 'package:taptap_task_kashif/features/presentation/widgets/add_product_modal.dart';
import 'package:taptap_task_kashif/features/product/domain/entities/product_entity.dart';

class ProductDetailPage extends StatelessWidget {
  final String productId;

  const ProductDetailPage({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.select((ThemeCubit cubit) => cubit.state.isDarkMode);
    
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 768;
        
        if (isMobile) {
          return _buildMobileView(context, isDarkMode);
        } else {
          return _buildDesktopView(context, isDarkMode);
        }
      },
    );
  }

  Widget _buildDesktopView(BuildContext context, bool isDarkMode) {
    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF111827) : const Color(0xFFF9FAFB),
      body: Row(
        children: [
          const Sidebar(),
          Expanded(
            child: FutureBuilder<ProductEntity>(
              future: context.read<ProductCubit>().getProductById(productId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: isDarkMode ? const Color(0xFF60A5FA) : const Color(0xFF3B82F6),
                    ),
                  );
                }

                if (snapshot.hasError || !snapshot.hasData) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64,
                            color: isDarkMode ? const Color(0xFFF87171) : const Color(0xFFDC2626),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Product not found',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: isDarkMode ? const Color(0xFFF87171) : const Color(0xFFDC2626),
                            ),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () {
                              GoRouter.of(context).go('/products');
                            },
                            child: const Text('Back to Products'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final product = snapshot.data!;

                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () {
                                    GoRouter.of(context).go('/products');
                                  },
                                  icon: const Icon(Icons.arrow_back),
                                  label: const Text('Back'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: isDarkMode ? const Color(0xFF374151) : const Color(0xFFF3F4F6),
                                    foregroundColor: isDarkMode ? const Color(0xFFD1D5DB) : const Color(0xFF374151),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  product.name,
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: isDarkMode ? Colors.white : const Color(0xFF111827),
                                  ),
                                ),
                              ],
                            ),
                            ElevatedButton.icon(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AddProductModal(product: product),
                                );
                              },
                              icon: const Icon(Icons.edit),
                              label: const Text('Edit Product'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isDarkMode ? const Color(0xFF3B82F6) : const Color(0xFF3B82F6),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        Card(
                          color: isDarkMode ? const Color(0xFF1F2937) : Colors.white,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: isDarkMode ? const Color(0xFF374151) : const Color(0xFFE5E7EB),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (product.imageUrl != null)
                                      Container(
                                        width: 300,
                                        height: 300,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12),
                                          image: DecorationImage(
                                            image: NetworkImage(product.imageUrl!),
                                            fit: BoxFit.cover,
                                          ),
                                          border: Border.all(
                                            color: isDarkMode ? const Color(0xFF374151) : const Color(0xFFE5E7EB),
                                          ),
                                        ),
                                      ),
                                    SizedBox(width: product.imageUrl != null ? 24 : 0),

                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          _buildDetailRowDesktop('ID:', product.id, isDarkMode),
                                          _buildDetailRowDesktop('Category:', product.category, isDarkMode),
                                          _buildDetailRowDesktop('Price:', '\$${product.price.toStringAsFixed(2)}', isDarkMode),
                                          _buildDetailRowDesktop('Stock:', '${product.stock} units', isDarkMode),
                                          const SizedBox(height: 16),
                                          Chip(
                                            label: Text(
                                              product.isInStock ? 'In Stock' : 'Out of Stock',
                                              style: TextStyle(
                                                color: product.isInStock ? Colors.green : Colors.red,
                                              ),
                                            ),
                                            backgroundColor: product.isInStock
                                                ? Colors.green.withOpacity(isDarkMode ? 0.2 : 0.1)
                                                : Colors.red.withOpacity(isDarkMode ? 0.2 : 0.1),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 32),
                                Text(
                                  'Description',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: isDarkMode ? Colors.white : const Color(0xFF111827),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  product.description,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: isDarkMode ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
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
      ),
    );
  }

  Widget _buildMobileView(BuildContext context, bool isDarkMode) {
    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF111827) : const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: isDarkMode ? const Color(0xFF1F2937) : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDarkMode ? Colors.white : const Color(0xFF111827),
          ),
          onPressed: () {
            GoRouter.of(context).go('/products');
          },
        ),
        title: Text(
          'Product Details',
          style: TextStyle(
            color: isDarkMode ? Colors.white : const Color(0xFF111827),
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.edit,
              color: isDarkMode ? const Color(0xFF60A5FA) : const Color(0xFF3B82F6),
            ),
            onPressed: () {
              context.read<ProductCubit>().getProductById(productId).then((product) {
                showDialog(
                  context: context,
                  builder: (context) => AddProductModal(product: product),
                );
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<ProductEntity>(
        future: context.read<ProductCubit>().getProductById(productId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: isDarkMode ? const Color(0xFF60A5FA) : const Color(0xFF3B82F6),
              ),
            );
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: isDarkMode ? const Color(0xFFF87171) : const Color(0xFFDC2626),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Product not found',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: isDarkMode ? const Color(0xFFF87171) : const Color(0xFFDC2626),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        GoRouter.of(context).go('/products');
                      },
                      child: const Text('Back to Products'),
                    ),
                  ],
                ),
              ),
            );
          }

          final product = snapshot.data!;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: isDarkMode ? const Color(0xFF374151) : const Color(0xFFE5E7EB),
                        ),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? Colors.white : const Color(0xFF111827),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: isDarkMode ? const Color(0xFF374151) : const Color(0xFFF3F4F6),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'ID: ${product.id}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDarkMode ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Chip(
                              label: Text(
                                product.isInStock ? 'In Stock' : 'Out of Stock',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: product.isInStock ? Colors.green : Colors.red,
                                ),
                              ),
                              backgroundColor: product.isInStock
                                  ? Colors.green.withOpacity(isDarkMode ? 0.2 : 0.1)
                                  : Colors.red.withOpacity(isDarkMode ? 0.2 : 0.1),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  if (product.imageUrl != null)
                    Center(
                      child: Container(
                        width: 200,
                        height: 200,
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(
                            image: NetworkImage(product.imageUrl!),
                            fit: BoxFit.cover,
                          ),
                          border: Border.all(
                            color: isDarkMode ? const Color(0xFF374151) : const Color(0xFFE5E7EB),
                          ),
                        ),
                      ),
                    ),

                  Card(
                    color: isDarkMode ? const Color(0xFF1F2937) : Colors.white,
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(
                        color: isDarkMode ? const Color(0xFF374151) : const Color(0xFFE5E7EB),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDetailRowMobile('ID:', product.id, isDarkMode),
                          _buildDetailRowMobile('Category:', product.category, isDarkMode),
                          _buildDetailRowMobile('Price:', '\$${product.price.toStringAsFixed(2)}', isDarkMode),
                          _buildDetailRowMobile('Stock:', '${product.stock} units', isDarkMode),
                          const SizedBox(height: 20),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: isDarkMode ? const Color(0xFF374151) : const Color(0xFFF9FAFB),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isDarkMode ? const Color(0xFF4B5563) : const Color(0xFFE5E7EB),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Stock Status',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: isDarkMode ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
                                      ),
                                    ),
                                    Text(
                                      product.isInStock ? 'Available' : 'Unavailable',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: product.isInStock ? Colors.green : Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: product.isInStock
                                        ? Colors.green.withOpacity(isDarkMode ? 0.2 : 0.1)
                                        : Colors.red.withOpacity(isDarkMode ? 0.2 : 0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    '${product.stock} units',
                                    style: TextStyle(
                                      color: product.isInStock ? Colors.green : Colors.red,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          const SizedBox(height: 24),
                          Text(
                            'Description',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isDarkMode ? Colors.white : const Color(0xFF111827),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            product.description,
                            style: TextStyle(
                              fontSize: 14,
                              color: isDarkMode ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
                              height: 1.5,
                            ),
                          ),
                          
                          const SizedBox(height: 24),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AddProductModal(product: product),
                                    );
                                  },
                                  icon: const Icon(Icons.edit, size: 18),
                                  label: const Text('Edit Product'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: isDarkMode ? const Color(0xFF3B82F6) : const Color(0xFF3B82F6),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailRowDesktop(String label, String value, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isDarkMode ? const Color(0xFFD1D5DB) : const Color(0xFF374151),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: isDarkMode ? Colors.white : const Color(0xFF111827),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRowMobile(String label, String value, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isDarkMode ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: isDarkMode ? Colors.white : const Color(0xFF111827),
            ),
          ),
        ],
      ),
    );
  }
}