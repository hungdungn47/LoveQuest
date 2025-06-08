import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:love_quest/core/storage/local_storage.dart';
import 'package:logger/logger.dart';

class DioClient {
  // Private constructor
  DioClient._internal();
  // Singleton instance
  static final DioClient _instance = DioClient._internal();
  // Getter for the instance
  static DioClient get instance => _instance;

  final LocalStorage _localStorage = LocalStorage();
  final Logger logger = Logger();
  late Dio _dio;
  // Configuration function
  void configureDio({
    required String baseUrl,
    Map<String, dynamic>? defaultHeaders,
    Duration? connectTimeout,
    Duration? receiveTimeout,
    void Function(RequestOptions options, RequestInterceptorHandler handler)?
        onRequest,
    void Function(Response response, ResponseInterceptorHandler handler)?
        onResponse,
    void Function(DioException e, ErrorInterceptorHandler handler)? onError,
  }) {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: connectTimeout ?? const Duration(seconds: 30),
      receiveTimeout: receiveTimeout ?? const Duration(seconds: 30),
      headers: defaultHeaders ??
          {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
    ));
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: onRequest ??
            (options, handler) {
              final accessToken = LocalStorage().readData('accessToken');
              logger.i('Getting access token befor request: ${accessToken}');
              if (accessToken != null) {
                options.headers['Authorization'] = 'Bearer $accessToken';
              }
              debugPrint('Request: ${options.method} ${options.path}');
              debugPrint('Headers: ${options.headers}');
              debugPrint('Query Params: ${options.queryParameters}');
              handler.next(options);
            },
        onResponse: onResponse ??
            (response, handler) {
              debugPrint('Response: ${response.statusCode} ${response.data}');
              handler.next(response);
            },
        onError: onError ??
            (DioException e, handler) {
              debugPrint('Error: ${e.message}');
              handler.next(e);
            },
      ),
    );
  }

  Future<Response> get(String endpoint,
      {Map<String, dynamic>? queryParameters, Map<String, dynamic>? headers}) async {
    Response response = await _dio.get(
      endpoint,
      queryParameters: queryParameters,
      options: Options(
        headers: headers
      )
    );
    return response;
  }

  Future<Response> post(String endpoint,
      {Map<String, dynamic>? data,
      Map<String, dynamic>? queryParameters,
      String contentType = 'application/json'}) async {
    Response response = await _dio.post(endpoint,
        data: data,
        queryParameters: queryParameters,
        options: Options(contentType: contentType));
    return response;
  }

  Future<Response> put(String endpoint,
      {Map<String, dynamic>? data,
      Map<String, dynamic>? queryParameters,
      String contentType = 'application/json'}) async {
    Response response = await _dio.put(endpoint,
        data: data,
        queryParameters: queryParameters,
        options: Options(contentType: contentType));
    return response;
  }

  Future<Response> patch(String endpoint,
      {Map<String, dynamic>? data,
        Map<String, dynamic>? queryParameters,
        String contentType = 'application/json'}) async {
    Response response = await _dio.patch(endpoint,
        data: data,
        queryParameters: queryParameters,
        options: Options(contentType: contentType));
    return response;
  }

  Future<Response> delete(String endpoint,
      {Map<String, dynamic>? data,
      Map<String, dynamic>? queryParameters,
      String contentType = 'application/json'}) async {
    Response response = await _dio.delete(endpoint,
        data: data,
        queryParameters: queryParameters,
        options: Options(contentType: contentType));
    return response;
  }
}
