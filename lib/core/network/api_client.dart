import 'package:dio/dio.dart';
import '../constants/api_constants.dart';
import '../error/exceptions.dart';
import '../storage/secure_storage_service.dart';
import 'auth_interceptor.dart';

class ApiClient {
  late final Dio dio;

  ApiClient({required SecureStorageService storageService, Dio? customDio}) {
    dio = customDio ??
        Dio(
          BaseOptions(
            baseUrl: ApiConstants.baseUrl,
            connectTimeout: const Duration(seconds: 15),
            receiveTimeout: const Duration(seconds: 15),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ),
        );

    dio.interceptors.add(AuthInterceptor(storageService));
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await dio.get(path, queryParameters: queryParameters);
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Exception _handleDioError(DioException error) {
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.connectionError) {
      return NetworkException(message: 'Connection timed out. Server unreachable.');
    }

    if (error.response != null) {
      final statusCode = error.response?.statusCode;
      final responseData = error.response?.data;
      String message = 'An unexpected server error occurred';

      if (responseData is Map<String, dynamic> && responseData.containsKey('message')) {
        message = responseData['message'].toString();
      }

      if (statusCode == 401) {
        return UnauthorizedException(message: message);
      }
      return ServerException(message: message, statusCode: statusCode);
    }

    return ServerException(message: error.message ?? 'Unknown error');
  }
}
