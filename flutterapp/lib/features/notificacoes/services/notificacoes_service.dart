import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/core/api/api.dart';
import '../models/notificacao.dart';

final GlobalKey<ScaffoldMessengerState> snackbarKey =
    GlobalKey<ScaffoldMessengerState>();

class NotificacoesService {
  static final Dio _dio = ApiClient.instance;

  static Future<List<Notificacao>> buscarNotificacoes() async {
    try {
      final response = await _dio.get('notificacoes/');
      NotificacoesController.sincronizarContagem();

      if (response.statusCode == 200) {
        final List<dynamic> results = response.data['results'];
        return results.map((json) => Notificacao.fromJson(json)).toList();
      } else {
        throw Exception('Erro ao carregar notificações');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data ?? 'Falha na conexão');
    }
  }

  static Future<void> marcarComoLida(int id) async {
    await _dio.patch('notificacoes/$id/', data: {'lida': true});
    NotificacoesController.decrementar();
  }

  static Future<void> apagarNotificacao(int id) async {
    await _dio.delete('notificacoes/$id/');
    NotificacoesController.sincronizarContagem();
  }

  static Future<void> apagarTodas() async {
    await _dio.delete('notificacoes/limpar-todas/');
    NotificacoesController.zerar();
  }

  static Future<int> getNaoLidas() async {
    final response = await _dio.get('notificacoes/nao-lidas/');
    return response.data['count'];
  }
}

class NotificacoesController {
  static final ValueNotifier<int> contadorNaoLidas = ValueNotifier<int>(0);
  static final StreamController<void> onNovaNotificacao =
      StreamController<void>.broadcast();

  static Future<void> sincronizarContagem() async {
    try {
      final int count = await NotificacoesService.getNaoLidas();
      contadorNaoLidas.value = count;
    } catch (e) {
      debugPrint('Erro ao sincronizar contador: $e');
    }
  }

  static void decrementar() => contadorNaoLidas.value--;
  static void zerar() => contadorNaoLidas.value = 0;
}
