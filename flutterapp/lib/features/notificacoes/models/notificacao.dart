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
      id: json['id'] as int,
      tipo: json['tipo'] as String,
      titulo: json['titulo'] as String,
      mensagem: json['mensagem'] as String,
      dataEnvio: DateTime.parse(json['data_envio'] as String),
      tempoRelativo: json['tempo_relativo'] as String,
      lida: json['lida'] as bool,
    );
  }
}
