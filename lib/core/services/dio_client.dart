import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../constants/api_constants.dart';
import 'secure_storage.dart'; // Pastikan file ini ada

class DioClient {
  static Dio? _instance;

  // Fungsi untuk mendapatkan instance Dio
  static Dio get instance {
    _instance ??= _createDio();
    return _instance!;
  }

  static Dio _createDio() {
    final dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: Duration(milliseconds: ApiConstants.connectTimeout),
      receiveTimeout: Duration(milliseconds: ApiConstants.receiveTimeout),
      headers: {'Content-Type': 'application/json'},
    ));

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Ambil token secara asinkron
        final token = await SecureStorageService.getToken(); 
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        debugPrint('[REQUEST] ${options.method} ${options.path}');
        return handler.next(options);
      },
      onResponse: (response, handler) {
        debugPrint('[RESPONSE] ${response.statusCode}');
        return handler.next(response);
      },
      onError: (DioException error, handler) async {
        debugPrint('[ERROR] ${error.response?.statusCode}');
        if (error.response?.statusCode == 401) {
          await SecureStorageService.clearAll();
          // Di sini Anda bisa menambahkan navigasi ke halaman Login
        }
        return handler.next(error);
      },
    ));

    return dio;
  }
}