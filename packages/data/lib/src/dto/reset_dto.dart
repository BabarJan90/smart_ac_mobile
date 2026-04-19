import 'package:json_annotation/json_annotation.dart';

part 'reset_dto.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ResetDto {
  final String message;
  final String status;

  const ResetDto({required this.message, required this.status});

  factory ResetDto.fromJson(Map<String, dynamic> json) =>
      _$ResetDtoFromJson(json);
}
