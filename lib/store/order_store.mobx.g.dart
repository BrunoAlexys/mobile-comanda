// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_store.mobx.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$OrderStore on _OrderStore, Store {
  Computed<double>? _$totalOrderPriceComputed;

  @override
  double get totalOrderPrice => (_$totalOrderPriceComputed ??= Computed<double>(
    () => super.totalOrderPrice,
    name: '_OrderStore.totalOrderPrice',
  )).value;
  Computed<double>? _$totalFeesValueComputed;

  @override
  double get totalFeesValue => (_$totalFeesValueComputed ??= Computed<double>(
    () => super.totalFeesValue,
    name: '_OrderStore.totalFeesValue',
  )).value;
  Computed<double>? _$finalTotalPriceComputed;

  @override
  double get finalTotalPrice => (_$finalTotalPriceComputed ??= Computed<double>(
    () => super.finalTotalPrice,
    name: '_OrderStore.finalTotalPrice',
  )).value;
  Computed<bool>? _$isOrderValidComputed;

  @override
  bool get isOrderValid => (_$isOrderValidComputed ??= Computed<bool>(
    () => super.isOrderValid,
    name: '_OrderStore.isOrderValid',
  )).value;
  Computed<bool>? _$isLoadingComputed;

  @override
  bool get isLoading => (_$isLoadingComputed ??= Computed<bool>(
    () => super.isLoading,
    name: '_OrderStore.isLoading',
  )).value;

  late final _$ordersAtom = Atom(name: '_OrderStore.orders', context: context);

  @override
  ObservableList<OrderItem> get orders {
    _$ordersAtom.reportRead();
    return super.orders;
  }

  @override
  set orders(ObservableList<OrderItem> value) {
    _$ordersAtom.reportWrite(value, super.orders, () {
      super.orders = value;
    });
  }

  late final _$tableNumberAtom = Atom(
    name: '_OrderStore.tableNumber',
    context: context,
  );

  @override
  int? get tableNumber {
    _$tableNumberAtom.reportRead();
    return super.tableNumber;
  }

  @override
  set tableNumber(int? value) {
    _$tableNumberAtom.reportWrite(value, super.tableNumber, () {
      super.tableNumber = value;
    });
  }

  late final _$appliedFeesAtom = Atom(
    name: '_OrderStore.appliedFees',
    context: context,
  );

  @override
  ObservableList<AppliedFee> get appliedFees {
    _$appliedFeesAtom.reportRead();
    return super.appliedFees;
  }

  @override
  set appliedFees(ObservableList<AppliedFee> value) {
    _$appliedFeesAtom.reportWrite(value, super.appliedFees, () {
      super.appliedFees = value;
    });
  }

  late final _$additionalCommentAtom = Atom(
    name: '_OrderStore.additionalComment',
    context: context,
  );

  @override
  String get additionalComment {
    _$additionalCommentAtom.reportRead();
    return super.additionalComment;
  }

  @override
  set additionalComment(String value) {
    _$additionalCommentAtom.reportWrite(value, super.additionalComment, () {
      super.additionalComment = value;
    });
  }

  late final _$loadingMessageAtom = Atom(
    name: '_OrderStore.loadingMessage',
    context: context,
  );

  @override
  String get loadingMessage {
    _$loadingMessageAtom.reportRead();
    return super.loadingMessage;
  }

  @override
  set loadingMessage(String value) {
    _$loadingMessageAtom.reportWrite(value, super.loadingMessage, () {
      super.loadingMessage = value;
    });
  }

  late final _$_OrderStoreActionController = ActionController(
    name: '_OrderStore',
    context: context,
  );

  @override
  void addFee(AppliedFee fee) {
    final _$actionInfo = _$_OrderStoreActionController.startAction(
      name: '_OrderStore.addFee',
    );
    try {
      return super.addFee(fee);
    } finally {
      _$_OrderStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeFee(AppliedFee fee) {
    final _$actionInfo = _$_OrderStoreActionController.startAction(
      name: '_OrderStore.removeFee',
    );
    try {
      return super.removeFee(fee);
    } finally {
      _$_OrderStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void updateOrders(
    Map<int, int> productQuantities,
    List<Map<String, dynamic>> allProducts,
  ) {
    final _$actionInfo = _$_OrderStoreActionController.startAction(
      name: '_OrderStore.updateOrders',
    );
    try {
      return super.updateOrders(productQuantities, allProducts);
    } finally {
      _$_OrderStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setTableNumber(int? table) {
    final _$actionInfo = _$_OrderStoreActionController.startAction(
      name: '_OrderStore.setTableNumber',
    );
    try {
      return super.setTableNumber(table);
    } finally {
      _$_OrderStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setAdditionalComment(String comment) {
    final _$actionInfo = _$_OrderStoreActionController.startAction(
      name: '_OrderStore.setAdditionalComment',
    );
    try {
      return super.setAdditionalComment(comment);
    } finally {
      _$_OrderStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setLoadingMessage(String message) {
    final _$actionInfo = _$_OrderStoreActionController.startAction(
      name: '_OrderStore.setLoadingMessage',
    );
    try {
      return super.setLoadingMessage(message);
    } finally {
      _$_OrderStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearOrder() {
    final _$actionInfo = _$_OrderStoreActionController.startAction(
      name: '_OrderStore.clearOrder',
    );
    try {
      return super.clearOrder();
    } finally {
      _$_OrderStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
orders: ${orders},
tableNumber: ${tableNumber},
appliedFees: ${appliedFees},
additionalComment: ${additionalComment},
loadingMessage: ${loadingMessage},
totalOrderPrice: ${totalOrderPrice},
totalFeesValue: ${totalFeesValue},
finalTotalPrice: ${finalTotalPrice},
isOrderValid: ${isOrderValid},
isLoading: ${isLoading}
    ''';
  }
}
