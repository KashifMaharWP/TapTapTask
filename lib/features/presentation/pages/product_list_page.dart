import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taptap_task_kashif/core/widgets/product_filters.dart';
import 'package:taptap_task_kashif/core/widgets/responsive_layout.dart';
import 'package:taptap_task_kashif/core/widgets/sidebar.dart';
import 'package:taptap_task_kashif/features/presentation/cubits/product_cubit.dart';
import 'package:taptap_task_kashif/features/presentation/cubits/theme_cubit.dart';
import 'package:taptap_task_kashif/features/presentation/widgets/add_product_modal.dart';
import 'package:taptap_task_kashif/features/presentation/widgets/product_table.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = '';
  bool _inStockOnly = false;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.select((ThemeCubit cubit) => cubit.state.isDarkMode);
    
    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF111827) : const Color(0xFFF9FAFB),
      body: ResponsiveLayout(
        sidebar: const Sidebar(),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isMobile = constraints.maxWidth < 768;
            
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(isMobile ? 16.0 : 24.0),
                  child: isMobile
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Products',
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: isDarkMode ? Colors.white : const Color(0xFF111827),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () => _showAddProductModal(context),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: isDarkMode ? const Color(0xFF3B82F6) : const Color(0xFF3B82F6),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Icon(Icons.add, size: 20),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Container(
                              decoration: BoxDecoration(
                                color: isDarkMode ? const Color(0xFF374151) : Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: isDarkMode ? const Color(0xFF4B5563) : const Color(0xFFE5E7EB),
                                ),
                              ),
                              child: TextField(
                                controller: _searchController,
                                decoration: InputDecoration(
                                  hintText: 'Search products...',
                                  hintStyle: TextStyle(
                                    color: isDarkMode ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
                                  ),
                                  prefixIcon: Icon(
                                    Icons.search,
                                    color: isDarkMode ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
                                  ),
                                  filled: true,
                                  fillColor: Colors.transparent,
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                ),
                                style: TextStyle(
                                  color: isDarkMode ? Colors.white : const Color(0xFF111827),
                                ),
                                onChanged: (value) => _applyFilters(),
                              ),
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Products',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: isDarkMode ? Colors.white : const Color(0xFF111827),
                              ),
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 300,
                                  child: TextField(
                                    controller: _searchController,
                                    decoration: InputDecoration(
                                      hintText: 'Search products...',
                                      hintStyle: TextStyle(
                                        color: isDarkMode ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
                                      ),
                                      prefixIcon: Icon(
                                        Icons.search,
                                        color: isDarkMode ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
                                      ),
                                      filled: true,
                                      fillColor: isDarkMode ? const Color(0xFF374151) : Colors.white,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(
                                          color: isDarkMode ? const Color(0xFF4B5563) : const Color(0xFFE5E7EB),
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(
                                          color: isDarkMode ? const Color(0xFF4B5563) : const Color(0xFFE5E7EB),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(
                                          color: isDarkMode ? const Color(0xFF60A5FA) : const Color(0xFF3B82F6),
                                        ),
                                      ),
                                    ),
                                    style: TextStyle(
                                      color: isDarkMode ? Colors.white : const Color(0xFF111827),
                                    ),
                                    onChanged: (value) => _applyFilters(),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                ElevatedButton.icon(
                                  onPressed: () => _showAddProductModal(context),
                                  icon: const Icon(Icons.add),
                                  label: const Text('Add Product'),
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
                          ],
                        ),
                ),

                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 16.0 : 24.0,
                    vertical: isMobile ? 8.0 : 0,
                  ),
                  child: ProductFilters(
                    onCategoryChanged: (category) {
                      _selectedCategory = category;
                      _applyFilters();
                    },
                    onStockFilterChanged: (inStockOnly) {
                      _inStockOnly = inStockOnly;
                      _applyFilters();
                    },
                  ),
                ),

                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 16.0 : 24.0,
                      vertical: isMobile ? 8.0 : 0,
                    ),
                    child: Card(
                      color: isDarkMode ? const Color(0xFF1F2937) : Colors.white,
                      elevation: isMobile ? 1 : 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(isMobile ? 8 : 12),
                        side: BorderSide(
                          color: isDarkMode ? const Color(0xFF374151) : const Color(0xFFE5E7EB),
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(isMobile ? 8 : 12),
                          color: isDarkMode ? const Color(0xFF1F2937) : Colors.white,
                        ),
                        child: BlocBuilder<ProductCubit, ProductState>(
                          builder: (context, state) {
                            if (state is ProductLoading) {
                              return Center(
                                child: CircularProgressIndicator(
                                  color: isDarkMode ? const Color(0xFF60A5FA) : const Color(0xFF3B82F6),
                                ),
                              );
                            }

                            if (state is ProductError) {
                              return Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Text(
                                    state.message,
                                    style: TextStyle(
                                      color: isDarkMode ? const Color(0xFFF87171) : const Color(0xFFDC2626),
                                    ),
                                  ),
                                ),
                              );
                            }

                            if (state is ProductLoaded) {
                              return ProductTable(products: state.products);
                            }

                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.inventory_2_outlined,
                                      size: 48,
                                      color: isDarkMode ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'No products available',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: isDarkMode ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Add your first product to get started',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: isDarkMode ? const Color(0xFF6B7280) : const Color(0xFF9CA3AF),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _applyFilters() {
    context.read<ProductCubit>().filterProducts(
          searchQuery: _searchController.text,
          category: _selectedCategory.isNotEmpty ? _selectedCategory : null,
          inStockOnly: _inStockOnly,
        );
  }

  void _showAddProductModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const AddProductModal(),
    );
  }
}