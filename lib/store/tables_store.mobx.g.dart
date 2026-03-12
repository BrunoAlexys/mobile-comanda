// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tables_store.mobx.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$TablesStore on _TablesStoreBase, Store {
  Computed<List<Tables>>? _$filteredTablesComputed;

  @override
  List<Tables> get filteredTables =>
      (_$filteredTablesComputed ??= Computed<List<Tables>>(
        () => super.filteredTables,
        name: '_TablesStoreBase.filteredTables',
      )).value;

  late final _$allTablesAtom = Atom(
    name: '_TablesStoreBase.allTables',
    context: context,
  );

  @override
  ObservableList<Tables> get allTables {
    _$allTablesAtom.reportRead();
    return super.allTables;
  }

  @override
  set allTables(ObservableList<Tables> value) {
    _$allTablesAtom.reportWrite(value, super.allTables, () {
      super.allTables = value;
    });
  }

  late final _$isLoadingTablesAtom = Atom(
    name: '_TablesStoreBase.isLoadingTables',
    context: context,
  );

  @override
  bool get isLoadingTables {
    _$isLoadingTablesAtom.reportRead();
    return super.isLoadingTables;
  }

  @override
  set isLoadingTables(bool value) {
    _$isLoadingTablesAtom.reportWrite(value, super.isLoadingTables, () {
      super.isLoadingTables = value;
    });
  }

  late final _$errorMessageAtom = Atom(
    name: '_TablesStoreBase.errorMessage',
    context: context,
  );

  @override
  String? get errorMessage {
    _$errorMessageAtom.reportRead();
    return super.errorMessage;
  }

  @override
  set errorMessage(String? value) {
    _$errorMessageAtom.reportWrite(value, super.errorMessage, () {
      super.errorMessage = value;
    });
  }

  late final _$currentFilterAtom = Atom(
    name: '_TablesStoreBase.currentFilter',
    context: context,
  );

  @override
  String? get currentFilter {
    _$currentFilterAtom.reportRead();
    return super.currentFilter;
  }

  @override
  set currentFilter(String? value) {
    _$currentFilterAtom.reportWrite(value, super.currentFilter, () {
      super.currentFilter = value;
    });
  }

  late final _$searchQueryAtom = Atom(
    name: '_TablesStoreBase.searchQuery',
    context: context,
  );

  @override
  String get searchQuery {
    _$searchQueryAtom.reportRead();
    return super.searchQuery;
  }

  @override
  set searchQuery(String value) {
    _$searchQueryAtom.reportWrite(value, super.searchQuery, () {
      super.searchQuery = value;
    });
  }

  late final _$loadTablesAsyncAction = AsyncAction(
    '_TablesStoreBase.loadTables',
    context: context,
  );

  @override
  Future<void> loadTables(int adminId) {
    return _$loadTablesAsyncAction.run(() => super.loadTables(adminId));
  }

  late final _$setFilterAsyncAction = AsyncAction(
    '_TablesStoreBase.setFilter',
    context: context,
  );

  @override
  Future<void> setFilter(int adminId, String? filter) {
    return _$setFilterAsyncAction.run(() => super.setFilter(adminId, filter));
  }

  late final _$_TablesStoreBaseActionController = ActionController(
    name: '_TablesStoreBase',
    context: context,
  );

  @override
  void setSearchQuery(String query) {
    final _$actionInfo = _$_TablesStoreBaseActionController.startAction(
      name: '_TablesStoreBase.setSearchQuery',
    );
    try {
      return super.setSearchQuery(query);
    } finally {
      _$_TablesStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
allTables: ${allTables},
isLoadingTables: ${isLoadingTables},
errorMessage: ${errorMessage},
currentFilter: ${currentFilter},
searchQuery: ${searchQuery},
filteredTables: ${filteredTables}
    ''';
  }
}
