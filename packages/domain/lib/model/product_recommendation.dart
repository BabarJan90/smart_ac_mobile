import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

@injectable
class ProductItem extends Equatable {
  final int id;
  final String title;
  final double price;
  final String category;
  final String image;
  final String reason;
  final double rating;

  const ProductItem({
    required this.id,
    required this.title,
    required this.price,
    required this.category,
    required this.image,
    required this.reason,
    required this.rating,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    price,
    category,
    image,
    reason,
    rating,
  ];
}

@injectable
class ProductRecommendation extends Equatable {
  final String source;
  final List<ProductItem> products;
  final String conversationSummary;
  final double durationSeconds;

  const ProductRecommendation({
    required this.source,
    required this.products,
    required this.conversationSummary,
    required this.durationSeconds,
  });

  @override
  List<Object?> get props => [
    source,
    products,
    conversationSummary,
    durationSeconds,
  ];
}
