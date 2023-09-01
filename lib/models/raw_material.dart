class RawMaterial {
  final String name;
  final String? id;
  final String desc;
  final String package;
  final String baseUnit;
  final Map<String, dynamic> quantity;
  final double qtyPerPack;
  final double price;

  RawMaterial({
    required this.desc,
    required this.package,
    required this.baseUnit,
    required this.qtyPerPack,
    required this.quantity,
    required this.price,
    required this.name,
    required this.id,
  });

  factory RawMaterial.fromJson(dynamic json) => RawMaterial(
        name: json['name'],
        id: json['Id'],
        desc: json['desc'],
        quantity: json['quantity'],
        package: json['packType'],
        baseUnit: json['packUnit'],
        qtyPerPack: json['unitsPerPack'].toDouble(),
        price: json['pricePerPack'].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'Id': id,
        'desc': desc,
        'packType': package,
        'quantity': quantity,
        'packUnit': baseUnit,
        'unitsPerPack': qtyPerPack,
        'pricePerPack': price,
      };
}
