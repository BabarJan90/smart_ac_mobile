import 'package:data/src/dto/chatbot_dto.dart';
import 'package:data/src/dto/error_dto.dart';
import 'package:dio/dio.dart';
import 'package:domain/domain.dart';
import 'package:domain/model/chatbot_messages.dart';
import 'package:injectable/injectable.dart';
import 'package:json_annotation/json_annotation.dart';

@singleton
class DataObjectMapper {


  ChatbotMessage toChatbotMessages(ChatbotDto dto) {
    return ChatbotMessage(response: dto.response ?? '');
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
