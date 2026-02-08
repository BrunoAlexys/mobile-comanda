import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile_comanda/core/app_routes.dart';
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
  int adminId = 0;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _getTables();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  Future<int> getAdminId() async {
    final adminIdStr = await _userStore.getAdminId();
    return int.tryParse(adminIdStr) ?? 0;
  }

  void _getTables() async {
    adminId = await getAdminId();
    await _tablesStore.loadTables(adminId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      // Usando CustomScrollView para performance superior com Slivers
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildStatusRow(),
                const SizedBox(height: 24),
                TableFilterSection(adminId: adminId),
                const SizedBox(height: 24),
                _buildSearchInput(),
                const SizedBox(height: 24),
              ]),
            ),
          ),
          _buildGridSection(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return CustomAppBar(
      title: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: Column(
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
    return Observer(
      builder: (_) {
        var statusCount = _tablesStore.allTables.fold(
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

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            StatusCard(
              title: 'Disponíveis',
              value: statusCount[StatusTable.available.name] ?? 0,
              icon: Icons.check,
              color: Colors.green,
            ),
            StatusCard(
              title: 'Ocupadas',
              value: statusCount[StatusTable.occupied.name] ?? 0,
              icon: Icons.people_alt,
              color: Colors.blueAccent,
            ),
            StatusCard(
              title: 'Reservadas',
              value: statusCount[StatusTable.reserved.name] ?? 0,
              icon: Icons.access_time_filled,
              color: Colors.orange,
            ),
          ],
        );
      },
    );
  }

  Widget _buildSearchInput() {
    return CustomInput(
      hintText: 'Buscar mesa...',
      borderRadius: 16.0,
      fillColor: Colors.white,
      borderColor: const Color(0xFFE2E8F0),
      prefixIcon: const Icon(Icons.search, color: Color(0xFF94A3B8), size: 28),
      onChanged: (value) {
        if (_debounce?.isActive ?? false) _debounce!.cancel();
        _debounce = Timer(const Duration(milliseconds: 300), () {
          _tablesStore.setSearchQuery(value);
        });
      },
    );
  }

  Widget _buildGridSection() {
    return Observer(
      builder: (_) {
        if (_tablesStore.isLoadingTables) {
          return const SliverFillRemaining(
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final tables = _tablesStore.filteredTables;

        if (tables.isEmpty) {
          return SliverFillRemaining(
            hasScrollBody: false,
            child: _buildEmptyState(),
          );
        }

        return SliverPadding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              mainAxisExtent: 200,
            ),
            delegate: SliverChildBuilderDelegate((context, index) {
              final table = tables[index];
              return CardTable(
                key: ValueKey(table.id),
                tableNumber: table.numberTable.toString(),
                chairsAvailable: table.chairsAvailable,
                status: table.status,
              );
            }, childCount: tables.length),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 40),
        Icon(
          Icons.table_restaurant_outlined,
          size: 64,
          color: Colors.grey[400],
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
        Text(
          'Não há mesas para os filtros aplicados.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, color: Colors.grey[500]),
        ),
      ],
    );
  }
}
