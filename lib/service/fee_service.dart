import 'package:mobile_comanda/model/applied_fee.dart';
import 'package:mobile_comanda/repository/fee_repository.dart';

class FeeService {
  final FeeRepository _feeRepository;

  FeeService(this._feeRepository);

  Future<List<AppliedFee>> fetchFeeByUser(int userId) async {
    try {
      final fee = await _feeRepository.fetchFeeByUser(userId);
      return fee;
    } catch (e) {
      rethrow;
    }
  }
}
