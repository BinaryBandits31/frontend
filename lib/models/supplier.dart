class Supplier {
  final String? id;
  final String name;
  final String email;
  final String phone;
  final String address;
  final String? dateCreated;

  Supplier({
    this.id,
    required this.address,
    required this.name,
    required this.email,
    required this.phone,
    this.dateCreated,
  });

  factory Supplier.fromJson(dynamic json) => Supplier(
        id: json['Id'],
        name: json['name'],
        email: json['email'],
        phone: json['phone'],
        address: json['address'],
        dateCreated: json['created_At'],
      );

  Map<String, dynamic> toJson() => {
        'Id': id,
        'name': name,
        'email': email,
        'phone': phone,
        'address': address,
      };
}
