import 'package:domain/domain.dart';
import 'package:domain/usecase/usecase.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetSpeechRecommendationUseCase extends UseCase {
  final SmartACApiRepository _repository;

  GetSpeechRecommendationUseCase(this._repository);

  Future<Result<SpeechRecommendation>> call({
    required String text,
    String? clientName,
  }) async {
    return _repository.getSpeechRecommendation(
      text: text,
      clientName: clientName,
    );
  }
}
