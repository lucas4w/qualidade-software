import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/core/services/token_storage.dart';
import 'package:flutterapp/core/services/auth_service.dart';
import 'package:flutterapp/core/routing/app_routing.dart';

class ApiClient {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://192.168.1.216:8000/api/',
      connectTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds: 10),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  static bool _isRefreshing = false;
  static final List<({RequestOptions options, ErrorInterceptorHandler handler})>
  _requestQueue = [];

  static void init() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await TokenStorage.getAccessToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401 &&
              error.requestOptions.path != 'token/refresh/') {
            final originalRequest = error.requestOptions;

            _requestQueue.add((options: originalRequest, handler: handler));

            if (!_isRefreshing) {
              _isRefreshing = true;
              try {
                final refreshed = await _refreshToken();
                if (refreshed) {
                  await fetchAndSaveUserData();
                  final newToken = await TokenStorage.getAccessToken();

                  for (final item in _requestQueue) {
                    item.options.headers['Authorization'] = 'Bearer $newToken';
                    final response = await _dio.fetch<dynamic>(item.options);
                    item.handler.resolve(response);
                  }
                } else {
                  await _logout();
                  for (final item in _requestQueue) {
                    item.handler.reject(error);
                  }
                }
              } catch (e) {
                await _logout();
                for (final item in _requestQueue) {
                  item.handler.reject(error);
                }
              } finally {
                _isRefreshing = false;
                _requestQueue.clear();
              }
            }
            return;
          }
          handler.next(error);
        },
      ),
    );
  }

  static Future<bool> _refreshToken() async {
    final refreshToken = await TokenStorage.getRefreshToken();
    if (refreshToken == null) return false;

    try {
      final response = await _dio.post<Map<String, dynamic>>(
        'token/refresh/',
        data: {'refresh': refreshToken},
      );

      if (response.statusCode == 200) {
        final newAccess = response.data?['access'] as String?;
        final newRefresh = response.data?['refresh'] as String?;

        if (newAccess != null) {
          await TokenStorage.saveTokens(
            accessToken: newAccess,
            refreshToken: newRefresh ?? refreshToken,
          );
          return true;
        }
      }
    } on DioException catch (e) {
      debugPrint('Erro no refresh: ${e.message}');
    }
    return false;
  }

  static Future<void> fetchAndSaveUserData() async {
    try {
      final response = await _dio.get<dynamic>('user/me/');
      if (response.statusCode == 200) {
        final idServer = response.data['paciente_id']?.toString();
        final userID = response.data['id']?.toString();

        if (idServer != null && userID != null) {
          await AuthService().salvarUsuarioLogado(idServer, userID, null);
        }
      }
    } catch (e) {
      debugPrint('Erro ao buscar dados do usuário: $e');
    }
  }

  static Future<void> _logout() async {
    await TokenStorage.clearTokens();
    await AuthService().logout();
    router.go('/login');
  }

  static Dio get instance => _dio;
}
