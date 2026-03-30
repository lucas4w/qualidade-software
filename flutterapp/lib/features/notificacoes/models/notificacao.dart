class Notificacao {
  final int id;
  final String tipo;
  final String titulo;
  final String mensagem;
  final DateTime dataEnvio;
  final String tempoRelativo;
  final bool lida;

  Notificacao({
    required this.id,
    required this.tipo,
    required this.titulo,
    required this.mensagem,
    required this.dataEnvio,
    required this.tempoRelativo,
    required this.lida,
  });

  factory Notificacao.fromJson(Map<String, dynamic> json) {
    return Notificacao(
      id: json['id'],
      tipo: json['tipo'],
      titulo: json['titulo'],
      mensagem: json['mensagem'],
      dataEnvio: DateTime.parse(json['data_envio']),
      tempoRelativo: json['tempo_relativo'] ?? '',
      lida: json['lida'],
    );
  }
}
