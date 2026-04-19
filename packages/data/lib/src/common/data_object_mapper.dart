// import 'package:data/src/dto/account_document_dto.dart';
// import 'package:data/src/dto/account_stats_dto.dart';
// import 'package:data/src/dto/audit_entry_dto.dart';
// import 'package:data/src/dto/chatbot_dto.dart';
// import 'package:data/src/dto/data_list_dto.dart';
// import 'package:data/src/dto/error_dto.dart';
// import 'package:data/src/dto/orchestrator_result_dto.dart';
// import 'package:data/src/dto/transaction_dto.dart';
// import 'package:dio/dio.dart';
// import 'package:domain/domain.dart';
// import 'package:domain/model/account_document.dart';
// import 'package:domain/model/account_stats.dart';
// import 'package:domain/model/audit_entry.dart';
// import 'package:domain/model/chatbot_messages.dart';
// import 'package:domain/model/data_list.dart';
// import 'package:domain/model/orchestrator_result.dart';
// import 'package:domain/model/transaction.dart';
// import 'package:injectable/injectable.dart';
// import 'package:json_annotation/json_annotation.dart';
//
// @singleton
// class DataObjectMapper {
//
//
//   AuditEntry toAuditEntry(AuditEntryDto dto) {
//     return AuditEntry(
//       id: dto.id,
//       timestamp: dto.timestamp,
//       action: dto.action,
//     );
//   }
//
//   AccountDocument toAccountDocument(AccountDocumentDto dto) {
//     return AccountDocument(
//       id: dto.id,
//       docType: dto.docType,
//       createdAt: dto.createdAt,
//       preview: dto.preview,
//       content: dto.content,
//     );
//   }
//
//   DataList<AccountDocument> toAccountDocuments(
//     DataListDto<AccountDocumentDto> dto,
//   ) {
//     return DataList(
//       items: dto.items?.map((e) => toAccountDocument(e)).toList() ?? [],
//       currentPage: DataList.defaultSize,
//       pageSize: DataList.defaultSize,
//       totalPages: DataList.defaultSize,
//     );
//   }
//
//   AccountStats toAccountStats(AccountStatsDto dto) {
//     return AccountStats(
//       totalTransactions: dto.totalTransactions,
//       totalValue: dto.totalValue,
//       riskDistribution: dto.riskDistribution,
//       anomalyCount: dto.anomalyCount,
//     );
//   }
//
//   DataList<Transaction> toTransactions(DataListDto<TransactionDto> dto) {
//     return DataList(
//       items: dto.items?.map((e) => toTransaction(e)).toList() ?? [],
//       currentPage: DataList.defaultSize,
//       pageSize: DataList.defaultSize,
//       totalPages: DataList.defaultSize,
//     );
//   }
//
//   Transaction toTransaction(TransactionDto dto) {
//     return Transaction(
//       id: dto.id,
//       date: dto.date,
//       vendor: dto.vendor,
//       amount: dto.amount,
//       category: dto.category,
//       description: dto.description,
//       riskScore: dto.riskScore,
//       riskLabel: dto.riskLabel,
//       isAnomaly: dto.isAnomaly,
//       explanation: dto.explanation,
//     );
//   }
//
//   OrchestratorResult toOrchestratorResult(OrchestratorResultDto dto) {
//     return OrchestratorResult(
//       completedAt: dto.completedAt,
//       durationSeconds: dto.durationSeconds,
//       summary: dto.summary,
//       planExecuted: dto.planExecuted,
//       actionLog: dto.actionLog,
//       results: dto.results,
//     );
//   }
//
//   // OrchestratorResult toOrchestratorResult(OrchestratorResultDto dto) {
//   //   return OrchestratorResult(
//   //     completedAt: dto.completedAt,
//   //     durationSeconds: dto.durationSeconds,
//   //     summary: dto.summary,
//   //     planExecuted: dto.planExecuted,
//   //     actionLog: dto.actionLog,
//   //     results: dto.results,
//   //   );
//   // }
//
//   Error toError(Exception exception) {
//     Error error;
//     if (exception is DioException) {
//       switch (exception.type) {
//         case DioExceptionType.cancel:
//           error = Error(message: "Request to API server was cancelled");
//           break;
//         case DioExceptionType.connectionTimeout:
//           error = Error(
//             message:
//                 "It looks like there's a connection issue. Please try again.",
//           );
//           break;
//         case DioExceptionType.unknown:
//           error = Error(
//             message:
//                 "Error while processing request, check your internet connection",
//           );
//           break;
//         case DioExceptionType.receiveTimeout:
//           error = Error(
//             message:
//                 "It looks like there's a connection issue. Please try again.",
//           );
//           break;
//         case DioExceptionType.badResponse:
//           final data = exception.response?.data;
//           try {
//             final dto = ErrorDto.fromJson(data);
//             error = Error(code: dto.code, message: dto.message);
//           } on CheckedFromJsonException catch (e) {
//             error = Error(message: e.message ?? ErrorDto.kParsingError);
//           }
//           break;
//         case DioExceptionType.sendTimeout:
//           error = Error(
//             message:
//                 "It looks like there's a connection issue. Please try again.",
//           );
//           break;
//         case DioExceptionType.connectionError:
//           error = Error(message: 'No internet connection');
//           break;
//         default:
//           error = Error(message: "Something went wrong");
//           break;
//       }
//     } else if (exception is CheckedFromJsonException) {
//       error = Error(message: exception.message ?? ErrorDto.kParsingError);
//     } else {
//       error = Error(message: exception.toString());
//     }
//     // logger.e(
//     //   "An error has occurred. code=${error.code}, message=${error.message}",
//     // );
//     return error;
//   }
// }
import 'package:data/src/dto/account_stats_dto.dart';
import 'package:data/src/dto/anomaly_report_dto.dart';
import 'package:data/src/dto/audit_entry_dto.dart';
import 'package:data/src/dto/client_letter_dto.dart';
import 'package:data/src/dto/data_list_dto.dart';
import 'package:data/src/dto/document_dto.dart';
import 'package:data/src/dto/error_dto.dart';
import 'package:data/src/dto/junior_assist_dto.dart';
import 'package:data/src/dto/orchestrator_dto.dart';
import 'package:data/src/dto/reset_dto.dart';
import 'package:data/src/dto/reviewer_assist_dto.dart';
import 'package:data/src/dto/transaction_dto.dart';
import 'package:dio/dio.dart';
import 'package:domain/domain.dart';
import 'package:domain/model/data_list.dart';
import 'package:injectable/injectable.dart';
import 'package:json_annotation/json_annotation.dart';

