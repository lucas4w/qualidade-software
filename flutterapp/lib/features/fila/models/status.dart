class Status {
  final int? pacienteID;
  final int? ordem;
  final int? posicao;
  final String? status;
  final int? totalPessoasFila;
  final int? tempoEstimado;
  final bool? passouVez;
  final String? filaID;

  final bool? naFila;
  final bool? temAgendamento;
  final String? mensagem;
  final int? totalNaFila;
  final String? medico;
  final String? especialidade;
  final String? clinica;
  final String? dataAtendimento;
  final String? horarioAgendado;

  Status({
    this.pacienteID,
    this.ordem,
    this.posicao,
    this.status,
    this.totalPessoasFila,
    this.tempoEstimado,
    this.passouVez,
    this.filaID,

    this.naFila,
    this.temAgendamento,
    this.mensagem,
    this.totalNaFila,
    this.medico,
    this.especialidade,
    this.clinica,
    this.dataAtendimento,
    this.horarioAgendado,
  });

  factory Status.fromJson(Map<String, dynamic> json) {
    return Status(
      pacienteID: json['paciente'] as int?,
      ordem: json['ordem'] as int?,
      posicao: json['posicao'] as int?,
      status: json['status'] as String?,
      totalPessoasFila: json['total_pessoas_fila'] as int?,
      tempoEstimado: json['tempo_estimado'] as int?,
      passouVez: json['passou_vez'] as bool?,
      filaID: json['fila_id'] as String?,

      naFila: json['na_fila'] as bool?,
      temAgendamento: json['tem_agendamento'] as bool?,
      mensagem: json['mensagem'] as String?,
      totalNaFila: json['total_na_fila'] as int?,
      medico: json['medico'] as String?,
      especialidade: json['especialidade'] as String?,
      clinica: json['clinica'] as String?,
      dataAtendimento: json['data_atendimento'] as String?,
      horarioAgendado: json['horario_agendado'] as String?,
    );
  }
}

// caso1: na fila
// {"paciente":103,"status":"Presente","ordem":2,"posicao":2,"total_pessoas_fila":2,
// "tempo_estimado":15,"fila_id":"fila_225_20251230_010754","passou_vez":false}

// caso2: não está na fila
// {"na_fila":false,"tem_agendamento":true,
//"mensagem":"Você ainda não confirmou sua chegada. Confirme sua presença na recepção para entrar na fila.",
//"total_na_fila":3,"medico":"Pedro Lima","especialidade":"Dermatologia",
//"clinica":"Clinica Potiguar", "data_atendimento":"2025-12-29","horario_agendado":"19:30:00"}
