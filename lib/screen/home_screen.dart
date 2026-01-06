import 'package:flutter/material.dart';
import 'package:mobile_comanda/util/constants.dart';
import 'package:mobile_comanda/util/utils.dart';
import 'package:mobile_comanda/widgets/card_table.dart';
import 'package:mobile_comanda/widgets/custom_appbar.dart';
import 'package:mobile_comanda/widgets/custom_input.dart';
import 'package:mobile_comanda/widgets/status_card.dart';
import 'package:mobile_comanda/widgets/table_filter_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
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
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  mainAxisExtent: 200,
                ),
                itemCount: 10,
                itemBuilder: (context, index) {
                  return const CardTable();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return CustomAppBar(
      title: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text(
              'Comanda Online',
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
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        StatusCard(
          title: 'Disponíveis',
          value: 8,
          icon: Icons.check,
          color: Colors.green,
        ),
        StatusCard(
          title: 'Ocupadas',
          value: 12,
          icon: Icons.people_alt,
          color: Colors.blueAccent,
        ),
        StatusCard(
          title: 'Reservadas',
          value: 3,
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
}