@singleton
class DataObjectMapper {
  // ── Transaction ─────────────────────────────────────────────────────────────

  Transaction toTransaction(TransactionDto dto) {
    return Transaction(
      id: dto.id,
      date: dto.date,
      vendor: dto.vendor,
      amount: dto.amount,
      category: dto.category ?? '',
      description: dto.description ?? '',
      riskScore: dto.riskScore ?? 0.0,
      riskLabel: dto.riskLabel ?? '',
      isAnomaly: dto.isAnomaly,
      explanation: dto.explanation ?? '',
    );
  }

  DataList<Transaction> toTransactionList(DataListDto<TransactionDto> dto) {
    return DataList<Transaction>(
      items: dto.items?.map(toTransaction).toList() ?? [],
      currentPage: dto.currentPage ?? 0,
      pageSize: dto.pageSize ?? 0,
      totalPages: dto.totalPages ?? 0,
    );
  }

  // ── Account Stats ────────────────────────────────────────────────────────────

  AccountStats toAccountStats(AccountStatsDto dto) {
    return AccountStats(
      totalTransactions: dto.totalTransactions,
      totalValue: dto.totalValue,
      lowRisk: dto.riskDistribution.low ?? 0,
      mediumRisk: dto.riskDistribution.medium ?? 0,
      highRisk: dto.riskDistribution.high ?? 0,
      unscored: dto.riskDistribution.unscored ?? 0,
      anomalyCount: dto.anomalyCount,
    );
  }

