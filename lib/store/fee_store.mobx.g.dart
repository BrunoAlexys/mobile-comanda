// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fee_store.mobx.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$FeeStore on _FeeStoreBase, Store {
  late final _$feeListAtom = Atom(
    name: '_FeeStoreBase.feeList',
    context: context,
  );

  @override
  ObservableList<AppliedFee> get feeList {
    _$feeListAtom.reportRead();
    return super.feeList;
  }

  @override
  set feeList(ObservableList<AppliedFee> value) {
    _$feeListAtom.reportWrite(value, super.feeList, () {
      super.feeList = value;
    });
  }

  late final _$isLoadingAtom = Atom(
    name: '_FeeStoreBase.isLoading',
    context: context,
  );

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$fetchFeeByUserAsyncAction = AsyncAction(
    '_FeeStoreBase.fetchFeeByUser',
    context: context,
  );

  @override
  Future<void> fetchFeeByUser(int userId) {
    return _$fetchFeeByUserAsyncAction.run(() => super.fetchFeeByUser(userId));
  }

  @override
  String toString() {
    return '''
feeList: ${feeList},
isLoading: ${isLoading}
    ''';
  }
}
