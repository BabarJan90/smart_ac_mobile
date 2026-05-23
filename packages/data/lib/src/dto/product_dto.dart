import 'package:json_annotation/json_annotation.dart';

part 'product_dto.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ProductItemDto {
  final int id;
  final String title;
  final double price;
  final String category;
  final String image;
  final String reason;
  final double rating;

  const ProductItemDto({
    required this.id,
    required this.title,
    required this.price,
    required this.category,
    required this.image,
    required this.reason,
    required this.rating,
  });

  factory ProductItemDto.fromJson(Map<String, dynamic> json) =>
      _$ProductItemDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ProductItemDtoToJson(this);
}

// Product Recommendation Request

@JsonSerializable(fieldRename: FieldRename.snake)
class ProductRecommendationRequestDto {
  final String conversation;

  const ProductRecommendationRequestDto({required this.conversation});

  factory ProductRecommendationRequestDto.fromJson(Map<String, dynamic> json) =>
      _$ProductRecommendationRequestDtoFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ProductRecommendationRequestDtoToJson(this);
}

// Product Recommendation Response

@JsonSerializable(fieldRename: FieldRename.snake)
class ProductRecommendationResponseDto {
  final String source;
  final List<ProductItemDto> products;
  final String conversationSummary;
  final double durationSeconds;

  const ProductRecommendationResponseDto({
    required this.source,
    required this.products,
    required this.conversationSummary,
    required this.durationSeconds,
  });

  factory ProductRecommendationResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$ProductRecommendationResponseDtoFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ProductRecommendationResponseDtoToJson(this);
}
