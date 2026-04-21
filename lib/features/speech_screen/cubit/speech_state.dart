part of 'speech_cubit.dart';

@immutable
sealed class SpeechState {}

final class SpeechInitial extends SpeechState {}

final class SpeechLoading extends SpeechState {}

final class SpeechLoaded extends SpeechState {
  final SpeechRecommendation recommendation;
  SpeechLoaded(this.recommendation);
}

final class SpeechError extends SpeechState {
  final String message;
  SpeechError(this.message);
}
