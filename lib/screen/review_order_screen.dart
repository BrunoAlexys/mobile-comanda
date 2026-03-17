import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobile_comanda/core/app_routes.dart';
import 'package:mobile_comanda/core/locator.dart';
import 'package:mobile_comanda/model/applied_fee.dart';
import 'package:mobile_comanda/model/order.dart';
import 'package:mobile_comanda/model/order_item.dart';
import 'package:mobile_comanda/store/fee_store.mobx.dart';
import 'package:mobile_comanda/store/order_store.mobx.dart';
import 'package:mobile_comanda/store/user_store.mobx.dart';
import 'package:mobile_comanda/util/constants.dart';
import 'package:mobile_comanda/util/utils.dart';
import 'package:mobile_comanda/widgets/custom_alert.dart';
import 'package:mobile_comanda/widgets/custom_appbar.dart';
import 'package:mobile_comanda/widgets/custom_order.dart';
import 'package:mobile_comanda/widgets/custom_order_total.dart';
import 'package:mobile_comanda/widgets/custom_rate_button.dart';
import 'package:mobile_comanda/widgets/custom_loading.dart';

class ReviewOrderScreen extends StatefulWidget {
  const ReviewOrderScreen({super.key});

  @override
  State<ReviewOrderScreen> createState() => _ReviewOrderScreenState();
}

class _ReviewOrderScreenState extends State<ReviewOrderScreen> {
  final OrderStore _orderStore = locator<OrderStore>();
  final FeeStore _feeStore = locator<FeeStore>();
  final UserStore _userStore = locator<UserStore>();

  final TextEditingController _commentController = TextEditingController();
  static const int _maxLength = 150;
  int _currentLength = 0;
  bool _isInitializing = true;
  bool _isProcessing = false;
  String? idString;
  String? adminId;

  @override
  void initState() {
    super.initState();
    _commentController.addListener(_updateCharCount);
    _commentController.text = _orderStore.additionalComment;
    getAdminId();
    _loadInitFee();
  }

  @override
  void dispose() {
    _commentController.removeListener(_updateCharCount);
    _commentController.dispose();
    super.dispose();
  }

  Future<void> getAdminId() async {
    try {
      adminId = await _userStore.getAdminId();
    } catch (e) {
      if (mounted) {
        CustomAlert.warning(
          context: context,
          message: 'Falha ao obter ID do administrador: $e',
          position: AlertPosition.top,
        );
      }
    }
  }

