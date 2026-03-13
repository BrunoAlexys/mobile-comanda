import 'package:flutter/material.dart';

class AppIcons {
  AppIcons._();
  static const String send = 'assets/icons/send.png';
}

class AppColors {
  static const String redInitial = 'EF4444';
  static const String redFinal = 'DC2626';
  static const String primaryColor = "10224F";
  static const String secondaryColor = "0037C2";
  static const String grayColor = "9C9C9C";
  static const String greenAlert = '4BAA18';
  static const String yellowAlert = 'F3CD0F';
  static const String redAlert = 'FF5F5F';
  static const String burgundy = '7F1D1D';
  static const String grayColorSecondary = '717076';
}

class CategoryIcon {
  static const Map<String, IconData> categoryIconMap = {
    'Bebidas': Icons.local_drink,
    'Lanches': Icons.fastfood,
    'Porções': Icons.room_service,
    'Sobremesas': Icons.icecream,
    'Entradas': Icons.restaurant_menu,
    'Massas': Icons.ramen_dining,
    'Carnes': Icons.outdoor_grill,
    'Petiscos': Icons.fastfood,
  };

  static IconData getIconForCategory(String categoryName) {
    return categoryIconMap[categoryName] ?? Icons.category;
  }
}
