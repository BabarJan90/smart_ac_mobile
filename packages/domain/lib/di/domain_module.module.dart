//@GeneratedMicroModule;DomainPackageModule;package:domain/di/domain_module.module.dart
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i687;

import 'package:domain/domain.dart' as _i494;
import 'package:domain/model/account_document.dart' as _i20;
import 'package:domain/model/account_stats.dart' as _i254;
import 'package:domain/model/anomaly_report.dart' as _i1019;
import 'package:domain/model/audit_entry.dart' as _i781;
import 'package:domain/model/chat_history.dart' as _i114;
import 'package:domain/model/client_letter.dart' as _i977;
import 'package:domain/model/junior_assist.dart' as _i193;
import 'package:domain/model/orchestrator_result.dart' as _i496;
import 'package:domain/model/reset.dart' as _i1025;
import 'package:domain/model/reviewer_assist.dart' as _i651;
import 'package:domain/model/speech_recommendation.dart' as _i351;
import 'package:domain/model/transaction.dart' as _i59;
import 'package:domain/usecase/analyse_all_use_case.dart' as _i880;
import 'package:domain/usecase/get_audit_log_use_case.dart' as _i533;
import 'package:domain/usecase/get_document_use_case.dart' as _i104;
import 'package:domain/usecase/get_documents_use_case.dart' as _i965;
import 'package:domain/usecase/get_speech_recommendation_usecase.dart' as _i620;
import 'package:domain/usecase/get_stats_use_case.dart' as _i26;
import 'package:domain/usecase/reset_db_use_case.dart' as _i606;
import 'package:domain/usecase/run_orchestrator_use_case.dart' as _i737;
import 'package:domain/usecase/run_reviewer_assist_use_case.dart' as _i462;
import 'package:domain/usecase/transaction_use_case.dart' as _i381;
import 'package:injectable/injectable.dart' as _i526;

