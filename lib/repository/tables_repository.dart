import 'package:mobile_comanda/model/tables.dart';
import 'package:mobile_comanda/repository/dio_client.dart';

class TableRepository {
  final DioClient _dioClient;

  TableRepository(this._dioClient);

  Future<List<Tables>> getTables(int adminId, {String? status}) async {
    try {
      final queryParams = <String, dynamic>{};

      if (status != null && status.isNotEmpty) {
        queryParams['status'] = status;
      }

      final response = await _dioClient.get(
        '/tables/$adminId',
        queryParameters: queryParams,
      );

      if (response.statusCode == 200 && response.data != null) {
        final list = response.data as List? ?? [];
        return list.map((json) => Tables.fromJson(json)).toList();
      }

      return [];
    } catch (e) {
      throw Exception('Failed to load tables: $e');
    }
  }
}
