import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taptap_task_kashif/features/product/domain/repositories/product_repository.dart';
import 'package:taptap_task_kashif/features/product/domain/repositories/product_repository_impl.dart';
import 'package:taptap_task_kashif/features/product/domain/entities/product_entity.dart';

part '../states/product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final ProductRepository _repository = ProductRepositoryImpl();
  List<ProductEntity> _allProducts = [];

  ProductCubit() : super(ProductInitial());

  Future<void> loadProducts() async {
    emit(ProductLoading());
    try {
      _allProducts = await _repository.getProducts();
      emit(ProductLoaded(products: _allProducts));
    } catch (e) {
      emit(ProductError(message: 'Failed to load products: $e'));
    }
  }

  void filterProducts({
    String? searchQuery,
    String? category,
    bool? inStockOnly,
  }) {
    if (state is! ProductLoaded) return;

    List<ProductEntity> filteredProducts = _allProducts;

    if (searchQuery != null && searchQuery.isNotEmpty) {
      filteredProducts = filteredProducts
          .where((product) =>
              product.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
              product.category.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    }

    if (category != null && category.isNotEmpty) {
      filteredProducts = filteredProducts
          .where((product) => product.category == category)
          .toList();
    }

    if (inStockOnly == true) {
      filteredProducts =
          filteredProducts.where((product) => product.isInStock).toList();
    }

    emit(ProductLoaded(products: filteredProducts));
  }

  Future<void> addProduct(ProductEntity product) async {
    if (state is! ProductLoaded) return;

    try {
      final newProduct = await _repository.addProduct(product);
      _allProducts = [..._allProducts, newProduct];
      emit(ProductLoaded(products: _allProducts));
    } catch (e) {
      emit(ProductError(message: 'Failed to add product: $e'));
    }
  }

  Future<void> updateProduct(ProductEntity product) async {
    if (state is! ProductLoaded) return;

    try {
      final updatedProduct = await _repository.updateProduct(product);
      final index = _allProducts.indexWhere((p) => p.id == product.id);
      if (index != -1) {
        _allProducts = [
          ..._allProducts.sublist(0, index),
          updatedProduct,
          ..._allProducts.sublist(index + 1),
        ];
        emit(ProductLoaded(products: _allProducts));
      }
    } catch (e) {
      emit(ProductError(message: 'Failed to update product: $e'));
    }
  }

  Future<void> deleteProduct(String id) async {
    if (state is! ProductLoaded) return;

    try {
      await _repository.deleteProduct(id);
      _allProducts = _allProducts.where((product) => product.id != id).toList();
      emit(ProductLoaded(products: _allProducts));
    } catch (e) {
      emit(ProductError(message: 'Failed to delete product: $e'));
    }
  }

  Future<ProductEntity> getProductById(String id) async {
  return await _repository.getProductById(id);
}
}