import 'package:flutter/foundation.dart';

class Product {
  final int id;
  final String name;
  final String description;
  final double price;
  final Category category;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
  });
}
