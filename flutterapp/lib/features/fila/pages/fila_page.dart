import 'package:flutter/material.dart';
import 'package:flutterapp/core/theme/pallete.dart';
import 'package:flutterapp/features/fila/models/status.dart';
import 'package:flutterapp/features/fila/services/fila_service.dart';
import 'package:flutterapp/features/fila/widgets/foradafila_widget.dart';
import 'package:flutterapp/features/fila/widgets/nafila_widget.dart';
import 'package:go_router/go_router.dart';

class FilaPage extends StatefulWidget {
  final String id;
  const FilaPage({super.key, required this.id});

  @override
  State<FilaPage> createState() => _FilaPageState();
}

class _FilaPageState extends State<FilaPage> {
  Status? _status;
  bool _isLoading = true;
  bool _hasError = false;
  bool _estaNaFila = false;

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
      final dados = await FilaService.buscarStatus(widget.id);
      setState(() {
        _status = dados;
        _estaNaFila = _status!.naFila ?? true;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  void pularVez(String? id) async {
    bool success = await FilaService.pularVez(id);
    if (success) {
      setState(() {
        _buscarDados();
      });
    } else {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Erro ao pular vez')));
      }
    }
  }

  void sairDaFila(String? id) async {
    bool success = await FilaService.sairDaFila(id);
    if (success) {
      if (mounted) {
        context.pop();
        final forceReload = DateTime.now().millisecondsSinceEpoch;
        context.go('/agendamentos?reload=$forceReload');
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Erro ao pular vez')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: getLogo(),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _buscarDados,
        color: AppPallete.primary,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _hasError
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('Erro ao carregar os dados'),
                          ElevatedButton(
                            onPressed: _buscarDados,
                            child: const Text('Tentar novamente'),
                          ),
                        ],
                      )
                    : _estaNaFila
                    ? Container(
                        alignment: AlignmentGeometry.topCenter,
                        child: NafilaWidget(
                          status: _status,
                          onSkip: () => pularVez(_status?.filaID),
                          onLeave: () => sairDaFila(_status?.filaID),
                        ),
                      )
                    : ForaDaFilaWidget(status: _status),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
