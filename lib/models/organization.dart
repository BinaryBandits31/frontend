// ignore_for_file: non_constant_identifier_names

class Organization {
  final String name;
  final String id;
  final String email;
  final String phone;

  Organization({
    required this.phone,
    required this.name,
    required this.id,
    required this.email,
  });

  factory Organization.fromJson(dynamic json) => Organization(
      name: json['name'],
      id: json['org_Id'],
      email: json['email'],
      phone: json['phone']);
}
