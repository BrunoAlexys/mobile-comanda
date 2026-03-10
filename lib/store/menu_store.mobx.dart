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
  ObservableList<Menu> allMenus = ObservableList<Menu>();

  @observable
  bool isLoadingMenu = false;

  @observable
  bool isLoadingCategories = false;

  @observable
  String? errorMessage;

  @observable
  String searchQuery = '';

  @observable
  String? currentFilter;

  @computed
  List<Menu> get filteredMenu {
    if (searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      return allMenus.where((menu) {
        return menu.name.toLowerCase().contains(query) ||
            menu.description.toLowerCase().contains(query);
      }).toList();
    }

    return menuList.toList();
  }

  @action
  Future<void> loadAllMenu(int adminId) async {
    isLoadingMenu = true;
    errorMessage = null;
    try {
      allMenus.clear();
      final menus = await _menuService.fetchAllMenu(adminId);
      allMenus.addAll(menus);
    } catch (e) {
      errorMessage = 'Erro ao carregar menu: $e';
      rethrow;
    } finally {
      isLoadingMenu = false;
    }
  }

  @action
  Future<void> loadUserCategories(int adminId) async {
    isLoadingCategories = true;
    errorMessage = null;
    try {
      userCategories.clear();
      List<Category> fetchedCategories = await _menuService.fetchCategoryMenu(
        adminId,
      );
      userCategories.addAll(fetchedCategories);
    } catch (e) {
      errorMessage = 'Erro ao carregar categorias: $e';
      rethrow;
    } finally {
      isLoadingCategories = false;
    }
  }

  @action
  Future<void> loadMenu(int adminId, int categoryId) async {
    isLoadingMenu = true;
    errorMessage = null;
    try {
      menuList.clear();
      final menus = await _menuService.fetchMenu(adminId, categoryId);
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

  @action
  void setSearchQuery(String query) {
    searchQuery = query;
  }
}
