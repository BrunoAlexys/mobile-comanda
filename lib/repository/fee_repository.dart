import 'package:mobile_comanda/model/applied_fee.dart';
import 'package:mobile_comanda/repository/dio_client.dart';

class FeeRepository {
  final DioClient _dioClient;

  FeeRepository(this._dioClient);

  Future<List<AppliedFee>> fetchFeeByUser(int userId) async {
    try {
      final response = await _dioClient.get('/fees/user/$userId');

      if (response.statusCode == 200 && response.data != null) {
        if (response.data is List) {
          return (response.data as List)
              .map((json) => AppliedFee.fromJson(json))
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
