import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:taptap_task_kashif/features/product/data/models/product_model.dart';
import 'package:taptap_task_kashif/features/product/domain/repositories/product_repository.dart';
import 'package:taptap_task_kashif/features/product/domain/entities/product_entity.dart';

class ProductRepositoryImpl implements ProductRepository {
  List<ProductEntity> _products = [];
  
  @override
  Future<List<ProductEntity>> getProducts() async {
    if (_products.isEmpty) {
      await _loadFromJson();
    }
    return _products;
  }

  @override
  Future<ProductEntity> getProductById(String id) async {
    final products = await getProducts();
    return products.firstWhere((product) => product.id == id);
  }

  @override
  Future<ProductEntity> addProduct(ProductEntity product) async {
    final newProduct = ProductModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: product.name,
      category: product.category,
      price: product.price,
      stock: product.stock,
      description: product.description,
      imageUrl: product.imageUrl,
    );
    //debugger();
    _products = [..._products, newProduct];
    return newProduct;
  }

  @override
  Future<ProductEntity> updateProduct(ProductEntity product) async {
    final index = _products.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      _products = [
        ..._products.sublist(0, index),
        product,
        ..._products.sublist(index + 1),
      ];
    }
    return product;
  }

  @override
  Future<void> deleteProduct(String id) async {
    _products = _products.where((product) => product.id != id).toList();
  }

  Future<void> _loadFromJson() async {
    try {
      final jsonString = await rootBundle.loadString('assets/products.json');
      final jsonData = json.decode(jsonString);
      final List<ProductModel> products = (jsonData['products'] as List)
          .map((productJson) => ProductModel.fromJson(productJson))
          .toList();
      _products = products;
    } catch (e) {
      
      _products = _getSampleProducts();
    }
  }

  List<ProductModel> _getSampleProducts() {
    return [
      ProductModel(
        id: '1',
        name: 'Wireless Headphones',
        category: 'Electronics',
        price: 199.99,
        stock: 50,
        description: 'Premium wireless headphones with noise cancellation',
        imageUrl: 'https://picsum.photos/200',
      ),
      ProductModel(
        id: '2',
        name: 'Smart Watch',
        category: 'Electronics',
        price: 299.99,
        stock: 0,
        description: 'Advanced smart watch with health monitoring',
        imageUrl: 'https://picsum.photos/201',
      ),
      ProductModel(
        id: '3',
        name: 'Laptop',
        category: 'Electronics',
        price: 1299.99,
        stock: 15,
        description: 'High-performance laptop for professionals',
        imageUrl: 'https://picsum.photos/202',
      ),
      ProductModel(
        id: '4',
        name: 'Desk Chair',
        category: 'Furniture',
        price: 399.99,
        stock: 25,
        description: 'Ergonomic office chair',
        imageUrl: 'https://picsum.photos/203',
      ),
    ];
  }
}