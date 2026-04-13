import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutterapp/core/theme/pallete.dart';
import 'package:flutterapp/features/notificacoes/models/notificacao.dart';
import 'package:flutterapp/features/notificacoes/services/notificacoes_service.dart';
import 'package:flutterapp/features/notificacoes/widgets/notificacaocard_widget.dart';

class NotificacoesPage extends StatefulWidget {
  const NotificacoesPage({super.key});

  @override
  State<NotificacoesPage> createState() => _NotificacoesPageState();
}

class _NotificacoesPageState extends State<NotificacoesPage> {
  StreamSubscription? _subscription;
  List<Notificacao>? _notificacoes;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _buscarDados();
    _subscription = NotificacoesController.onNovaNotificacao.stream.listen((_) {
      _buscarDados();
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  Future<void> _buscarDados() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final dados = await NotificacoesService.buscarNotificacoes();
      setState(() {
        _notificacoes = dados;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  Future<void> apagarNotificacao(int id) async {
    setState(() {
      _notificacoes?.removeWhere((n) => n.id == id);
    });

    try {
      await NotificacoesService.apagarNotificacao(id);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao apagar notificação')),
        );
      }
    }
  }

  Future<void> apagarTodas() async {
    if (_notificacoes!.isEmpty) return;
    try {
      await NotificacoesService.apagarTodas();
      setState(() {
        _notificacoes?.clear();
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao limpar notificações')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notificações',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
        ),
        actions: [
          OutlinedButton(
            onPressed: _notificacoes?.isNotEmpty == true ? apagarTodas : null,
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.black,
              shadowColor: Colors.transparent,
              side: const BorderSide(
                color: Color.fromARGB(255, 192, 192, 192),
                width: 1,
              ),
              padding: const EdgeInsets.all(9),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.delete_outline_rounded,
                  color: const Color.fromARGB(255, 101, 108, 124),
                ),
                const SizedBox(width: 3),
                Text(
                  'Limpar todas',
                  style: TextStyle(
                    color: const Color.fromARGB(255, 101, 108, 124),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 7),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppPallete.primary),
            )
          : _hasError
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text('Falha ao carregar as notificações'),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: _buscarDados,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppPallete.primary,
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.refresh_rounded),
                        SizedBox(width: 8),
                        Text('Tentar novamente'),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : _notificacoes == null || _notificacoes!.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Nenhuma notificação no momento'),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: _buscarDados,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppPallete.primary,
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.refresh_rounded),
                        SizedBox(width: 8),
                        Text('Atualizar'),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: _buscarDados,
              color: AppPallete.primary,
              child: ListView.builder(
                itemCount: _notificacoes!.length,
                itemBuilder: (context, index) {
                  final notif = _notificacoes![index];
                  return Column(
                    key: ValueKey(notif.id),
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: NotificacaoCard(
                          notificacao: notif,
                          onDelete: () => apagarNotificacao(notif.id),
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  );
                },
              ),
            ),
    );
  }
}
