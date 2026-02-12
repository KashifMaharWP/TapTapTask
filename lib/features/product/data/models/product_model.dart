
import 'package:taptap_task_kashif/features/product/domain/entities/product_entity.dart';

class ProductModel extends ProductEntity {
  const ProductModel({
    required super.id,
    required super.name,
    required super.category,
    required super.price,
    required super.stock,
    required super.description,
    super.imageUrl,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'].toString(),
      name: json['title'] ?? json['name'],
      category: json['category'] ?? 'Uncategorized',
      price: (json['price'] ?? 0.0).toDouble(),
      stock: json['stock'] ?? (json['quantity'] ?? 0),
      description: json['description'] ?? '',
      imageUrl: json['thumbnail'] ?? json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': name,
      'category': category,
      'price': price,
      'stock': stock,
      'description': description,
      'thumbnail': imageUrl,
    };
  }
}