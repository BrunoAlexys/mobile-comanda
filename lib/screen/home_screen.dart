import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile_comanda/enum/status_table.dart';
import 'package:mobile_comanda/store/tables_store.mobx.dart';
import 'package:mobile_comanda/store/user_store.mobx.dart';
import 'package:mobile_comanda/util/constants.dart';
import 'package:mobile_comanda/util/utils.dart';
import 'package:mobile_comanda/widgets/card_table.dart';
import 'package:mobile_comanda/widgets/custom_appbar.dart';
import 'package:mobile_comanda/widgets/custom_input.dart';
import 'package:mobile_comanda/widgets/status_card.dart';
import 'package:mobile_comanda/widgets/table_filter_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TablesStore _tablesStore = GetIt.I<TablesStore>();
  final UserStore _userStore = GetIt.I<UserStore>();

  @override
  void initState() {
    super.initState();
    _getTables();
  }

  void _getTables() async {
    final adminId = await _userStore.getAdminId();
    final adminIdParsed = int.tryParse(adminId);
    if (adminIdParsed != null) {
      await _tablesStore.loadTables(adminIdParsed);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      body: Observer(
        builder: (_) {
          if (_tablesStore.isLoadingTables) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatusRow(),
                const SizedBox(height: 24),
                const TableFilterSection(),
                const SizedBox(height: 24),
                _buildSearchInput(),
                Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: _tablesStore.tablesList.isEmpty
                      ? _buildEmptyState()
                      : GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                mainAxisExtent: 200,
                              ),
                          itemCount: _tablesStore.tablesList.length,
                          itemBuilder: (context, index) {
                            final table = _tablesStore.tablesList[index];
                            return CardTable(
                              tableNumber: table.numberTable.toString(),
                              chairsAvailable: table.chairsAvailable,
                              status: table.status,
                            );
                          },
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return CustomAppBar(
      title: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Comandas',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Gerenciamento de Mesas',
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
      backgroundColorGradient: [
        Utils.hexToColor(AppColors.secondaryColor),
        Utils.hexToColor(AppColors.primaryColor),
      ],
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.menu, color: Colors.white, size: 28),
        ),
      ],
      automaticallyImplyLeading: false,
    );
  }

  Widget _buildStatusRow() {
    var statusCount = _tablesStore.tablesList.fold(
      <String, int>{
        StatusTable.available.name: 0,
        StatusTable.occupied.name: 0,
        StatusTable.reserved.name: 0,
      },
      (acumulator, table) {
        final statusName = table.status.name;
        acumulator[statusName] = (acumulator[statusName] ?? 0) + 1;
        return acumulator;
      },
    );

    final valueAvailable = statusCount[StatusTable.available.name] ?? 0;
    final valueOccupied = statusCount[StatusTable.occupied.name] ?? 0;
    final valueReserved = statusCount[StatusTable.reserved.name] ?? 0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        StatusCard(
          title: 'Disponíveis',
          value: valueAvailable,
          icon: Icons.check,
          color: Colors.green,
        ),
        StatusCard(
          title: 'Ocupadas',
          value: valueOccupied,
          icon: Icons.people_alt,
          color: Colors.blueAccent,
        ),
        StatusCard(
          title: 'Reservadas',
          value: valueReserved,
          icon: Icons.access_time_filled,
          color: Colors.orange,
        ),
      ],
    );
  }

  Widget _buildSearchInput() {
    return CustomInput(
      hintText: 'Buscar mesa...',
      borderRadius: 16.0,
      fillColor: Colors.white,
      borderColor: const Color(0xFFE2E8F0),
      cursorColor: Colors.blueGrey,
      prefixIcon: const Icon(Icons.search, color: Color(0xFF94A3B8), size: 28),
      hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 18),
      contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      onChanged: (value) {},
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.table_restaurant_outlined,
                size: 64,
                color: Colors.grey[400],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Nenhuma mesa encontrada',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Não há mesas cadastradas ou\nos filtros não retornaram resultados.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
