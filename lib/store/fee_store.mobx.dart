import 'package:mobile_comanda/model/applied_fee.dart';
import 'package:mobile_comanda/service/fee_service.dart';
import 'package:mobx/mobx.dart';

part 'fee_store.mobx.g.dart';

class FeeStore = _FeeStoreBase with _$FeeStore;

abstract class _FeeStoreBase with Store {
  final FeeService _feeService;

  _FeeStoreBase(this._feeService);

  @observable
  ObservableList<AppliedFee> feeList = ObservableList<AppliedFee>();

  @observable
  bool isLoading = false;

  @action
  Future<void> fetchFeeByUser(int userId) async {
    isLoading = true;
    try {
      feeList.clear();
      final fees = await _feeService.fetchFeeByUser(userId);
      feeList.addAll(fees);
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
    }
  }
}
