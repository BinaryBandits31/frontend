class Product {
  final String name;
  final String description;
  final double price;
  final int quantity;
  final String? id;

  Product({
    required this.name,
    required this.description,
    required this.price,
    required this.quantity,
    this.id,
  });

  factory Product.fromJson(dynamic json) => Product(
        name: json['name'],
        description: json['desc'],
        price: json['price'].toDouble(),
        quantity: json['quantity'],
        id: json['product_Id'],
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'desc': description,
        'price': price,
        'quantity': quantity,
      };
}
