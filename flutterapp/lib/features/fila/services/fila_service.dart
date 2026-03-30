import 'package:dio/dio.dart';
import 'package:flutterapp/core/api/api.dart';
import 'package:flutterapp/core/services/auth_service.dart';
import 'package:flutterapp/features/fila/models/status.dart';

class FilaService {
  static final Dio _dio = ApiClient.instance;

  static Future<Status> buscarStatus(idFila) async {
    final id = await AuthService().getUserIDLogado();
    try {
      final response = await _dio.get('usuario/$id/fila/$idFila/status/');

      if (response.statusCode == 200) {
        final Map<String, dynamic> result = response.data;
        return Status.fromJson(result);
      } else {
        throw Exception('Erro ao buscar status');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data ?? 'Falha na conexão');
    }
  }

  static Future<bool> pularVez(idFila) async {
    final id = await AuthService().getUserIDLogado();
    try {
      final response = await _dio.patch(
        'usuario/$id/fila/$idFila/',
        data: {'acao': 'pular_vez'},
      );

      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } on DioException {
      return false;
    }
  }

  static Future<bool> sairDaFila(idFila) async {
    final id = await AuthService().getUserIDLogado();
    try {
      final response = await _dio.delete('usuario/$id/fila/$idFila/');
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } on DioException {
      return false;
    }
  }
}


// http://localhost:8000/api/usuario/198/fila/fila_225_20251230_010754/status/