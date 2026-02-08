import 'package:mobile_comanda/model/tables.dart';
import 'package:mobile_comanda/repository/tables_repository.dart';

class TablesService {
  final TableRepository _tableRepository;

  TablesService(this._tableRepository);

  Future<List<Tables>> fetchTables(int adminId, {String? status}) async {
    return await _tableRepository.getTables(adminId, status: status);
  }
}
