// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu_store.mobx.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$MenuStore on _MenuStoreBase, Store {
  late final _$userCategoriesAtom = Atom(
    name: '_MenuStoreBase.userCategories',
    context: context,
  );

  @override
  ObservableList<Category> get userCategories {
    _$userCategoriesAtom.reportRead();
    return super.userCategories;
  }

  @override
  set userCategories(ObservableList<Category> value) {
    _$userCategoriesAtom.reportWrite(value, super.userCategories, () {
      super.userCategories = value;
    });
  }

  late final _$menuListAtom = Atom(
    name: '_MenuStoreBase.menuList',
    context: context,
  );

  @override
  ObservableList<Menu> get menuList {
    _$menuListAtom.reportRead();
    return super.menuList;
  }

  @override
  set menuList(ObservableList<Menu> value) {
    _$menuListAtom.reportWrite(value, super.menuList, () {
      super.menuList = value;
    });
  }

  late final _$allCategoryMenusAtom = Atom(
    name: '_MenuStoreBase.allCategoryMenus',
    context: context,
  );

  @override
  ObservableMap<int, ObservableList<Menu>> get allCategoryMenus {
    _$allCategoryMenusAtom.reportRead();
    return super.allCategoryMenus;
  }

  @override
  set allCategoryMenus(ObservableMap<int, ObservableList<Menu>> value) {
    _$allCategoryMenusAtom.reportWrite(value, super.allCategoryMenus, () {
      super.allCategoryMenus = value;
    });
  }

  late final _$isLoadingMenuAtom = Atom(
    name: '_MenuStoreBase.isLoadingMenu',
    context: context,
  );

  @override
  bool get isLoadingMenu {
    _$isLoadingMenuAtom.reportRead();
    return super.isLoadingMenu;
  }

  @override
  set isLoadingMenu(bool value) {
    _$isLoadingMenuAtom.reportWrite(value, super.isLoadingMenu, () {
      super.isLoadingMenu = value;
    });
  }

  late final _$isLoadingCategoriesAtom = Atom(
    name: '_MenuStoreBase.isLoadingCategories',
    context: context,
  );

  @override
  bool get isLoadingCategories {
    _$isLoadingCategoriesAtom.reportRead();
    return super.isLoadingCategories;
  }

  @override
  set isLoadingCategories(bool value) {
    _$isLoadingCategoriesAtom.reportWrite(value, super.isLoadingCategories, () {
      super.isLoadingCategories = value;
    });
  }

  late final _$errorMessageAtom = Atom(
    name: '_MenuStoreBase.errorMessage',
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

  late final _$loadUserCategoriesAsyncAction = AsyncAction(
    '_MenuStoreBase.loadUserCategories',
    context: context,
  );

  @override
  Future<void> loadUserCategories(int adminId) {
    return _$loadUserCategoriesAsyncAction.run(
      () => super.loadUserCategories(adminId),
    );
  }

  late final _$loadMenuAsyncAction = AsyncAction(
    '_MenuStoreBase.loadMenu',
    context: context,
  );

  @override
  Future<void> loadMenu(int adminId, int categoryId) {
    return _$loadMenuAsyncAction.run(() => super.loadMenu(adminId, categoryId));
  }

  late final _$_MenuStoreBaseActionController = ActionController(
    name: '_MenuStoreBase',
    context: context,
  );

  @override
  List<Map<String, dynamic>> getAllProducts() {
    final _$actionInfo = _$_MenuStoreBaseActionController.startAction(
      name: '_MenuStoreBase.getAllProducts',
    );
    try {
      return super.getAllProducts();
    } finally {
      _$_MenuStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearCategories() {
    final _$actionInfo = _$_MenuStoreBaseActionController.startAction(
      name: '_MenuStoreBase.clearCategories',
    );
    try {
      return super.clearCategories();
    } finally {
      _$_MenuStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearError() {
    final _$actionInfo = _$_MenuStoreBaseActionController.startAction(
      name: '_MenuStoreBase.clearError',
    );
    try {
      return super.clearError();
    } finally {
      _$_MenuStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
userCategories: ${userCategories},
menuList: ${menuList},
allCategoryMenus: ${allCategoryMenus},
isLoadingMenu: ${isLoadingMenu},
isLoadingCategories: ${isLoadingCategories},
errorMessage: ${errorMessage}
    ''';
  }
}
