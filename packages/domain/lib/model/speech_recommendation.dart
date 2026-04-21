import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

@injectable
class SpeechRecommendation extends Equatable {
  final String recommendation;
  final List<String> services;
  final List<String> nextSteps;

  const SpeechRecommendation({
    required this.recommendation,
    required this.services,
    required this.nextSteps,
  });

  @override
  List<Object?> get props => [recommendation, services, nextSteps];
}
