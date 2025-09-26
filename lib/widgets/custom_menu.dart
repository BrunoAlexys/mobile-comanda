import 'package:flutter/material.dart';
import 'package:mobile_comanda/util/utils.dart';

class CustomMenu extends StatefulWidget {
  const CustomMenu({super.key});

  @override
  State<CustomMenu> createState() => _CustomMenuState();
}

class _CustomMenuState extends State<CustomMenu> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color activeColor = Utils.hexToColor('7F1D1D');
    final Color inactiveColor = Colors.grey.shade600;

    return Container(
      width: double.infinity,
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildMenuItem(
            icon: Icons.home_rounded,
            text: 'Início',
            index: 0,
            color: _selectedIndex == 0 ? activeColor : inactiveColor,
          ),
          _buildMenuItem(
            icon: Icons.shopping_bag_rounded,
            text: 'Pedidos',
            index: 1,
            color: _selectedIndex == 1 ? activeColor : inactiveColor,
          ),
          _buildMenuItem(
            icon: Icons.person,
            text: 'Perfil',
            index: 2,
            color: _selectedIndex == 2 ? activeColor : inactiveColor,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String text,
    required int index,
    required Color color,
  }) {
    return IconButton(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onPressed: () => _onItemTapped(index),
      icon: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 4),
          Text(text, style: TextStyle(color: color, fontSize: 12)),
        ],
      ),
    );
  }
}
