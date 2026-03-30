import 'package:dio/dio.dart';
import 'package:flutterapp/core/api/api.dart';
import 'package:flutterapp/core/services/token_storage.dart';

class LoginService {
  static final Dio _dio = ApiClient.instance;

  static Future<void> login(String username, String password) async {
    try {
      final response = await _dio.post(
        'token/',
        data: {'username': username, 'password': password},
      );
      final String accessToken = response.data['access'];
      final String refreshToken = response.data['refresh'];

      if (accessToken.isEmpty) {
        throw Exception('Access token não encontrado na resposta');
      }
      await TokenStorage.saveTokens(
        accessToken: accessToken,
        refreshToken: refreshToken,
      );

      await ApiClient.fetchAndSaveUserData();
    } on DioException catch (e) {
      if (e.response?.statusCode == 401 || e.response?.statusCode == 400) {
        final message =
            e.response?.data['detail'] ??
            e.response?.data['non_field_errors']?.first ??
            'Usuário ou senha incorretos';
        throw Exception(message);
      } else if (e.response?.statusCode != null &&
          e.response!.statusCode! >= 500) {
        throw Exception('Erro no servidor. Tente novamente mais tarde.');
      } else {
        throw Exception('Falha na conexão. Verifique sua internet.');
      }
    } catch (e) {
      throw Exception('Erro inesperado ao fazer login');
    }
  }
}
