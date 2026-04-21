import 'package:json_annotation/json_annotation.dart';

part 'speech_recommendation_dto.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class SpeechRecommendationDto {
  final String recommendation;
  final List<String> services;
  final List<String> nextSteps;

  const SpeechRecommendationDto({
    required this.recommendation,
    required this.services,
    required this.nextSteps,
  });

  factory SpeechRecommendationDto.fromJson(Map<String, dynamic> json) =>
      _$SpeechRecommendationDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SpeechRecommendationDtoToJson(this);
}
