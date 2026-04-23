import 'package:data/src/common/data_object_mapper.dart';
import 'package:domain/domain.dart';
import 'package:domain/model/data_list.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

import '../datasource/api/smart_ac_api.dart';

@Singleton(as: SmartACApiRepository)
@injectable
class SmartACApiRepositoryImpl extends SmartACApiRepository {
  final SmartACApi _api;
  final DataObjectMapper _objectMapper;
  final Logger _logger;

  SmartACApiRepositoryImpl({
    required SmartACApi api,
    required DataObjectMapper objectMapper,
    required Logger logger,
  }) : _objectMapper = objectMapper,
       _api = api,
       _logger = logger;

  // ── Transactions ─────────────────────────────────────────────────────────

  @override
  Future<Result<DataList<Transaction>>> getTransactions({
    int limit = 100,
    String? riskFilter,
  }) async {
    try {
      final response = await _api.getTransactions(
        limit: limit,
        riskFilter: riskFilter,
      );
      return Result.success(_objectMapper.toTransactionList(response));
    } on Exception catch (e) {
      _logger.e('Exception e: $e');
      return Result.failed(_objectMapper.toError(e));
    }
  }

  @override
  Future<Result<AccountStats>> getStats() async {
    try {
      final response = await _api.getTransactionStats();
      return Result.success(_objectMapper.toAccountStats(response));
    } on Exception catch (e) {
      _logger.e('Exception e: $e');
      return Result.failed(_objectMapper.toError(e));
    }
  }

  @override
  Future<void> analyseAll() async {
    try {
      await _api.analyseAllTransactions();
    } on Exception catch (e) {
      _logger.e('Exception e: $e');
    }
  }

  // ── Documents ─────────────────────────────────────────────────────────────

  @override
  Future<Result<DataList<AccountDocument>>> getDocuments() async {
    try {
      final response = await _api.getDocuments();
      return Result.success(_objectMapper.toAccountDocumentList(response));
    } on Exception catch (e) {
      _logger.e('Exception e: $e');
      return Result.failed(_objectMapper.toError(e));
    }
  }

  @override
  Future<Result<AccountDocument>> getDocument(int documentId) async {
    try {
      final response = await _api.getDocument(documentId);
      return Result.success(_objectMapper.toAccountDocument(response));
    } on Exception catch (e) {
      _logger.e('Exception e: $e');
      return Result.failed(_objectMapper.toError(e));
    }
  }

  // ── Audit Log ─────────────────────────────────────────────────────────────

  @override
  Future<Result<DataList<AuditEntry>>> getAuditLog() async {
    try {
      final response = await _api.getAuditLog();
      return Result.success(_objectMapper.toAuditEntryList(response));
    } on Exception catch (e) {
      _logger.e('Exception e: $e');
      return Result.failed(_objectMapper.toError(e));
    }
  }

  // ── Agents ────────────────────────────────────────────────────────────────

  @override
  Future<void> runReviewerAssist() async {
    try {
      await _api.runReviewerAssist();
    } on Exception catch (e) {
      _logger.e('Exception e: $e');
    }
  }

  @override
  Future<Result<OrchestratorResult>> runOrchestrator({
    String? clientName,
    bool useLangChain = false,
  }) async {
    try {
      final response = await _api.runOrchestrator(
        clientName: clientName,
        useLangChain: useLangChain,
      );
      return Result.success(_objectMapper.toOrchestratorResult(response));
    } on Exception catch (e) {
      _logger.e('Exception e: $e');
      return Result.failed(_objectMapper.toError(e));
    }
  }

  // ── Reset DB ────────────────────────────────────────────────────────────────

  @override
  Future<Result<Reset>> resetDb({String? clientName}) async {
    try {
      final response = await _api.resetDatabase();
      return Result.success(_objectMapper.toReset(response));
    } on Exception catch (e) {
      _logger.e('Exception e: $e');
      return Result.failed(_objectMapper.toError(e));
    }
  }

  // ── Speech Recommendation ────────────────────────────────────────────────

  @override
  Future<Result<SpeechRecommendation>> getSpeechRecommendation({
    required String text,
    String? clientName,
  }) async {
    try {
      final response = await _api.getSpeechRecommendation(
        text: text,
        clientName: clientName,
      );
      return Result.success(_objectMapper.toSpeechRecommendation(response));
    } on Exception catch (e) {
      _logger.e('Exception e: $e');
      return Result.failed(_objectMapper.toError(e));
    }
  }
}
