import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:taptap_task_kashif/features/presentation/cubits/theme_cubit.dart';
import 'package:taptap_task_kashif/features/presentation/widgets/add_product_modal.dart';
import 'package:taptap_task_kashif/features/product/domain/entities/product_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductTable extends StatelessWidget {
  final List<dynamic> products;

  const ProductTable({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.select((ThemeCubit cubit) => cubit.state.isDarkMode);
    
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 768) {
          return _buildMobileView(context, isDarkMode);
        } else {
          return _buildDesktopView(context, isDarkMode);
        }
      },
    );
  }

  Widget _buildDesktopView(BuildContext context, bool isDarkMode) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        child: DataTable(
          columnSpacing: 70,
          headingRowColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
              return isDarkMode ? const Color(0xFF374151) : const Color(0xFFF9FAFB);
            },
          ),
          dataRowColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.selected)) {
                return isDarkMode ? const Color(0xFF4B5563) : const Color(0xFFE5E7EB);
              }
              return isDarkMode ? const Color(0xFF1F2937) : Colors.white;
            },
          ),
          headingTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDarkMode ? const Color(0xFFD1D5DB) : const Color(0xFF374151),
          ),
          dataTextStyle: TextStyle(
            color: isDarkMode ? const Color(0xFFD1D5DB) : const Color(0xFF374151),
          ),
          border: TableBorder(
            horizontalInside: BorderSide(
              color: isDarkMode ? const Color(0xFF374151) : const Color(0xFFE5E7EB),
            ),
          ),
          columns: const [
            DataColumn(label: Text('ID'), numeric: true),
            DataColumn(label: Text('Name')),
            DataColumn(label: Text('Category')),
            DataColumn(label: Text('Price'), numeric: true),
            DataColumn(label: Text('Stock'), numeric: true),
            DataColumn(label: Text('Status')),
            DataColumn(label: Text('Actions')),
          ],
          rows: products.map((product) {
            return DataRow(
              cells: [
                DataCell(Text(product.id)),
                DataCell(
                  Text(
                    product.name,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
                DataCell(Text(product.category)),
                DataCell(Text('\$${product.price.toStringAsFixed(2)}')),
                DataCell(Text(product.stock.toString())),
                DataCell(
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
                ),
                DataCell(
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.visibility, size: 20, color: isDarkMode ? const Color(0xFF60A5FA) : const Color(0xFF3B82F6)),
                        onPressed: () {
                          context.go('/products/${product.id}');
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.edit, size: 20, color: isDarkMode ? const Color(0xFFFBBF24) : const Color(0xFFD97706)),
                        onPressed: () {
                          AddProductModal(product: product);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, size: 20, color: isDarkMode ? const Color(0xFFF87171) : const Color(0xFFDC2626)),
                        onPressed: () {
                          // Delete product
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildMobileView(BuildContext context, bool isDarkMode) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isDarkMode ? const Color(0xFF1F2937) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDarkMode ? const Color(0xFF374151) : const Color(0xFFE5E7EB),
            ),
            boxShadow: [
              BoxShadow(
                color: isDarkMode ? Colors.black.withOpacity(0.2) : Colors.grey.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        product.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : const Color(0xFF111827),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Chip(
                      label: Text(
                        product.isInStock ? 'In Stock' : 'Out',
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
                const SizedBox(height: 8),
                _buildMobileRow('ID:', product.id, isDarkMode),
                _buildMobileRow('Category:', product.category, isDarkMode),
                _buildMobileRow('Price:', '\$${product.price.toStringAsFixed(2)}', isDarkMode),
                _buildMobileRow('Stock:', '${product.stock} units', isDarkMode),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          context.go('/products/${product.id}');
                        },
                        icon: Icon(
                          Icons.visibility,
                          size: 16,
                          color: isDarkMode ? const Color(0xFF60A5FA) : const Color(0xFF3B82F6),
                        ),
                        label: Text(
                          'View',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDarkMode ? const Color(0xFF60A5FA) : const Color(0xFF3B82F6),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isDarkMode 
                              ? const Color(0xFF1E3A8A).withOpacity(0.2) 
                              : const Color(0xFFDBEAFE),
                          foregroundColor: isDarkMode ? const Color(0xFF60A5FA) : const Color(0xFF3B82F6),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                         AddProductModal(product: product);
                        },
                        icon: Icon(
                          Icons.edit,
                          size: 16,
                          color: isDarkMode ? const Color(0xFFFBBF24) : const Color(0xFFD97706),
                        ),
                        label: Text(
                          'Edit',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDarkMode ? const Color(0xFFFBBF24) : const Color(0xFFD97706),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isDarkMode 
                              ? const Color(0xFF78350F).withOpacity(0.2) 
                              : const Color(0xFFFEF3C7),
                          foregroundColor: isDarkMode ? const Color(0xFFFBBF24) : const Color(0xFFD97706),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // Delete product
                        },
                        icon: Icon(
                          Icons.delete,
                          size: 16,
                          color: isDarkMode ? const Color(0xFFF87171) : const Color(0xFFDC2626),
                        ),
                        label: Text(
                          'Delete',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDarkMode ? const Color(0xFFF87171) : const Color(0xFFDC2626),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isDarkMode 
                              ? const Color(0xFF7F1D1D).withOpacity(0.2) 
                              : const Color(0xFFFEE2E2),
                          foregroundColor: isDarkMode ? const Color(0xFFF87171) : const Color(0xFFDC2626),
                          padding: const EdgeInsets.symmetric(vertical: 8),
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
        );
      },
    );
  }

  Widget _buildMobileRow(String label, String value, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: isDarkMode ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isDarkMode ? const Color(0xFFD1D5DB) : const Color(0xFF111827),
              ),
            ),
          ),
        ],
      ),
    );
  }
}