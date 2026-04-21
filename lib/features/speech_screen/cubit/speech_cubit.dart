import 'package:domain/domain.dart';
import 'package:domain/model/speech_recommendation.dart';
import 'package:domain/usecase/get_speech_recommendation_usecase.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'speech_state.dart';

@injectable
class SpeechCubit extends Cubit<SpeechState> {
  final GetSpeechRecommendationUseCase _getSpeechRecommendationUseCase;

  SpeechCubit(this._getSpeechRecommendationUseCase) : super(SpeechInitial());

  Future<void> getRecommendation({
    required String text,
    String? clientName,
  }) async {
    emit(SpeechLoading());

    final result = await _getSpeechRecommendationUseCase(
      text: text,
      clientName: clientName,
    );

    result.when(
      success: (recommendation) => emit(SpeechLoaded(recommendation)),
      failed: (error) => emit(SpeechError(error.message)),
    );
  }

  void reset() => emit(SpeechInitial());
}
