import 'package:mobile_comanda/enum/status_table.dart';
import 'package:mobile_comanda/model/tables.dart';
import 'package:mobile_comanda/service/tables_service.dart';
import 'package:mobx/mobx.dart';

part 'tables_store.mobx.g.dart';

class TablesStore = _TablesStoreBase with _$TablesStore;

abstract class _TablesStoreBase with Store {
  final TablesService _tablesService;

  _TablesStoreBase(this._tablesService);

  @observable
  ObservableList<Tables> allTables = ObservableList<Tables>();

  @observable
  bool isLoadingTables = false;

  @observable
  String? errorMessage;

  @observable
  String? currentFilter;

  @observable
  String searchQuery = '';

  @computed
  List<Tables> get filteredTables {
    List<Tables> list = allTables.toList();

    if (currentFilter != null && currentFilter!.isNotEmpty) {
      list = list
          .where(
            (table) =>
                table.status.name.toUpperCase() == currentFilter!.toUpperCase(),
          )
          .toList();
    }

    if (searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      list = list.where((table) {
        return table.numberTable.toString().contains(query) ||
            table.status.description.toLowerCase().contains(query);
      }).toList();
    }

    return list;
  }

  @action
  Future<void> loadTables(int adminId) async {
    isLoadingTables = true;
    errorMessage = null;
    try {
      allTables.clear();

      List<Tables> tables = await _tablesService.fetchTables(adminId);

      allTables.addAll(tables);
    } catch (e) {
      errorMessage = 'Erro ao carregar mesas: $e';
      rethrow;
    } finally {
      isLoadingTables = false;
    }
  }

  @action
  Future<void> setFilter(int adminId, String? filter) async {
    currentFilter = filter;
  }

  @action
  void setSearchQuery(String query) {
    searchQuery = query;
  }

  @action
  void updateTableStatusWs(Map<String, dynamic> data) {
    final tableId = data['id'];
    final newStatusString = data['status'];

    final tableIndex = allTables.indexWhere((t) => t.id == tableId);

    if (tableIndex != -1) {
      final currentTable = allTables[tableIndex];

      StatusTable newStatus = StatusTable.values.firstWhere(
        (e) => e.name.toUpperCase() == newStatusString.toString().toUpperCase(),
        orElse: () => currentTable.status,
      );

      allTables[tableIndex] = currentTable.copyWith(status: newStatus);
      allTables = ObservableList.of(allTables);
    }
  }
}
