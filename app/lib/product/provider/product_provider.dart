import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurant_app/common/const/api_type.dart';
import 'package:restaurant_app/common/provider/pagination_provider.dart';
import 'package:restaurant_app/product/repository/product_repository.dart';

final productProvider =
    StateNotifierProvider<ProductStateNotifier, CursorPaginationBase>((ref) {
  final repository = ref.watch(productRepositoryProvider);

  return ProductStateNotifier(repository: repository);
});

class ProductStateNotifier
    extends PaginationProvider<ProductModel, ProductRepository> {
  ProductStateNotifier({
    required super.repository,
  });
}
