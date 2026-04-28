// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:data/data.dart' as _i437;
import 'package:domain/di/domain_module.module.dart' as _i729;
import 'package:domain/domain.dart' as _i494;
import 'package:domain/usecase/get_speech_recommendation_usecase.dart' as _i620;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:kernel/kernel.dart' as _i426;
import 'package:smart_ac/features/audit_log/cubit/audit_log_cubit.dart'
    as _i595;
import 'package:smart_ac/features/dashboard/cubit/dashboard_cubit.dart'
    as _i794;
import 'package:smart_ac/features/documents/cubit/documents_cubit.dart'
    as _i586;
import 'package:smart_ac/features/orchestrator/cubit/orchestrator_cubit.dart'
    as _i455;
import 'package:smart_ac/features/speech_screen/cubit/speech_cubit.dart'
    as _i718;
import 'package:smart_ac/features/transactions/cubit/transactions_cubit.dart'
    as _i484;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    await _i426.KernelPackageModule().init(gh);
    await _i437.DataPackageModule().init(gh);
    await _i729.DomainPackageModule().init(gh);
    gh.factory<_i595.AuditLogCubit>(
      () => _i595.AuditLogCubit(gh<_i494.GetAuditLogUseCase>()),
    );
    gh.factory<_i484.TransactionsCubit>(
      () => _i484.TransactionsCubit(gh<_i494.TransactionUseCase>()),
    );
    gh.factory<_i718.SpeechCubit>(
      () => _i718.SpeechCubit(gh<_i620.GetSpeechRecommendationUseCase>()),
    );
    gh.factory<_i794.DashboardCubit>(
      () => _i794.DashboardCubit(
        gh<_i494.GetStatsUseCase>(),
        gh<_i494.TransactionUseCase>(),
      ),
    );
    gh.factory<_i586.DocumentsCubit>(
      () => _i586.DocumentsCubit(gh<_i494.GetDocumentsUseCase>()),
    );
    gh.factory<_i455.OrchestratorCubit>(
      () => _i455.OrchestratorCubit(
        gh<_i494.RunOrchestratorUseCase>(),
        gh<_i494.ResetDbUseCase>(),
      ),
    );
    return this;
  }
}
