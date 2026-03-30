import 'dart:io';

import 'package:domain/domain.dart';
import 'package:domain/model/chatbot_messages.dart';
import 'package:domain/repository/repository.dart';

///
/// Repository that contains all possible API actions
///
abstract class SmartACApiRepository extends Repository {
  ///
  /// download file from url
  ///
  Future<Result> downloadFileFromUrl(String fileUrl, Directory appDocDir);

  ///
  /// Ask query via chatbot
  ///
  Future<Result<ChatbotMessage>> chat(
    String query,
    String jobId,
    List<Map<String, String>> history,
  );
}
