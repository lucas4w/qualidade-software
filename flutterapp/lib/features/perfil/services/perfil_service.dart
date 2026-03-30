import 'package:dio/dio.dart';
import 'package:flutterapp/core/api/api.dart';
import 'package:flutterapp/core/services/auth_service.dart';
import 'package:flutterapp/features/perfil/models/perfil.dart';

class PerfilService {
  static final Dio _dio = ApiClient.instance;

  static Future<Perfil> buscarPerfil() async {
    final id = await AuthService().getPacienteIDLogado();
    try {
      final response = await _dio.get('pacientes/$id/');

      if (response.statusCode == 200) {
        final Map<String, dynamic> result = response.data;
        return Perfil.fromJson(result);
      } else {
        throw Exception('Erro ao buscar perfil');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data ?? 'Falha na conexão');
    }
  }
}


// http://localhost:8000/api/usuario/198/fila/fila_225_20251230_010754/status/