import 'package:flutter/material.dart';
import 'package:mobile_comanda/core/locator.dart';
import 'package:mobile_comanda/store/user_store.mobx.dart';
import 'package:mobile_comanda/util/constants.dart';
import 'package:mobile_comanda/util/utils.dart';
import 'package:mobile_comanda/widgets/custom_appbar.dart';
import 'package:mobile_comanda/widgets/custom_button.dart';
import 'package:mobile_comanda/widgets/custom_menu.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _userStore = locator<UserStore>();

    return Scaffold(
      appBar: CustomAppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Comanda Online',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        backgroundColorGradient: [
          Utils.hexToColor(AppColors.primaryColor),
          Utils.hexToColor(AppColors.secondaryColor),
        ],
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
        automaticallyImplyLeading: false,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 36),
          _NewOrderCard(),
          _PendingOrdersCard(pendingOrders: []),
        ],
      ),
      bottomNavigationBar: CustomMenu(),
    );
  }
}

class _NewOrderCard extends StatelessWidget {
  const _NewOrderCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print('Fazer Novo Pedido Clicado!');
      },
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          gradient: LinearGradient(
            colors: [
              Utils.hexToColor(AppColors.primaryColor),
              Utils.hexToColor(AppColors.secondaryColor),
            ],
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.add_rounded,
                    color: Utils.hexToColor(AppColors.primaryColor),
                    size: 40,
                  ),
                ),
                SizedBox(height: 14),
                Text(
                  'Fazer Novo Pedido',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Explore o menu para realizar um novo pedido',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
                SizedBox(height: 8),
              ],
            ),
            Icon(Icons.arrow_forward, color: Colors.white),
          ],
        ),
      ),
    );
  }
}

class _PendingOrdersCard extends StatelessWidget {
  final List<int> pendingOrders;
  const _PendingOrdersCard({Key? key, required this.pendingOrders})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print('Pedidos Pendentes Clicado!');
      },
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: Utils.hexToColor(AppColors.primaryColor),
            width: 1.0,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Utils.hexToColor('FFD1D1').withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Icon(
                        Icons.access_time_filled_rounded,
                        color: Utils.hexToColor('7F1D1D'),
                        size: 40,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Pedidos Pendentes',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Acompanhe os pedidos que estão aguardando à retirada.',
                    style: TextStyle(color: Colors.black, fontSize: 14),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Utils.hexToColor(AppColors.primaryColor),
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  '${pendingOrders.length}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