  // ── Reviewer Assist ──────────────────────────────────────────────────────────

  ReviewerAssist toReviewerAssist(ReviewerAssistDto dto) {
    return ReviewerAssist(
      summary: dto.summary,
      keyConcerns: dto.keyConcerns,
      recommendedActions: dto.recommendedActions,
      riskLevel: dto.riskLevel,
      agent: dto.agent,
      totalTransactions: dto.stats.totalTransactions,
      totalValue: dto.stats.totalValue,
      highRiskCount: dto.stats.highRiskCount,
      anomalyCount: dto.stats.anomalyCount,
    );
  }

  // ── Document ─────────────────────────────────────────────────────────────────

  AccountDocument toAccountDocument(DocumentDto dto) {
    return AccountDocument(
      id: dto.id,
      docType: dto.docType,
      createdAt: dto.createdAt,
      preview: dto.preview ?? '',
      content: dto.content ?? '',
    );
  }

  DataList<AccountDocument> toAccountDocumentList(
    DataListDto<DocumentDto> dto,
  ) {
    return DataList<AccountDocument>(
      items: dto.items?.map(toAccountDocument).toList() ?? [],
      currentPage: dto.currentPage ?? 0,
      pageSize: dto.pageSize ?? 0,
      totalPages: dto.totalPages ?? 0,
    );
  }

  // ── Audit Entry ──────────────────────────────────────────────────────────────

  AuditEntry toAuditEntry(AuditEntryDto dto) {
    return AuditEntry(
      id: dto.id,
      timestamp: dto.timestamp,
      action: dto.action,
      transactionId: dto.transactionId ?? 0,
      modelUsed: dto.modelUsed ?? '',
      justification: dto.justification ?? '',
    );
  }

  DataList<AuditEntry> toAuditEntryList(DataListDto<AuditEntryDto> dto) {
    return DataList<AuditEntry>(
      items: dto.items?.map(toAuditEntry).toList() ?? [],
      currentPage: dto.currentPage ?? 0,
      pageSize: dto.pageSize ?? 0,
      totalPages: dto.totalPages ?? 0,
    );
  }

  // ── Junior Assist ────────────────────────────────────────────────────────────

  JuniorAssistResult toJuniorAssistResult(JuniorAssistResultDto dto) {
    return JuniorAssistResult(
      status: dto.status,
      processed: dto.processed,
      categorisations: dto.categorisations.map(toCategorization).toList(),
    );
  }

  Categorization toCategorization(CategorizationDto dto) {
    return Categorization(
      transactionId: dto.transactionId ?? 0,
      vendor: dto.vendor ?? '',
      category: dto.category ?? '',
      confidence: dto.confidence ?? 0.0,
      notes: dto.notes ?? '',
    );
  }

  // ── Anomaly Report ───────────────────────────────────────────────────────────

  AnomalyReport toAnomalyReport(AnomalyReportResultDto dto) {
    return AnomalyReport(status: dto.status, report: dto.report ?? '');
  }

  // ── Client Letter ────────────────────────────────────────────────────────────

  ClientLetter toClientLetter(ClientLetterResultDto dto) {
    return ClientLetter(
      status: dto.status,
      client: dto.client ?? '',
      letter: dto.letter ?? '',
    );
  }

  // ── Orchestrator ─────────────────────────────────────────────────────────────

  OrchestratorResult toOrchestratorResult(OrchestratorResultDto dto) {
    return OrchestratorResult(
      orchestrator: dto.orchestrator,
      completedAt: dto.completedAt,
      durationSeconds: dto.durationSeconds,
      summary: dto.summary,
      accountState: toOrchestratorAccountState(dto.accountState),
      planExecuted: dto.planExecuted.map(toOrchestratorPlanStep).toList(),
      actionLog: dto.actionLog.map(toOrchestratorActionLog).toList(),
      results: toOrchestratorResults(dto.results),
    );
  }

