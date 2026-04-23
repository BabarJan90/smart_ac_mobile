import 'package:domain/domain.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'orchestrator_state.dart';

@injectable
class OrchestratorCubit extends Cubit<OrchestratorState> {
  final RunOrchestratorUseCase _runOrchestratorUseCase;
  final ResetDbUseCase _resetDbUseCase;

  OrchestratorCubit(this._runOrchestratorUseCase, this._resetDbUseCase)
    : super(OrchestratorInitial());

  Future<void> run({String? clientName, bool useLangChain = false}) async {
    emit(OrchestratorRunning());
    final result = await _runOrchestratorUseCase(
      clientName: clientName,
      useLangChain: useLangChain,
    );
    result.when(
      success: (data) => emit(OrchestratorLoaded(data)),
      failed: (error) => emit(OrchestratorError(error.message)),
    );
  }

  Future<void> resetDb() async {
    emit(OrchestratorRunning());
    final result = await _resetDbUseCase();
    result.when(
      success: (_) => emit(OrchestratorResetSuccess()),
      failed: (error) => emit(OrchestratorError(error.message)),
    );
  }
}
