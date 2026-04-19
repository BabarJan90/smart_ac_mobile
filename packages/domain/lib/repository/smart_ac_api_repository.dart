import 'package:domain/domain.dart';
import 'package:domain/model/data_list.dart';
import 'package:domain/repository/repository.dart';

///
/// Repository that contains all possible API actions
///
abstract class SmartACApiRepository extends Repository {
  ///
  /// Get Transactions
  ///
  Future<Result<DataList<Transaction>>> getTransactions({
    int limit = 100,
    String? riskFilter,
  });

  ///
  /// Get Stats
  ///
  Future<Result<AccountStats>> getStats();

  ///
  /// Analyse All
  ///
  Future<void> analyseAll();

  ///
  /// Get Documents
  ///
  Future<Result<DataList<AccountDocument>>> getDocuments();

  ///
  /// Get One Document
  ///
  Future<Result<AccountDocument>> getDocument(int documentId);

  ///
  /// Get Audit Log
  ///
  Future<Result<DataList<AuditEntry>>> getAuditLog();

  ///
  /// run Orchestrator
  ///
  Future<Result<OrchestratorResult>> runOrchestrator({String? clientName});

  ///
  /// Run Reviewer Assist
  ///
  // Future<Result<Map<String, dynamic>>> runReviewerAssist();
  Future<void> runReviewerAssist();

  ///
  /// reset DB
  ///
  Future<Result<Reset>> resetDb({String? clientName});
}
