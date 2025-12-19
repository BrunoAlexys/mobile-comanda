import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobile_comanda/core/app_routes.dart';
import 'package:mobile_comanda/core/locator.dart';
import 'package:mobile_comanda/model/menu.dart';
import 'package:mobile_comanda/store/menu_store.mobx.dart';
import 'package:mobile_comanda/store/order_store.mobx.dart';
import 'package:mobile_comanda/store/user_store.mobx.dart';
import 'package:mobile_comanda/util/constants.dart';
import 'package:mobile_comanda/util/utils.dart';
import 'package:mobile_comanda/widgets/custom_alert.dart';
import 'package:mobile_comanda/widgets/custom_appbar.dart';
import 'package:mobile_comanda/widgets/custom_category_button.dart';
import 'package:mobile_comanda/widgets/custom_loading.dart';
import 'package:mobile_comanda/widgets/custom_order_total.dart';
import 'package:mobile_comanda/widgets/custom_product_item.dart';
import 'package:mobile_comanda/widgets/custom_select.dart';
import 'package:mobx/mobx.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final MenuStore _menuStore = locator<MenuStore>();
  final OrderStore _orderStore = locator<OrderStore>();
  final UserStore _userStore = locator<UserStore>();

  ReactionDisposer? _disposer;
  int? _selectedCategoryId;
  String? _selectedCategoryName;
  final Map<String, int> _productQuantities = {};
  int? _userId;
  bool _initialLoadComplete = false;
  bool _hasError = false;
  bool _isChangingCategory = false;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  String _getProductKey(int productId) {
    return '${_selectedCategoryId}_$productId';
  }

  int _getProductIdFromKey(String productKey) {
    return int.parse(productKey.split('_')[1]);
  }

  Future<void> _loadInitialData() async {
    try {
      final idString = await _userStore.getUserId();
      final int? parsedId = int.tryParse(idString);

      if (parsedId == null) {
        if (mounted) {
          setState(() {
            _hasError = true;
            _initialLoadComplete = true;
          });
          CustomAlert.warning(
            context: context,
            message: 'ID de usuário não encontrado. Por favor, faça login.',
            position: AlertPosition.top,
          );
        }
        return;
      }

      setState(() {
        _userId = parsedId;
        _hasError = false;
      });

      await _menuStore.loadUserCategories(_userId!);

      if (mounted) {
        if (_menuStore.userCategories.isNotEmpty) {
          final firstCategory = _menuStore.userCategories.first;

          setState(() {
            _selectedCategoryId = firstCategory.id;
            _selectedCategoryName = firstCategory.name;
          });

          await _loadMenu(_userId!, _selectedCategoryId!);
        }

        setState(() {
          _initialLoadComplete = true;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _initialLoadComplete = true;
        });
        CustomAlert.warning(
          context: context,
          message: 'Falha ao carregar dados do menu: $e',
          position: AlertPosition.top,
        );
      }
    }
  }

  Future<void> _loadMenu(int userId, int categoryId) async {
    try {
      await _menuStore.loadMenu(userId, categoryId);
      if (mounted) {
        setState(() {
          _hasError = false;
          _isChangingCategory = false;
        });
      }

      _updateOrderList();
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _isChangingCategory = false;
        });
        CustomAlert.warning(
          context: context,
          message: 'Falha ao carregar itens do menu: $e',
          position: AlertPosition.top,
        );
      }
    }
  }

  void _onCategorySelected(int categoryId) async {
    if (_userId != null && categoryId != _selectedCategoryId) {
      final category = _menuStore.userCategories.firstWhere(
        (c) => c.id == categoryId,
      );

      setState(() {
        _selectedCategoryId = categoryId;
        _selectedCategoryName = category.name;
        _isChangingCategory = true;
      });

      await _loadMenu(_userId!, categoryId);
    }
  }

  @override
  void dispose() {
    _disposer?.call();
    super.dispose();
  }

  void _updateOrderList() {
    final Map<int, int> productQuantities = {};

    _productQuantities.forEach((productKey, quantity) {
      if (quantity > 0) {
        final productId = _getProductIdFromKey(productKey);
        productQuantities[productId] = quantity;
      }
    });

    final allProducts = _getAllProductsList();
    _orderStore.updateOrders(productQuantities, allProducts);
  }

  List<Map<String, dynamic>> _getAllProductsList() {
    final List<Map<String, dynamic>> allProducts = [];

    _productQuantities.forEach((productKey, quantity) {
      if (quantity > 0) {
        final productId = _getProductIdFromKey(productKey);
        final categoryId = int.parse(productKey.split('_')[0]);

        final product = _findProductById(categoryId, productId);
        if (product != null) {
          allProducts.add({
            'id': product.id,
            'name': product.name,
            'description': product.description,
            'price': product.price,
            'category': {
              'id': product.category.id,
              'name': product.category.name,
            },
          });
        }
      }
    });

    return allProducts;
  }

  Menu? _findProductById(int categoryId, int productId) {
    if (_menuStore.allCategoryMenus.containsKey(categoryId)) {
      final menu = _menuStore.allCategoryMenus[categoryId]!
          .where((item) => item.id == productId)
          .cast<Menu?>()
          .firstOrNull;
      if (menu != null) return menu;
    }

    for (final categoryMenus in _menuStore.allCategoryMenus.values) {
      final menu = categoryMenus
          .where((item) => item.id == productId)
          .cast<Menu?>()
          .firstOrNull;
      if (menu != null) return menu;
    }

    return null;
  }

  Widget _buildCategorySection() {
    return Observer(
      builder: (_) {
        if (_menuStore.userCategories.isEmpty) {
          return const SizedBox.shrink();
        }

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _menuStore.userCategories.map((category) {
              final String name = category.name;
              final int categoryId = category.id;
              final IconData icon = CategoryIcon.getIconForCategory(name);
              final bool isSelected = _selectedCategoryId == categoryId;

              return Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: CustomCategoryButton(
                  label: name,
                  icon: icon,
                  isSelected: isSelected,
                  onPressed: () => _onCategorySelected(categoryId),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _buildMenuSection() {
    if (_isChangingCategory) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              Utils.hexToColor(AppColors.primaryColor),
            ),
          ),
        ),
      );
    }

    return Observer(
      builder: (_) {
        if (_hasError && _menuStore.menuList.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.error_outline, color: Colors.red, size: 48),
                  SizedBox(height: 8),
                  Text(
                    'Erro ao carregar itens do menu',
                    style: TextStyle(color: Colors.red, fontSize: 16),
                  ),
                ],
              ),
            ),
          );
        }

        if (_menuStore.menuList.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.restaurant_menu,
                    color: Colors.grey[400],
                    size: 48,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Nenhum item encontrado nesta categoria.',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        return Wrap(
          spacing: 16.0,
          runSpacing: 16.0,
          children: _menuStore.menuList.map((menuItem) {
            final int productId = menuItem.id;
            final String productKey = _getProductKey(productId);
            final int productQuantity = _productQuantities[productKey] ?? 0;
            return CustomProductItem(
              key: ValueKey('product_${_selectedCategoryId}_$productId'),
              productId: productId,
              productName: menuItem.name,
              productDescription: menuItem.description,
              productPrice: menuItem.price,
              quantity: productQuantity,
              onIncrement: () {
                setState(() {
                  _productQuantities[productKey] = productQuantity + 1;
                  _updateOrderList();
                });
              },
              onDecrement: () {
                setState(() {
                  if (productQuantity > 0) {
                    _productQuantities[productKey] = productQuantity - 1;
                    _updateOrderList();
                  }
                });
              },
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.restaurant_menu_outlined,
              color: Colors.grey[400],
              size: 64,
            ),
            SizedBox(height: 16),
            Text(
              'Nenhum item disponível no momento',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              'Entre em contato com o estabelecimento para mais informações.',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialLoadComplete) {
      return Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: CustomAppBar(
          title: Text(
            'Pedidos',
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
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              _orderStore.clearOrder();
              Navigator.pop(context);
            },
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.notifications_none,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
          ],
        ),
        body: CustomLoading(loadingText: 'Carregando o Menu...'),
      );
    }

    final hasCategories = _menuStore.userCategories.isNotEmpty;
    final hasMenuItems = _menuStore.menuList.isNotEmpty;

    if (!hasCategories && !hasMenuItems) {
      return Scaffold(
        appBar: CustomAppBar(
          title: Text(
            'Pedidos',
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
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              _orderStore.clearOrder();
              Navigator.pop(context);
            },
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.notifications_none,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
          ],
        ),
        body: _buildEmptyState(),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: CustomAppBar(
        title: Text(
          'Pedidos',
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
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            _orderStore.clearOrder();
            Navigator.pop(context);
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.notifications_none,
                color: Colors.white,
                size: 28,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20, top: 24),
                    child: Text(
                      'Selecionar Mesa',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Utils.hexToColor(AppColors.burgundy),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 12.0,
                    ),
                    child: Observer(
                      builder: (_) {
                        return CustomSelect<int>(
                          hint: 'Selecione uma mesa',
                          items: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
                          itemLabel: (item) => 'Mesa $item',
                          menuMaxHeight: 250.0,
                          value: _orderStore.tableNumber,
                          onChanged: (value) {
                            _orderStore.setTableNumber(value);
                          },
                        );
                      },
                    ),
                  ),
                  if (hasCategories) ...[
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Container(
                        height: 60,
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: _buildCategorySection(),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (hasCategories) ...[
                    Padding(
                      padding: const EdgeInsets.only(left: 20, top: 24),
                      child: Text(
                        _selectedCategoryName ?? 'Selecione uma categoria',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Utils.hexToColor(AppColors.burgundy),
                        ),
                      ),
                    ),
                  ],
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 12.0,
                          left: 8,
                          right: 8,
                        ),
                        child: _buildMenuSection(),
                      ),
                    ),
                  ),
                  Observer(
                    builder: (_) {
                      return CustomOrderTotal(
                        order: _orderStore.orders,
                        isOrderValid: _orderStore.isOrderValid,
                        finalTotalPrice: _orderStore.finalTotalPrice,
                        onNext: () {
                          if (_orderStore.tableNumber == null) {
                            CustomAlert.warning(
                              context: context,
                              message: 'Selecione uma mesa antes de continuar!',
                              position: AlertPosition.top,
                            );
                            return;
                          }

                          Navigator.pushNamed(context, AppRoutes.reviewOrder);
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
