import 'package:flutterapp/core/database/database_manager.dart';

class AuthService {
  static const String _table = 'users';
  static const String _pacienteIDColumn = 'pacienteID';
  static const String _userIDColumn = 'userID';
  static const String _dispositivoIdColumn = 'dispositivoId';

  final DatabaseManager _dbManager = DatabaseManager.instance;

  Future<void> salvarUsuarioLogado(
    String pacienteID,
    String userID,
    int? dispositivoId,
  ) async {
    final db = await _dbManager.database;

    await db.delete(_table);

    await db.insert(_table, {
      _pacienteIDColumn: pacienteID,
      _userIDColumn: userID,
      if (dispositivoId != null) _dispositivoIdColumn: dispositivoId,
    });
  }

  Future<String?> getPacienteIDLogado() async {
    final db = await _dbManager.database;
    final result = await db.query(
      _table,
      columns: [_pacienteIDColumn],
      limit: 1,
    );

    if (result.isNotEmpty) {
      return result.first[_pacienteIDColumn] as String?;
    }
    return null;
  }

  Future<String?> getUserIDLogado() async {
    final db = await _dbManager.database;
    final result = await db.query(_table, columns: [_userIDColumn], limit: 1);

    if (result.isNotEmpty) {
      return result.first[_userIDColumn] as String?;
    }
    return null;
  }

  Future<int?> getDispositivoIdLogado() async {
    final db = await _dbManager.database;
    final result = await db.query(
      _table,
      columns: [_dispositivoIdColumn],
      limit: 1,
    );
    return result.isNotEmpty
        ? result.first[_dispositivoIdColumn] as int?
        : null;
  }

  Future<void> logout() async {
    final db = await _dbManager.database;
    await db.delete(_table);
  }
}
