import 'package:flutter/material.dart';
import 'package:flutterapp/core/theme/pallete.dart';
import 'package:flutterapp/features/notificacoes/models/notificacao.dart';
import 'package:flutterapp/features/notificacoes/services/notificacoes_service.dart';

class NotificacaoCard extends StatefulWidget {
  final Notificacao notificacao;
  final VoidCallback onDelete;
  const NotificacaoCard({
    super.key,
    required this.notificacao,
    required this.onDelete,
  });

  @override
  State<NotificacaoCard> createState() => _NotificacaoCardState();
}

class _NotificacaoCardState extends State<NotificacaoCard> {
  late bool _lida = true;

  @override
  void initState() {
    super.initState();
    _lida = widget.notificacao.lida;
  }

  void marcarComoLida() {
    if (_lida) return;
    NotificacoesService.marcarComoLida(widget.notificacao.id);
    setState(() {
      _lida = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: marcarComoLida,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              if (!_lida) Container(width: 6, color: AppPallete.primary),
              SizedBox(
                height: 30,
                width: 30,
                child: Icon(
                  Icons.notifications,
                  size: 20,
                  color: AppPallete.primary,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: Text(
                                    widget.notificacao.titulo,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),

                                if (!_lida)
                                  Icon(
                                    Icons.circle,
                                    size: 12,
                                    color: AppPallete.primary,
                                  ),

                                IconButton(
                                  visualDensity: VisualDensity.compact,
                                  padding: EdgeInsets.zero,
                                  icon: const Icon(
                                    Icons.close,
                                    size: 20,
                                    color: Colors.grey,
                                  ),
                                  onPressed: widget.onDelete,
                                ),
                              ],
                            ),
                            Text(
                              widget.notificacao.mensagem,
                              style: TextStyle(fontSize: 13),
                            ),
                            SizedBox(height: 7),
                            Text(
                              widget.notificacao.tempoRelativo,
                              style: TextStyle(
                                color: const Color.fromARGB(255, 131, 131, 131),
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
