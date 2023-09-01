import 'dart:convert';

class Product {
  final String name;
  final String description;
  final double price;
  final Map<String, int>? constituents;
  final String? id;

  Product({
    required this.name,
    required this.description,
    required this.price,
    this.constituents,
    this.id,
  });

  factory Product.fromJson(dynamic json) => Product(
        name: json['name'],
        description: json['desc'],
        price: json['price'].toDouble(),
        constituents: json['constituents'],
        id: json['product_Id'],
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'desc': description,
        'price': price,
        'constituents': constituents,
        'product_Id': id,
      };
}
