class Supplier {
  final String name;
  final String email;
  final String phone;
  final String address;
  final String? dateCreated;

  Supplier({
    required this.address,
    required this.name,
    required this.email,
    required this.phone,
    this.dateCreated,
  });

  factory Supplier.fromJson(dynamic json) => Supplier(
        name: json['name'],
        email: json['email'],
        phone: json['phone'],
        address: json['address'],
        dateCreated: json['created_At'],
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'phone': phone,
        'address': address,
      };
}
