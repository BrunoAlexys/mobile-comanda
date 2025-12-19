import 'package:mobile_comanda/model/category.dart';
import 'package:mobile_comanda/model/menu.dart';
import 'package:mobile_comanda/repository/dio_client.dart';

class MenuRepository {
  final DioClient _dioClient;

  MenuRepository(this._dioClient);

  Future<List<Category>> fetchCategoryFromMenu(int userId) async {
    try {
      final response = await _dioClient.get('/menu/user/$userId/categories');

      if (response.statusCode == 200 && response.data != null) {
        if (response.data is List) {
          return (response.data as List)
              .map((json) => Category.fromJson(json))
              .toList();
        }
        return [];
      } else {
        return [];
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Menu>> fetchMenu(int userId, int categoryId) async {
    try {
      final response = await _dioClient.get(
        '/menu/user/$userId/category/$categoryId',
      );
      if (response.statusCode == 200 && response.data != null) {
        if (response.data is List) {
          return (response.data as List)
              .map((json) => Menu.fromJson(json))
              .toList();
        }

        return [];
      } else {
        return [];
      }
    } catch (e) {
      rethrow;
    }
  }
}
