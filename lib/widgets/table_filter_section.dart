import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile_comanda/store/tables_store.mobx.dart';
import 'package:mobile_comanda/widgets/filter_chip_button.dart';

class TableFilterSection extends StatelessWidget {
  final int adminId;
  final TablesStore _tablesStore = GetIt.I<TablesStore>();

  TableFilterSection({super.key, required this.adminId});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const LabelIcon(icon: Icons.filter_alt, label: 'Filtrar Mesas'),
          const SizedBox(height: 16),
          Observer(
            builder: (_) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterButton('Todas'),
                    const SizedBox(width: 8),
                    _buildFilterButton('Disponíveis'),
                    const SizedBox(width: 8),
                    _buildFilterButton('Ocupadas'),
                    const SizedBox(width: 8),
                    _buildFilterButton('Reservadas'),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String label) {
    String? buttonBackendValue = _getBackendFilter(label);
    bool isSelected = _tablesStore.currentFilter == buttonBackendValue;

    return FilterChipButton(
      label: label,
      isSelected: isSelected,
      onTap: () {
        _tablesStore.setFilter(adminId, buttonBackendValue);
      },
    );
  }

  String? _getBackendFilter(String label) {
    switch (label) {
      case 'Disponíveis':
        return 'AVAILABLE';
      case 'Ocupadas':
        return 'OCCUPIED';
      case 'Reservadas':
        return 'RESERVED';
      case 'Todas':
      default:
        return null;
    }
  }
}

class LabelIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  const LabelIcon({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey[600], size: 20),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
