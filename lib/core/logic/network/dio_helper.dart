import 'package:dio/dio.dart';
import 'dio_factory.dart';

class DioHelper {
  static Dio? _dio;

  static Future<void> init() async {
    _dio ??= await DioFactory().createDio();
  }

  static Dio get _instance {
    if (_dio == null) {
      throw Exception(
        "DioHelper not initialized! Call DioHelper.init() first.",
      );
    }
    return _dio!;
  }

  static Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    return await _instance.get(path, queryParameters: queryParameters);
  }

  static Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    return await _instance.post(
      path,
      data: data,
      queryParameters: queryParameters,
    );
  }

  static Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    return await _instance.put(
      path,
      data: data,
      queryParameters: queryParameters,
    );
  }

  static Future<Response> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    return await _instance.patch(
      path,
      data: data,
      queryParameters: queryParameters,
    );
  }

  static Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    return await _instance.delete(
      path,
      data: data,
      queryParameters: queryParameters,
    );
  }
}
