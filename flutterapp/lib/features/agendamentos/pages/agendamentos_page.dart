import 'package:flutter/material.dart';
import 'package:flutterapp/core/theme/pallete.dart';
import 'package:flutterapp/features/agendamentos/models/agendamento.dart';
import 'package:flutterapp/features/agendamentos/services/agendamento_service.dart';
import 'package:flutterapp/features/agendamentos/widgets/agendamentocard_widget.dart';

class AgendamentosPage extends StatefulWidget {
  const AgendamentosPage({super.key});

  @override
  State<AgendamentosPage> createState() => _AgendamentosPageState();
}

class _AgendamentosPageState extends State<AgendamentosPage> {
  List<Agendamento>? _agendamentos;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _buscarDados();
  }

  Future<void> _buscarDados() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final dados = await AgendamentoService.buscarAgendamentos();
      if (dados.isNotEmpty) {
        dados.sort((a, b) {
          final aNaFila = a.filaID != null;
          final bNaFila = b.filaID != null;

          if (aNaFila && !bNaFila) return -1;
          if (!aNaFila && bNaFila) return 1;
          return a.dataAtendimento.compareTo(b.dataAtendimento);
        });
      }
      setState(() {
        _agendamentos = dados;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  Future<void> cancelarAgendamento(int id) async {
    setState(() {
      _isLoading = true;
    });

    try {
      bool success = await AgendamentoService.cancelarAgendamento(id);
      if (success) {
        setState(() {
          _agendamentos?.removeWhere((a) => a.id == id);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao cancelar agendamento')),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        title: const Text(
          'Meus agendamentos',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
        ),
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
                  const Text('Falha ao carregar os agendamentos'),
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
          : _agendamentos == null || _agendamentos!.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Nenhum agendamento marcado'),
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
                itemCount: _agendamentos!.length,
                itemBuilder: (context, index) {
                  final agend = _agendamentos![index];
                  return Column(
                    key: ValueKey(agend.id),
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: AgendamentoCard(
                          agendamento: agend,
                          onCancel: () => cancelarAgendamento(agend.id),
                        ),
                      ),
                      const SizedBox(height: 11),
                    ],
                  );
                },
              ),
            ),
    );
  }
}
