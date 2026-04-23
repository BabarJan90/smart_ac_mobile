import 'package:data/src/dto/account_stats_dto.dart';
import 'package:data/src/dto/audit_entry_dto.dart';
import 'package:data/src/dto/data_list_dto.dart';
import 'package:data/src/dto/document_dto.dart';
import 'package:data/src/dto/orchestrator_dto.dart';
import 'package:data/src/dto/reset_dto.dart';
import 'package:data/src/dto/reviewer_assist_dto.dart';
import 'package:data/src/dto/speech_recommendation_dto.dart';
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
  static const String kAgentsOrchestrateLangChain =
      'agents/orchestrate-langchain';
  static const String kAgentsReviewerAssist = 'agents/reviewer-assist';
  static const String kAgentsJuniorAssist = 'agents/junior-assist';
  static const String kAgentsGenerateLetter = 'agents/generate-letter';
  static const String kAgentsAnomalyReport = 'agents/generate-anomaly-report';
  static const String kReset = 'transactions/reset';
  static const String kSpeechRecommendation = 'agents/speech-recommendation';

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
  Future<OrchestratorResultDto> runOrchestrator({
    String? clientName,
    bool useLangChain = false,
  }) async {
    final endpoint = useLangChain
        ? kAgentsOrchestrateLangChain
        : kAgentsOrchestrate;

    final response = await dio.post(
      endpoint,
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

  // ── Reset DB ──────────────────────────────────────────────────────────────

  ///
  /// This will reset the db and logs for demo
  ///
  Future<ResetDto> resetDatabase() async {
    final response = await dio.post(kReset);
    return ResetDto.fromJson(response.data);
  }

  // ── Speech Recommendation ─────────────────────────────────────────────────

  ///
  /// Get AI recommendations from transcribed speech
  ///
  Future<SpeechRecommendationDto> getSpeechRecommendation({
    required String text,
    String? clientName,
  }) async {
    final response = await dio.post(
      kSpeechRecommendation,
      data: {'text': text, if (clientName != null) 'client_name': clientName},
    );
    return SpeechRecommendationDto.fromJson(response.data);
  }
}
