import 'package:mobile_comanda/model/category.dart';
import 'package:mobile_comanda/model/menu.dart';
import 'package:mobile_comanda/repository/menu_repository.dart';

class MenuService {
  final MenuRepository _menuRepository;

  MenuService(this._menuRepository);

  Future<List<Category>> fetchCategoryMenu(int userId) async {
    try {
      final category = await _menuRepository.fetchCategoryFromMenu(userId);
      return category;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Menu>> fetchMenu(int userId, int categoryId) async {
    try {
      final menu = await _menuRepository.fetchMenu(userId, categoryId);
      return menu;
    } catch (e) {
      rethrow;
    }
  }
}
