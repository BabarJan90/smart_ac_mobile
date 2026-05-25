import 'package:domain/domain.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetProductRecommendationsUseCase {
  final SmartACApiRepository _repository;

  GetProductRecommendationsUseCase(this._repository);

  Future<Result<ProductRecommendation>> call({
    required String conversation,
  }) async {
    return _repository.getProductRecommendations(conversation: conversation);
  }
}
