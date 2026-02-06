import 'package:mobile_comanda/model/tables.dart';
import 'package:mobile_comanda/repository/dio_client.dart';

class TableRepository {
  final DioClient _dioClient;

  TableRepository(this._dioClient);

  Future<List<Tables>> getTables(int adminId) async {
    try {
      final response = await _dioClient.get('/tables/$adminId');
      if (response.statusCode == 200 && response.data != null) {
        if (response.data is List) {
          return (response.data as List)
              .map((json) => Tables.fromJson(json))
              .toList();
        }
        return [];
      } else {
        throw Exception('Failed to load tables: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load tables: $e');
    }
  }
}