  OrchestratorAccountState toOrchestratorAccountState(
    OrchestratorAccountStateDto dto,
  ) {
    return OrchestratorAccountState(
      totalTransactions: dto.totalTransactions,
      totalValue: dto.totalValue,
      highRiskCount: dto.highRiskCount,
      anomalyCount: dto.anomalyCount,
    );
  }

  OrchestratorPlanStep toOrchestratorPlanStep(OrchestratorPlanStepDto dto) {
    return OrchestratorPlanStep(
      agent: dto.agent,
      reason: dto.reason,
      priority: dto.priority,
    );
  }

  OrchestratorActionLog toOrchestratorActionLog(OrchestratorActionLogDto dto) {
    return OrchestratorActionLog(
      timestamp: dto.timestamp,
      action: dto.action,
      detail: dto.detail,
    );
  }

  OrchestratorResults toOrchestratorResults(OrchestratorResultsDto dto) {
    return OrchestratorResults(
      juniorAssist: dto.juniorAssist != null
          ? toJuniorAssistResult(dto.juniorAssist!)
          : const JuniorAssistResult(
              status: '',
              processed: 0,
              categorisations: [],
            ),
      reviewerAssist: dto.reviewerAssist != null
          ? toReviewerAssist(dto.reviewerAssist!)
          : const ReviewerAssist(
              summary: '',
              keyConcerns: [],
              recommendedActions: [],
              riskLevel: '',
              agent: '',
              totalTransactions: 0,
              totalValue: 0.0,
              highRiskCount: 0,
              anomalyCount: 0,
            ),
      anomalyReport: dto.anomalyReport != null
          ? toAnomalyReport(dto.anomalyReport!)
          : const AnomalyReport(status: '', report: ''),
      clientLetter: dto.clientLetter != null
          ? toClientLetter(dto.clientLetter!)
          : const ClientLetter(status: '', client: '', letter: ''),
    );
  }

  // ── Reset ────────────────────────────────────────────────────────────

  Reset toReset(ResetDto dto) {
    return Reset(message: dto.message ?? '');
  }

  Error toError(Exception exception) {
    Error error;
    if (exception is DioException) {
      switch (exception.type) {
        case DioExceptionType.cancel:
          error = Error(message: "Request to API server was cancelled");
          break;
        case DioExceptionType.connectionTimeout:
          error = Error(
            message:
                "It looks like there's a connection issue. Please try again.",
          );
          break;
        case DioExceptionType.unknown:
          error = Error(
            message:
                "Error while processing request, check your internet connection",
          );
          break;
        case DioExceptionType.receiveTimeout:
          error = Error(
            message:
                "It looks like there's a connection issue. Please try again.",
          );
          break;
        case DioExceptionType.badResponse:
          final data = exception.response?.data;
          try {
            final dto = ErrorDto.fromJson(data);
            error = Error(code: dto.code, message: dto.message);
          } on CheckedFromJsonException catch (e) {
            error = Error(message: e.message ?? ErrorDto.kParsingError);
          }
          break;
        case DioExceptionType.sendTimeout:
          error = Error(
            message:
                "It looks like there's a connection issue. Please try again.",
          );
          break;
        case DioExceptionType.connectionError:
          error = Error(message: 'No internet connection');
          break;
        default:
          error = Error(message: "Something went wrong");
          break;
      }
    } else if (exception is CheckedFromJsonException) {
      error = Error(message: exception.message ?? ErrorDto.kParsingError);
    } else {
      error = Error(message: exception.toString());
    }
    // logger.e(
    //   "An error has occurred. code=${error.code}, message=${error.message}",
    // );
    return error;
  }
}
