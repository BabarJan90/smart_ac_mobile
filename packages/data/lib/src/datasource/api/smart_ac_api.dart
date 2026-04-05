// import 'dart:io';
//
// import 'package:data/src/dto/account_stats_dto.dart';
// import 'package:data/src/dto/audit_entry_dto.dart';
// import 'package:data/src/dto/data_list_dto.dart';
// import 'package:data/src/dto/transaction_dto.dart';
// import 'package:dio/dio.dart';
// import 'package:injectable/injectable.dart';
//
// import '../../dto/chatbot_dto.dart';
//
// @singleton
// class SmartACApi {
//   static const String kRouteChat = 'api/v1/chat';
//   static const String kTransactions = 'transactions';
//   static const String kTransactionsStats = 'transactions/stats';
//   static const String kTransactionsAnalyseAll = 'transactions/analyse-all';
//   static const String kAgentsDocuments = 'agents/documents';
//   static String kAgentsDocument(int id) => 'agents/documents/$id';
//   static const String kAgentsAuditLog = 'agents/audit-log';
//   static const String kAgentsOrchestrate = 'agents/orchestrate';
//   static const String kAgentsReviewerAssist = 'agents/reviewer-assist';
//
//   final Dio dio;
//
//   const SmartACApi(this.dio);
//
//   ///
//   /// Get transactions
//   ///
//   Future<DataListDto<TransactionDto>> getTransactions({
//     int limit = 100,
//     String? riskFilter,
//   }) async {
//     late Map<String, dynamic> data;
//     data = riskFilter == null
//         ? {'limit': limit}
//         : {'limit': limit, 'risk_filter': riskFilter};
//
//     final response = await dio.get(kTransactions, data: data);
//     return DataListDto<TransactionDto>.fromJson(
//       response.data,
//       (value) => TransactionDto.fromJson(value as Map<String, dynamic>),
//     );
//   }
//
//   ///
//   /// Get Stats
//   ///
//   Future<AccountStatsDto> getStats() async {
//     final response = await dio.get(kTransactionsStats);
//     return AccountStatsDto.fromJson(response.data);
//   }
//
//   ///
//   /// Analyse All
//   ///
//   Future<void> analyseAll() async {
//     await dio.post(kTransactionsAnalyseAll);
//   }
//
//   ///
//   /// Get documents list
//   ///
//   Future<DataListDto<AccountDocumentDto>> getDocuments() async {
//     final response = await dio.get(kTransactionsStats);
//     return DataListDto<AccountDocumentDto>.fromJson(
//       response.data,
//       (value) => AccountDocumentDto.fromJson(value as Map<String, dynamic>),
//     );
//   }
//
//   ///
//   /// Get One Document
//   ///
//   Future<AccountDocumentDto> getDocument(int id) async {
//     final response = await dio.get(kAgentsDocument(id));
//     return AccountDocumentDto.fromJson(response.data);
//   }
//
//   ///
//   /// Get Audit Logs
//   ///
//   Future<DataListDto<AuditEntryDto>> getAuditLog() async {
//     final response = await dio.get(kAgentsAuditLog);
//     return DataListDto<AuditEntryDto>.fromJson(
//       response.data,
//       (value) => AuditEntryDto.fromJson(value as Map<String, dynamic>),
//     );
//   }
//
//   ///
//   /// Run Orchestrator
//   ///
//   Future<OrchestratorResultDto> runOrchestrator({String? clientName}) async {
//     final data = {'client_name': clientName};
//     final response = await dio.post(kAgentsOrchestrate, data: data);
//
//     return OrchestratorResultDto.fromJson(response.data);
//   }
//
//   ///
//   /// Run Orchestrator
//   ///
//   // Future<Result<Map<String, dynamic>>> runReviewerAssist() async {
//   Future<void> runReviewerAssist() async {
//     // final response = await dio.post(kAgentsReviewerAssist);
//     //
//     // return OrchestratorResultDto.fromJson(response.data);
//   }
//
//   ///
//   ///  Download file from url
//   ///
//   Future<String> downloadFileFromUrl(
//     String fileUrl,
//     Directory appDocDir, {
//     Options? options,
//   }) async {
//     final downloadFileName = DateTime.now().toIso8601String();
//     final fullPath = "${appDocDir.path}/$downloadFileName.pdf";
//     await dio.download(fileUrl, fullPath, options: options);
//     return fullPath;
//   }
//
//   ///
//   /// Chatbot messages
//   ///
//   Future<ChatbotDto> chat(
//     String query,
//     String jobId,
//     List<Map<String, String>> history,
//   ) async {
//     final data = {'job_id': jobId, 'query': query, 'history': history};
//     final response = await dio.post(kRouteChat, data: data);
//     return ChatbotDto.fromJson(response.data);
//   }
// }

///
///
///
///
///
///
///
///
///
///
///

