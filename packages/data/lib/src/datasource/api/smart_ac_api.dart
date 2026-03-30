import 'dart:io';

import 'package:dio/dio.dart';
import 'package:domain/domain.dart';
import 'package:http_parser/http_parser.dart';
import 'package:injectable/injectable.dart';

import '../../dto/chatbot_dto.dart';

@singleton
class SmartACApi {
  static const String kRouteChat = 'api/v1/chat';

  final Dio dio;

  const SmartACApi(this.dio);

  ///
  ///  Download file from url
  ///
  Future<String> downloadFileFromUrl(
    String fileUrl,
    Directory appDocDir, {
    Options? options,
  }) async {
    final downloadFileName = DateTime.now().toIso8601String();
    final fullPath = "${appDocDir.path}/$downloadFileName.pdf";
    await dio.download(fileUrl, fullPath, options: options);
    return fullPath;
  }

  ///
  /// Chatbot messages
  ///
  Future<ChatbotDto> chat(
    String query,
    String jobId,
    List<Map<String, String>> history,
  ) async {
    final data = {'job_id': jobId, 'query': query, 'history': history};
    final response = await dio.post(kRouteChat, data: data);
    return ChatbotDto.fromJson(response.data);
  }
}
