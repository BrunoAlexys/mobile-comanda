import 'package:mobile_comanda/model/category.dart';
import 'package:mobile_comanda/model/menu.dart';
import 'package:mobile_comanda/service/menu_service.dart';
import 'package:mobx/mobx.dart';

part 'menu_store.mobx.g.dart';

class MenuStore = _MenuStoreBase with _$MenuStore;

abstract class _MenuStoreBase with Store {
  final MenuService _menuService;

  _MenuStoreBase(this._menuService);

  @observable
  ObservableList<Category> userCategories = ObservableList<Category>();

  @observable
  ObservableList<Menu> menuList = ObservableList<Menu>();

  @observable
  ObservableMap<int, ObservableList<Menu>> allCategoryMenus =
      ObservableMap<int, ObservableList<Menu>>();

  @observable
  bool isLoadingMenu = false;

  @observable
  bool isLoadingCategories = false;

  @observable
  String? errorMessage;

  @action
  Future<void> loadUserCategories(int userId) async {
    isLoadingCategories = true;
    errorMessage = null;
    try {
      userCategories.clear();
      List<Category> menuList = await _menuService.fetchCategoryMenu(userId);
      userCategories.addAll(menuList);
    } catch (e) {
      errorMessage = 'Erro ao carregar categorias: $e';
      rethrow;
    } finally {
      isLoadingCategories = false;
    }
  }

  @action
  Future<void> loadMenu(int userId, int categoryId) async {
    isLoadingMenu = true;
    errorMessage = null;
    try {
      menuList.clear();
      final menus = await _menuService.fetchMenu(userId, categoryId);
      menuList.addAll(menus);
      allCategoryMenus[categoryId] = ObservableList.of(menus);
    } catch (e) {
      errorMessage = 'Erro ao carregar menu: $e';
      rethrow;
    } finally {
      isLoadingMenu = false;
    }
  }

  @action
  List<Map<String, dynamic>> getAllProducts() {
    final List<Map<String, dynamic>> allProducts = [];

    allCategoryMenus.forEach((categoryId, menus) {
      for (final menu in menus) {
        allProducts.add({
          'id': menu.id,
          'name': menu.name,
          'description': menu.description,
          'price': menu.price,
          'category': menu.category.name,
        });
      }
    });

    return allProducts;
  }

  @action
  void clearCategories() {
    userCategories.clear();
  }

  @action
  void clearError() {
    errorMessage = null;
  }
}
