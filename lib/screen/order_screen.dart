import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobile_comanda/core/app_routes.dart';
import 'package:mobile_comanda/core/locator.dart';
import 'package:mobile_comanda/store/menu_store.mobx.dart';
import 'package:mobile_comanda/store/order_store.mobx.dart';
import 'package:mobile_comanda/store/user_store.mobx.dart';
import 'package:mobile_comanda/util/constants.dart';
import 'package:mobile_comanda/util/utils.dart';
import 'package:mobile_comanda/widgets/custom_alert.dart';
import 'package:mobile_comanda/widgets/custom_appbar.dart';
import 'package:mobile_comanda/widgets/custom_category_button.dart';
import 'package:mobile_comanda/widgets/custom_input.dart';
import 'package:mobile_comanda/widgets/custom_loading.dart';
import 'package:mobile_comanda/widgets/custom_order_total.dart';
import 'package:mobile_comanda/widgets/custom_product_item.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final MenuStore _menuStore = locator<MenuStore>();
  final OrderStore _orderStore = locator<OrderStore>();
  final UserStore _userStore = locator<UserStore>();

  int? _selectedCategoryId;
  String? _selectedCategoryName;
  int? _userId;
  bool _initialLoadComplete = false;
  bool _hasError = false;
  bool _isChangingCategory = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    try {
      final idString = await _userStore.getAdminId();
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

      await _menuStore.loadAllMenu(_userId!);

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
        _menuStore.setSearchQuery('');
      });

      await _loadMenu(_userId!, categoryId);
    }
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
              final bool isSelected = _selectedCategoryId == categoryId;

              return Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: CustomCategoryButton(
                  label: name,
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
        if (_hasError && _menuStore.filteredMenu.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
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

        if (_menuStore.filteredMenu.isEmpty) {
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
                  const SizedBox(height: 8),
                  Text(
                    'Nenhum item encontrado.',
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
          children: _menuStore.filteredMenu.asMap().entries.map((entry) {
            final int index = entry.key;
            final menuItem = entry.value;
            final int productId = menuItem.id;
            final int productQuantity = _orderStore.getQuantity(productId);

            return CustomProductItem(
              key: ValueKey('product_${productId}_$index'),
              productId: productId,
              productName: menuItem.name,
              productDescription: menuItem.description,
              productPrice: menuItem.price,
              quantity: productQuantity,
              imageUrl: menuItem.imageUrl,
              onIncrement: () => _orderStore.incrementProduct(menuItem),
              onDecrement: () => _orderStore.decrementProduct(menuItem),
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
            const SizedBox(height: 16),
            Text(
              'Nenhum item disponível no momento',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  CustomAppBar _buildAppBar() {
    return CustomAppBar(
      title: const Text(
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
        icon: const Icon(Icons.arrow_back, color: Colors.white),
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
            icon: const Icon(
              Icons.notifications_none,
              color: Colors.white,
              size: 28,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialLoadComplete) {
      return Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: _buildAppBar(),
        body: const CustomLoading(loadingText: 'Carregando o Menu...'),
      );
    }

    final hasCategories = _menuStore.userCategories.isNotEmpty;
    final hasMenuItems = _menuStore.menuList.isNotEmpty;

    if (!hasCategories && !hasMenuItems) {
      return Scaffold(appBar: _buildAppBar(), body: _buildEmptyState());
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      resizeToAvoidBottomInset: true,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Container(
            color: Colors.grey[50],
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
                  child: CustomInput(
                    hintText: 'Buscar pratos...',
                    borderRadius: 16.0,
                    fillColor: Colors.white,
                    borderColor: const Color(0xFFE2E8F0),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Color(0xFF94A3B8),
                      size: 28,
                    ),
                    onChanged: (value) {
                      if (_debounce?.isActive ?? false) _debounce!.cancel();
                      _debounce = Timer(const Duration(milliseconds: 500), () {
                        _menuStore.setSearchQuery(value);
                      });
                    },
                  ),
                ),
                if (hasCategories)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0, top: 10.0),
                    child: SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: _buildCategorySection(),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 10.0,
                    left: 20.0,
                    right: 20.0,
                  ),
                  child: Divider(height: 1, color: Utils.hexToColor('EAEAEA')),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 16.0,
                    ),
                    child: _buildMenuSection(),
                  ),
                ),
                Observer(
                  builder: (_) {
                    return CustomOrderTotal(
                      order: _orderStore.orders,
                      isOrderValid: _orderStore.isOrderValid,
                      finalTotalPrice: _orderStore.finalTotalPrice,
                      onNext: () {
                        Navigator.pushNamed(context, AppRoutes.reviewOrder);
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
