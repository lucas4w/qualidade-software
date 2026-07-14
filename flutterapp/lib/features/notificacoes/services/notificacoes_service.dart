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
      final response = await _dio.get<Map<String, dynamic>>('notificacoes/');
      await NotificacoesController.sincronizarContagem();

      if (response.statusCode == 200) {
        final Map<String, dynamic>? data = response.data;
        final List<dynamic> results =
            (data?['results'] as List<dynamic>?) ?? [];
        return results
            .map(
              (dynamic json) =>
                  Notificacao.fromJson(json as Map<String, dynamic>),
            )
            .toList();
      } else {
        throw Exception('Erro ao carregar notificações');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data ?? 'Falha na conexão');
    }
  }

  static Future<void> marcarComoLida(int id) async {
    await _dio.patch<Map<String, dynamic>>(
      'notificacoes/$id/',
      data: {'lida': true},
    );
    NotificacoesController.decrementar();
  }

  static Future<void> apagarNotificacao(int id) async {
    await _dio.delete<Map<String, dynamic>>('notificacoes/$id/');
    await NotificacoesController.sincronizarContagem();
  }

  static Future<void> apagarTodas() async {
    await _dio.delete<Map<String, dynamic>>('notificacoes/limpar-todas/');
    NotificacoesController.zerar();
  }

  static Future<int> getNaoLidas() async {
    final response = await _dio.get<Map<String, dynamic>>(
      'notificacoes/nao-lidas/',
    );
    final countValue = response.data?['count'];
    if (countValue == null) {
      return 0;
    }
    return countValue is int ? countValue : int.parse(countValue.toString());
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
