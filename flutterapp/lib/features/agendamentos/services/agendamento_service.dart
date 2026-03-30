import 'package:dio/dio.dart';
import 'package:flutterapp/core/api/api.dart';
import 'package:flutterapp/core/services/auth_service.dart';
import 'package:flutterapp/features/agendamentos/models/agendamento.dart';

class AgendamentoService {
  static final Dio _dio = ApiClient.instance;

  static Future<List<Agendamento>> buscarAgendamentos() async {
    final id = await AuthService().getUserIDLogado();
    try {
      final response = await _dio.get('usuario/$id/agendamento/');

      if (response.statusCode == 200) {
        if (response.data is List) {
          final List<dynamic> results = response.data;
          return results.map((json) => Agendamento.fromJson(json)).toList();
        }
        return [];
      } else {
        throw Exception('Erro ao carregar agendamentos');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Falha na conexão');
    }
  }

  static Future<bool> cancelarAgendamento(int id) async {
    try {
      final response = await _dio.patch('agendamentos/$id/cancelar/');
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } on DioException catch (e) {
      throw Exception(e.response?.data ?? 'Falha na conexão');
    }
  }
}