class DomainPackageModule extends _i526.MicroPackageModule {
// initializes the registration of main-scope dependencies inside of GetIt
  @override
  _i687.FutureOr<void> init(_i526.GetItHelper gh) {
    gh.factory<_i193.Categorization>(() => _i193.Categorization(
          transactionId: gh<int>(),
          vendor: gh<String>(),
          category: gh<String>(),
          confidence: gh<double>(),
          notes: gh<String>(),
        ));
    gh.factory<_i496.OrchestratorActionLog>(() => _i496.OrchestratorActionLog(
          timestamp: gh<String>(),
          action: gh<String>(),
          detail: gh<String>(),
        ));
    gh.factory<_i254.AccountStats>(() => _i254.AccountStats(
          totalTransactions: gh<int>(),
          totalValue: gh<double>(),
          lowRisk: gh<int>(),
          mediumRisk: gh<int>(),
          highRisk: gh<int>(),
          unscored: gh<int>(),
          anomalyCount: gh<int>(),
        ));
    gh.factory<_i880.AnalyseAllUseCase>(
        () => _i880.AnalyseAllUseCase(gh<_i494.SmartACApiRepository>()));
    gh.factory<_i533.GetAuditLogUseCase>(
        () => _i533.GetAuditLogUseCase(gh<_i494.SmartACApiRepository>()));
    gh.factory<_i104.GetDocumentUseCase>(
        () => _i104.GetDocumentUseCase(gh<_i494.SmartACApiRepository>()));
    gh.factory<_i965.GetDocumentsUseCase>(
        () => _i965.GetDocumentsUseCase(gh<_i494.SmartACApiRepository>()));
    gh.factory<_i620.GetSpeechRecommendationUseCase>(() =>
        _i620.GetSpeechRecommendationUseCase(gh<_i494.SmartACApiRepository>()));
    gh.factory<_i26.GetStatsUseCase>(
        () => _i26.GetStatsUseCase(gh<_i494.SmartACApiRepository>()));
    gh.factory<_i606.ResetDbUseCase>(
        () => _i606.ResetDbUseCase(gh<_i494.SmartACApiRepository>()));
    gh.factory<_i737.RunOrchestratorUseCase>(
        () => _i737.RunOrchestratorUseCase(gh<_i494.SmartACApiRepository>()));
    gh.factory<_i462.RunReviewerAssistUseCase>(
        () => _i462.RunReviewerAssistUseCase(gh<_i494.SmartACApiRepository>()));
    gh.factory<_i381.TransactionUseCase>(
        () => _i381.TransactionUseCase(gh<_i494.SmartACApiRepository>()));
    gh.factory<_i651.ReviewerAssist>(() => _i651.ReviewerAssist(
          summary: gh<String>(),
          keyConcerns: gh<List<String>>(),
          recommendedActions: gh<List<String>>(),
          riskLevel: gh<String>(),
          agent: gh<String>(),
          totalTransactions: gh<int>(),
          totalValue: gh<double>(),
          highRiskCount: gh<int>(),
          anomalyCount: gh<int>(),
        ));
    gh.factory<_i977.ClientLetter>(() => _i977.ClientLetter(
          status: gh<String>(),
          client: gh<String>(),
          letter: gh<String>(),
        ));
    gh.factory<_i351.SpeechRecommendation>(() => _i351.SpeechRecommendation(
          recommendation: gh<String>(),
          services: gh<List<String>>(),
          nextSteps: gh<List<String>>(),
        ));
    gh.factory<_i496.OrchestratorAccountState>(
        () => _i496.OrchestratorAccountState(
              totalTransactions: gh<int>(),
              totalValue: gh<double>(),
              highRiskCount: gh<int>(),
              anomalyCount: gh<int>(),
            ));
    gh.factory<_i20.AccountDocument>(() => _i20.AccountDocument(
          id: gh<int>(),
          docType: gh<String>(),
          createdAt: gh<String>(),
          preview: gh<String>(),
          content: gh<String>(),
        ));
    gh.factory<_i193.JuniorAssistResult>(() => _i193.JuniorAssistResult(
          status: gh<String>(),
          processed: gh<int>(),
          categorisations: gh<List<_i193.Categorization>>(),
        ));
    gh.factory<_i1025.Reset>(() => _i1025.Reset(message: gh<String>()));
    gh.factory<_i781.AuditEntry>(() => _i781.AuditEntry(
          id: gh<int>(),
          timestamp: gh<String>(),
          action: gh<String>(),
          transactionId: gh<int>(),
          modelUsed: gh<String>(),
          justification: gh<String>(),
        ));
    gh.factory<_i59.Transaction>(() => _i59.Transaction(
          id: gh<int>(),
          date: gh<String>(),
          vendor: gh<String>(),
          amount: gh<double>(),
          category: gh<String>(),
          description: gh<String>(),
          riskScore: gh<double>(),
          riskLabel: gh<String>(),
          isAnomaly: gh<bool>(),
          explanation: gh<String>(),
        ));
    gh.factory<_i114.ChatHistory>(
        () => _i114.ChatHistory(history: gh<List<Map<String, String>>>()));
    gh.factory<_i496.OrchestratorPlanStep>(() => _i496.OrchestratorPlanStep(
          agent: gh<String>(),
          reason: gh<String>(),
          priority: gh<int>(),
        ));
    gh.factory<_i1019.AnomalyReport>(() => _i1019.AnomalyReport(
          status: gh<String>(),
          report: gh<String>(),
        ));
    gh.factory<_i496.OrchestratorResults>(() => _i496.OrchestratorResults(
          juniorAssist: gh<_i193.JuniorAssistResult>(),
          reviewerAssist: gh<_i651.ReviewerAssist>(),
          anomalyReport: gh<_i1019.AnomalyReport>(),
          clientLetter: gh<_i977.ClientLetter>(),
        ));
    gh.factory<_i496.OrchestratorResult>(() => _i496.OrchestratorResult(
          orchestrator: gh<String>(),
          completedAt: gh<String>(),
          durationSeconds: gh<double>(),
          summary: gh<String>(),
          accountState: gh<_i496.OrchestratorAccountState>(),
          planExecuted: gh<List<_i496.OrchestratorPlanStep>>(),
          actionLog: gh<List<_i496.OrchestratorActionLog>>(),
          results: gh<_i496.OrchestratorResults>(),
        ));
  }
}
