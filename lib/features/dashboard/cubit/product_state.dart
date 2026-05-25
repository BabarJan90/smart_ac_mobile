part of 'product_cubit.dart';

sealed class ProductState {}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final ProductRecommendation recommendation;
  ProductLoaded(this.recommendation);
}

class ProductError extends ProductState {
  final String message;
  ProductError(this.message);
}
