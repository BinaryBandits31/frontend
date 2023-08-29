// ignore_for_file: non_constant_identifier_names

class Organization {
  final String name;
  final String id;
  final String email;
  final String phone;
  final bool isManufacturer;
  final bool isRetailer;

  Organization({
    required this.phone,
    required this.name,
    required this.id,
    required this.email,
    required this.isManufacturer,
    required this.isRetailer,
  });

  factory Organization.fromJson(dynamic json) => Organization(
      name: json['name'],
      id: json['org_Id'],
      email: json['email'],
      phone: json['phone'],
      isRetailer: json['is_Retailer'],
      isManufacturer: json['is_Manufacturer']);
}