  Future<void> _loadInitFee() async {
    try {
      idString = await _userStore.getAdminId();
      int? parsedId;
      if (idString != null) {
        parsedId = int.tryParse(idString!);
      }

      if (parsedId != null) {
        await Future.wait([
          _feeStore.fetchFeeByUser(parsedId),
          _orderStore.fetchNextOrderNumber(parsedId),
        ]);
      }
    } catch (e) {
      if (mounted) {
        CustomAlert.warning(
          context: context,
          message: 'Falha ao carregar dados iniciais: $e',
          position: AlertPosition.top,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isInitializing = false;
        });
      }
    }
  }

  void _updateCharCount() {
    setState(() {
      _currentLength = _commentController.text.length;
    });
    _orderStore.setAdditionalComment(_commentController.text.trim());
  }

  Map<String, OrderItem> _groupItems(List<OrderItem> items) {
    final Map<String, OrderItem> grouped = {};

    for (var item in items) {
      final key = '${item.menu.id}_${item.price}';

      if (grouped.containsKey(key)) {
        final existing = grouped[key]!;
        grouped[key] = OrderItem(
          id: existing.id,
          menu: existing.menu,
          price: existing.price,
          quantity: existing.quantity + item.quantity,
        );
      } else {
        grouped[key] = item;
      }
    }
    return grouped;
  }

  void _sendOrder() async {
    if (_orderStore.isLoading || _isProcessing) return;
    // Problema aqui
    debugPrint('Numero da mesa: ${_orderStore.tableNumber}');
    if (_orderStore.tableNumber == null || !_orderStore.isOrderValid) {
      if (mounted) {
        CustomAlert.warning(
          context: context,
          message:
              'Não foi possível enviar o pedido. Verifique os itens e a mesa.',
          position: AlertPosition.top,
        );
      }
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    try {
      final Order orderToSend = Order(
        tableNumber: _orderStore.tableNumber!,
        items: _orderStore.orders.toList(),
        additionalComment: _orderStore.additionalComment.isNotEmpty
            ? _orderStore.additionalComment
            : null,
        appliedFees: _orderStore.appliedFees.toList(),
        totalOrderPrice: _orderStore.totalOrderPrice,
        totalFeesValue: _orderStore.totalFeesValue,
        finalTotalPrice: _orderStore.finalTotalPrice,
        userId: idString!,
        adminId: int.parse(adminId!),
      );

      await Future.delayed(const Duration(milliseconds: 500));
      await _orderStore.sendOrder(orderToSend);

      if (mounted) {
        CustomAlert.success(
          context: context,
          message: 'Pedido enviado com sucesso!',
          position: AlertPosition.top,
        );

        _orderStore.clearOrder();

        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil(AppRoutes.home, (route) => false);
      }
    } catch (e) {
      if (mounted) {
        CustomAlert.error(
          context: context,
          message: 'Erro ao enviar pedido: $e',
          position: AlertPosition.top,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  Widget _buildCommentField() {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Column(
        children: [
          TextFormField(
            controller: _commentController,
            maxLines: 5,
            maxLength: _maxLength,
            decoration: InputDecoration(
              counterText: '',
              contentPadding: const EdgeInsets.all(12.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(
                  color: Utils.hexToColor(AppColors.primaryColor),
                  width: 1.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(
                  color: Utils.hexToColor(AppColors.primaryColor),
                  width: 1.5,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(
                  color: Utils.hexToColor(AppColors.primaryColor),
                  width: 1.5,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 4.0, top: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '$_currentLength/$_maxLength',
                  style: TextStyle(
                    fontSize: 14,
                    color: _currentLength == _maxLength
                        ? Utils.hexToColor(AppColors.burgundy)
                        : Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        if (_isInitializing) {
          return Scaffold(
            appBar: CustomAppBar(
              title: const Text(
                'Revisar Pedido',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              centerTitle: true,
              backgroundColorGradient: [
                Utils.hexToColor(AppColors.primaryColor),
                Utils.hexToColor(AppColors.secondaryColor),
              ],
              leading: const SizedBox.shrink(),
            ),
            body: const CustomLoading(loadingText: 'Carregando informações...'),
          );
        }

        final bool showLoading = _orderStore.isLoading || _isProcessing;

        final itemsToDisplay = _groupItems(
          _orderStore.orders.toList(),
        ).values.toList();

        final Order currentOrder = Order(
          id: _orderStore.tableNumber,
          tableNumber: _orderStore.tableNumber ?? 0,
          items: _orderStore.orders.toList(),
          additionalComment: _orderStore.additionalComment,
          appliedFees: _orderStore.appliedFees.toList(),
          totalOrderPrice: _orderStore.totalOrderPrice,
          totalFeesValue: _orderStore.totalFeesValue,
          finalTotalPrice: _orderStore.finalTotalPrice,
          userId: idString!,
        );

        return Scaffold(
          appBar: CustomAppBar(
            title: const Text(
              'Revisar Pedido',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            centerTitle: true,
            backgroundColorGradient: [
              Utils.hexToColor(AppColors.primaryColor),
              Utils.hexToColor(AppColors.secondaryColor),
            ],
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: showLoading
                  ? null
                  : () {
                      Navigator.pop(context);
                    },
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.notifications_none,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
            ],
          ),
          body: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 16,
                              right: 16,
                              top: 24,
                              bottom: 20,
                            ),
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(8),
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.white,
                                    spreadRadius: 2,
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 20,
                                  right: 20,
                                  top: 16,
                                  bottom: 16,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "# ${_orderStore.orderNumber.isNotEmpty ? _orderStore.orderNumber : '0000'}",
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "Mesa ${currentOrder.tableNumber.toString()}",
                                      style: TextStyle(
                                        color: Utils.hexToColor('9C9C9C'),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Horario de entrada',
                                          style: TextStyle(
                                            color: Utils.hexToColor('4B5563'),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          '${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}',
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 16,
                              right: 16,
                              top: 24,
                              bottom: 20,
                            ),
                            child: CustomOrder(
                              orders: [currentOrder],
                              tableNumber: currentOrder.tableNumber,
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(
                                  maxHeight: 250,
                                ),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: itemsToDisplay.length,
                                  itemBuilder: (context, index) {
                                    final item = itemsToDisplay[index];
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 4.0,
                                      ),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                        left: 16,
                                                        right: 8,
                                                      ),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        '${item.quantity}x ${item.menu.name}',
                                                        style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Text(
                                                        item.menu.description,
                                                        style: TextStyle(
                                                          color:
                                                              Utils.hexToColor(
                                                                '848484',
                                                              ),
                                                          fontSize: 12,
                                                          fontStyle:
                                                              FontStyle.italic,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                Utils.formatPrice(
                                                  item.price * item.quantity,
                                                ),
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Divider(
                                            color: Colors.grey.shade300,
                                            thickness: 1,
                                            height: 24,
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                          if (_orderStore.additionalComment.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 8.0,
                                left: 16,
                              ),
                              child: Text(
                                'Obs: ${_orderStore.additionalComment}',
                                style: TextStyle(
                                  color: Utils.hexToColor(AppColors.burgundy),
                                  fontSize: 12,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          const Padding(
                            padding: EdgeInsets.only(top: 24, left: 16),
                            child: Text(
                              'Adicionar Taxas',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 8.0,
                            ),
                            child: IgnorePointer(
                              ignoring: showLoading,
                              child: Column(
                                children: _feeStore.feeList.map((fee) {
                                  final AppliedFee feeToAddOrRemove =
                                      AppliedFee(
                                        id: fee.id,
                                        name: fee.name,
                                        percentage: fee.percentage,
                                      );

                                  final bool isApplied = _orderStore.appliedFees
                                      .any((f) => f.name == fee.name);

                                  return Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: CustomRateButton(
                                      onTap: () {
                                        if (isApplied) {
                                          _orderStore.removeFee(
                                            feeToAddOrRemove,
                                          );
                                        } else {
                                          _orderStore.addFee(feeToAddOrRemove);
                                        }
                                      },
                                      id: fee.id,
                                      text: fee.name,
                                      feePercentage: fee.percentage,
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 16, top: 16),
                            child: Text(
                              'Adicionar Comentário',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: _buildCommentField(),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                  CustomOrderTotal(
                    order: _orderStore.orders.toList(),
                    isOrderValid: _orderStore.isOrderValid,
                    finalTotalPrice: _orderStore.finalTotalPrice,
                    isLoading: showLoading,
                    textButton: 'Enviar Pedido',
                    onNext: () {
                      _sendOrder();
                    },
                  ),
                ],
              ),
              if (showLoading)
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                    child: CustomLoading(
                      loadingText: _orderStore.loadingMessage.isNotEmpty
                          ? _orderStore.loadingMessage
                          : 'Enviando Pedido...',
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