import 'package:data/src/dto/account_stats_dto.dart';
import 'package:data/src/dto/audit_entry_dto.dart';
import 'package:data/src/dto/data_list_dto.dart';
import 'package:data/src/dto/document_dto.dart';
import 'package:data/src/dto/orchestrator_dto.dart';
import 'package:data/src/dto/reviewer_assist_dto.dart';
import 'package:data/src/dto/transaction_dto.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@singleton
class SmartACApi {
  // ── Endpoints ──────────────────────────────────────────────────────────────
  static const String kTransactions = 'transactions';
  static const String kTransactionsStats = 'transactions/stats';
  static const String kTransactionsAnalyseAll = 'transactions/analyse-all';
  static const String kAgentsDocuments = 'agents/documents';
  static const String kAgentsAuditLog = 'agents/audit-log';
  static const String kAgentsOrchestrate = 'agents/orchestrate';
  static const String kAgentsReviewerAssist = 'agents/reviewer-assist';
  static const String kAgentsJuniorAssist = 'agents/junior-assist';
  static const String kAgentsGenerateLetter = 'agents/generate-letter';
  static const String kAgentsAnomalyReport = 'agents/generate-anomaly-report';

  static String kAgentsDocument(int id) => 'agents/documents/$id';
  static String kAgentsDocumentText(int id) => 'agents/documents/$id/text';
  static String kJuniorAssist(int id) => 'agents/junior-assist/$id';

  final Dio dio;

  const SmartACApi(this.dio);

  /// Wraps a plain JSON array from our backend into the
  /// DataListDto format { items, currentPage, pageSize, totalPages }
  Map<String, dynamic> _wrapList(dynamic responseData) {
    final list = responseData as List<dynamic>;
    return {
      'items': list,
      'current_page': 0,
      'page_size': list.length,
      'total_pages': 1,
    };
  }

  // ── Transactions ───────────────────────────────────────────────────────────

  ///
  /// Get all transactions with optional risk filter
  ///
  Future<DataListDto<TransactionDto>> getTransactions({
    int limit = 100,
    String? riskFilter,
  }) async {
    final data = riskFilter == null
        ? {'limit': limit}
        : {'limit': limit, 'risk_filter': riskFilter};

    final response = await dio.get(kTransactions, data: data);
    return DataListDto<TransactionDto>.fromJson(
      _wrapList(response.data),
      (value) => TransactionDto.fromJson(value as Map<String, dynamic>),
    );
  }

  ///
  /// Get transaction statistics for dashboard
  ///
  Future<AccountStatsDto> getTransactionStats() async {
    final response = await dio.get(kTransactionsStats);
    return AccountStatsDto.fromJson(response.data);
  }

  ///
  /// Trigger fuzzy logic scoring on all unanalysed transactions
  ///
  Future<void> analyseAllTransactions() async {
    await dio.post(kTransactionsAnalyseAll);
  }

  // ── Agents ─────────────────────────────────────────────────────────────────

  ///
  /// Run Junior Assist on a single transaction
  ///
  Future<void> runJuniorAssist(int transactionId) async {
    await dio.post(kJuniorAssist(transactionId));
  }

  ///
  /// Run Reviewer Assist on a batch of transactions
  ///
  Future<ReviewerAssistDto> runReviewerAssist({
    int limit = 10,
    String? riskFilter,
  }) async {
    final data = riskFilter == null
        ? {'limit': limit}
        : {'limit': limit, 'risk_filter': riskFilter};

    final response = await dio.post(kAgentsReviewerAssist, data: data);
    return ReviewerAssistDto.fromJson(response.data);
  }

  ///
  /// Run the Orchestrator Agent - full Sense → Plan → Act → Report cycle
  ///
  Future<OrchestratorResultDto> runOrchestrator({String? clientName}) async {
    final response = await dio.post(
      kAgentsOrchestrate,
      data: OrchestratorRequestDto(clientName: clientName).toJson(),
    );
    return OrchestratorResultDto.fromJson(response.data);
  }

  ///
  /// Generate a client letter
  ///
  Future<void> generateClientLetter({
    required String clientName,
    int transactionLimit = 50,
  }) async {
    await dio.post(
      kAgentsGenerateLetter,
      data: {'client_name': clientName, 'transaction_limit': transactionLimit},
    );
  }

  ///
  /// Generate anomaly report
  ///
  Future<void> generateAnomalyReport() async {
    await dio.post(kAgentsAnomalyReport);
  }

  // ── Documents ──────────────────────────────────────────────────────────────

  ///
  /// Get all generated documents
  ///
  Future<DataListDto<DocumentDto>> getDocuments() async {
    final response = await dio.get(kAgentsDocuments);
    return DataListDto<DocumentDto>.fromJson(
      _wrapList(response.data),
      (value) => DocumentDto.fromJson(value as Map<String, dynamic>),
    );
  }

  ///
  /// Get a single document by ID
  ///
  Future<DocumentDto> getDocument(int id) async {
    final response = await dio.get(kAgentsDocument(id));
    return DocumentDto.fromJson(response.data);
  }

  // ── Audit Log ──────────────────────────────────────────────────────────────

  ///
  /// Get GDPR audit log entries
  ///
  Future<DataListDto<AuditEntryDto>> getAuditLog({
    int skip = 0,
    int limit = 50,
  }) async {
    final response = await dio.get(
      kAgentsAuditLog,
      data: {'skip': skip, 'limit': limit},
    );
    return DataListDto<AuditEntryDto>.fromJson(
      _wrapList(response.data),
      (value) => AuditEntryDto.fromJson(value as Map<String, dynamic>),
    );
  }
}
