// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tables_store.mobx.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$TablesStore on _TablesStoreBase, Store {
  late final _$tablesListAtom = Atom(
    name: '_TablesStoreBase.tablesList',
    context: context,
  );

  @override
  ObservableList<Tables> get tablesList {
    _$tablesListAtom.reportRead();
    return super.tablesList;
  }

  @override
  set tablesList(ObservableList<Tables> value) {
    _$tablesListAtom.reportWrite(value, super.tablesList, () {
      super.tablesList = value;
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

  late final _$loadTablesAsyncAction = AsyncAction(
    '_TablesStoreBase.loadTables',
    context: context,
  );

  @override
  Future<void> loadTables(int adminId) {
    return _$loadTablesAsyncAction.run(() => super.loadTables(adminId));
  }

  @override
  String toString() {
    return '''
tablesList: ${tablesList},
isLoadingTables: ${isLoadingTables},
errorMessage: ${errorMessage}
    ''';
  }
}
