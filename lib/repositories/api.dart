import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// ============================================================
// 型エイリアス
// ============================================================

typedef JsonMap = Map<String, dynamic>;
typedef JsonList = List<dynamic>;

// ============================================================
// エラー型
// ============================================================

sealed class ApiException implements Exception {
  const ApiException(this.message);

  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

/// HTTP ステータスエラー（4xx, 5xx）
class ApiHttpException extends ApiException {
  const ApiHttpException({required this.statusCode, required String message})
    : super(message);

  final int statusCode;
}

/// ネットワーク接続エラー
class ApiNetworkException extends ApiException {
  const ApiNetworkException(super.message);
}

/// リクエストタイムアウト
class ApiTimeoutException extends ApiException {
  const ApiTimeoutException(super.message);
}

/// レスポンスのパースに失敗
class ApiParseException extends ApiException {
  const ApiParseException(super.message);
}

/// その他の未知のエラー
class ApiUnknownException extends ApiException {
  const ApiUnknownException(super.message);
}

extension _DioExceptionMapper on DioException {
  ApiException toApiException() {
    return switch (type) {
      DioExceptionType.badResponse => ApiHttpException(
        statusCode: response?.statusCode ?? -1,
        message: response?.statusMessage ?? 'HTTP error',
      ),
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout => ApiTimeoutException(
        message ?? 'Request timed out',
      ),
      DioExceptionType.connectionError => ApiNetworkException(
        message ?? 'Network error',
      ),
      _ => ApiUnknownException(message ?? 'Unknown error'),
    };
  }
}

// ============================================================
// API クライアント
// ============================================================

const _baseUrl = 'https://api.example.com';

class ApiClient {
  ApiClient({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: _baseUrl,
              connectTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 30),
              headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
              },
            ),
          ) {
    _dio.interceptors.add(_LogInterceptor());
  }

  final Dio _dio;

  Future<T> get<T>(String path, {JsonMap? queryParameters, Options? options}) =>
      _request(
        () => _dio.get<T>(
          path,
          queryParameters: queryParameters,
          options: options,
        ),
      );

  Future<T> post<T>(
    String path, {
    Object? data,
    JsonMap? queryParameters,
    Options? options,
  }) => _request(
    () => _dio.post<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    ),
  );

  Future<T> put<T>(
    String path, {
    Object? data,
    JsonMap? queryParameters,
    Options? options,
  }) => _request(
    () => _dio.put<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    ),
  );

  Future<T> patch<T>(
    String path, {
    Object? data,
    JsonMap? queryParameters,
    Options? options,
  }) => _request(
    () => _dio.patch<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    ),
  );

  Future<T> delete<T>(
    String path, {
    Object? data,
    JsonMap? queryParameters,
    Options? options,
  }) => _request(
    () => _dio.delete<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    ),
  );

  Future<T> _request<T>(Future<Response<T>> Function() call) async {
    try {
      final response = await call();
      if (response.data == null) {
        throw const ApiParseException('Response data is null');
      }
      return response.data as T;
    } on DioException catch (e) {
      throw e.toApiException();
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiUnknownException(e.toString());
    }
  }
}

class _LogInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    assert(() {
      // ignore: avoid_print
      print('[API] ${options.method} ${options.uri}');
      return true;
    }());
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    assert(() {
      // ignore: avoid_print
      print('[API] Error: ${err.message}');
      return true;
    }());
    super.onError(err, handler);
  }
}

final apiClientProvider = Provider<ApiClient>((_) => ApiClient());
