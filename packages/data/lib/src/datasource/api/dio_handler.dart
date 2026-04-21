import 'package:data/src/datasource/interceptor/auth_interceptor.dart';
import 'package:data/src/datasource/interceptor/connection_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioHandler {
  final AuthInterceptor authInterceptor;
  final ConnectionInterceptor connectionInterceptor;
  final PrettyDioLogger prettyDioLogger;

  DioHandler({
    required this.authInterceptor,
    required this.connectionInterceptor,
    required this.prettyDioLogger,
  });

  // 🌐 Live Web Apphttp://smartac-frontend-1775237755.s3-website.eu-west-2.amazonaws.com
  // // ⚙️ Backend APIhttp://13.135.205.116:8000
  // // 📖 API Docshttp://13.135.205.116:8000/docs

  Dio createDio() {
    final dio = Dio(
      BaseOptions(
        // baseUrl: 'http://127.0.0.1:8000/',
        baseUrl: 'http://13.135.205.116:8000/',
        // baseUrl: 'https://certainly-dweeb-wife.ngrok-free.app/',
        receiveTimeout: Duration(minutes: 5),
        connectTimeout: Duration(minutes: 5),
        sendTimeout: Duration(minutes: 5),
        contentType: 'application/json',
      ),
    );

    dio.interceptors.addAll([
      authInterceptor,
      connectionInterceptor,
      prettyDioLogger,
    ]);

    return dio;
  }
}
