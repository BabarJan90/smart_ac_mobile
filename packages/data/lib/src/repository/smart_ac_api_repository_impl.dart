import 'dart:io';

import 'package:data/src/common/data_object_mapper.dart';
import 'package:domain/domain.dart';
import 'package:domain/model/chatbot_messages.dart';
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


  @override
  Future<Result> downloadFileFromUrl(
    String fileUrl,
    Directory appDocDir, {
    String? filePath,
    String? fileName,
  }) async {
    try {
      final filePath = await _api.downloadFileFromUrl(
        fileUrl,
        appDocDir,
      );
      return Result.success(filePath);
    } on Exception catch (e) {
      _logger.e('Exception e: $e');
      return Result.failed(_objectMapper.toError(e));
    }
  }

  @override
  Future<Result<ChatbotMessage>> chat(
    String query,
    String jobId,
    List<Map<String, String>> history,
  ) async {
    try {
      final response = await _api.chat(query, jobId, history);
      final analyses = _objectMapper.toChatbotMessages(response);

      return Result.success(analyses);
    } on Exception catch (e) {
      _logger.e('Exception e: $e');
      return Result.failed(_objectMapper.toError(e));
    }
  }
}
