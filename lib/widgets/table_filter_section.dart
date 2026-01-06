import 'package:flutter/material.dart';
import 'package:mobile_comanda/widgets/filter_chip_button.dart';

class TableFilterSection extends StatefulWidget {
  const TableFilterSection({super.key});

  @override
  State<TableFilterSection> createState() => _TableFilterSectionState();
}

class _TableFilterSectionState extends State<TableFilterSection> {
  String selectedFilter = 'Todas';

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
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterButton('Todas'),
                _buildFilterButton('Disponíveis'),
                _buildFilterButton('Ocupadas'),
                _buildFilterButton('Reservadas'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String label) {
    return FilterChipButton(
      label: label,
      isSelected: selectedFilter == label,
      onTap: () {
        setState(() {
          selectedFilter = label;
        });
      },
    );
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
