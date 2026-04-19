part of 'orchestrator_cubit.dart';

@immutable
sealed class OrchestratorState {}

final class OrchestratorInitial extends OrchestratorState {}

final class OrchestratorRunning extends OrchestratorState {}

final class OrchestratorLoaded extends OrchestratorState {
  final OrchestratorResult result;
  OrchestratorLoaded(this.result);
}

class OrchestratorResetSuccess extends OrchestratorState {}

final class OrchestratorError extends OrchestratorState {
  final String message;
  OrchestratorError(this.message);
}
