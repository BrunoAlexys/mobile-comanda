import 'package:mobile_comanda/model/tables.dart';
import 'package:mobile_comanda/service/tables_service.dart';
import 'package:mobx/mobx.dart';

part 'tables_store.mobx.g.dart';

class TablesStore = _TablesStoreBase with _$TablesStore;

abstract class _TablesStoreBase with Store {
  final TablesService _tablesService;

  _TablesStoreBase(this._tablesService);

  @observable
  ObservableList<Tables> tablesList = ObservableList<Tables>();

  @observable
  bool isLoadingTables = false;

  @observable
  String? errorMessage;

  @action
  Future<void> loadTables(int adminId) async {
    isLoadingTables = true;
    errorMessage = null;
    try {
      tablesList.clear();
      List<Tables> tables = await _tablesService.fetchTables(adminId);
      tablesList.addAll(tables);
    } catch (e) {
      errorMessage = 'Erro ao carregar mesas: $e';
      rethrow;
    } finally {
      isLoadingTables = false;
    }
  }
}
