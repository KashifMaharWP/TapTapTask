import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  final String id;
  final String name;
  final String category;
  final double price;
  final int stock;
  final String description;
  final String? imageUrl;

  const ProductEntity({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.stock,
    required this.description,
    this.imageUrl,
  });

  bool get isInStock => stock > 0;

  @override
  List<Object?> get props => [id, name, category, price, stock];
}