import 'package:mobile_comanda/model/category.dart';

class Menu {
  final int id;
  final String name;
  final String description;
  final double price;
  final Category category;

  Menu({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
  });

  factory Menu.fromJson(Map<String, dynamic> json) {
    return Menu(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: (json['price'] as num).toDouble(),
      category: Category.fromJson(json['category'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'category': category,
    };
  }
}
