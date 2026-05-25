import 'package:domain/domain.dart';
import 'package:domain/usecase/get_product_recommendations_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'product_state.dart';

@injectable
class ProductCubit extends Cubit<ProductState> {
  final GetProductRecommendationsUseCase _getProductRecommendations;

  ProductCubit(this._getProductRecommendations) : super(ProductInitial());

  Future<void> load({required String conversation}) async {
    emit(ProductLoading());
    final result = await _getProductRecommendations(conversation: conversation);
    result.when(
      success: (data) => emit(ProductLoaded(data)),
      failed: (error) => emit(ProductError(error.message)),
    );
  }
}
