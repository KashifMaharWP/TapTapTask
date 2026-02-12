import 'package:taptap_task_kashif/features/product/domain/entities/product_entity.dart';



abstract class ProductRepository {
  Future<List<ProductEntity>> getProducts();
  Future<ProductEntity> getProductById(String id);
  Future<ProductEntity> addProduct(ProductEntity product);
  Future<ProductEntity> updateProduct(ProductEntity product);
  Future<void> deleteProduct(String id);
}