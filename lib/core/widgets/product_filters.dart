import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taptap_task_kashif/features/presentation/cubits/theme_cubit.dart';

class ProductFilters extends StatefulWidget {
  final Function(String) onCategoryChanged;
  final Function(bool) onStockFilterChanged;

  const ProductFilters({
    super.key,
    required this.onCategoryChanged,
    required this.onStockFilterChanged,
  });

  @override
  State<ProductFilters> createState() => _ProductFiltersState();
}

class _ProductFiltersState extends State<ProductFilters> {
  String _selectedCategory = '';
  bool _inStockOnly = false;
  
  final List<String> _categories = [
    'All',
    'Electronics',
    'Furniture',
    'Clothing',
    'Books',
    'Other'
  ];

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.select((ThemeCubit cubit) => cubit.state.isDarkMode);
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: isDarkMode ? const Color(0xFF374151) : Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isDarkMode ? const Color(0xFF4B5563) : const Color(0xFFE5E7EB),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: DropdownButton<String>(
                value: _selectedCategory.isEmpty ? 'All' : _selectedCategory,
                items: _categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(
                      category,
                      style: TextStyle(
                        color: isDarkMode ? const Color(0xFFD1D5DB) : const Color(0xFF374151),
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value == 'All' ? '' : value!;
                  });
                  widget.onCategoryChanged(_selectedCategory);
                },
                underline: const SizedBox(),
                dropdownColor: isDarkMode ? const Color(0xFF374151) : Colors.white,
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: isDarkMode ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
                ),
                style: TextStyle(
                  color: isDarkMode ? const Color(0xFFD1D5DB) : const Color(0xFF374151),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Container(
            decoration: BoxDecoration(
              color: isDarkMode ? const Color(0xFF374151) : Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isDarkMode ? const Color(0xFF4B5563) : const Color(0xFFE5E7EB),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Checkbox(
                  value: _inStockOnly,
                  onChanged: (value) {
                    setState(() {
                      _inStockOnly = value ?? false;
                    });
                    widget.onStockFilterChanged(_inStockOnly);
                  },
                  checkColor: isDarkMode ? const Color(0xFFD1D5DB) : Colors.white,
                  fillColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.selected)) {
                        return isDarkMode ? const Color(0xFF60A5FA) : const Color(0xFF3B82F6);
                      }
                      return isDarkMode ? const Color(0xFF4B5563) : const Color(0xFFE5E7EB);
                    },
                  ),
                ),
                Text(
                  'In Stock Only',
                  style: TextStyle(
                    color: isDarkMode ? const Color(0xFFD1D5DB) : const Color(0xFF374151),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}