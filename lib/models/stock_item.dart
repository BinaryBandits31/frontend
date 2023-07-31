class StockItem {
  final String productName;
  final String id;
  final String batchID;
  final int quantity;
  final String expiryDate;

  StockItem({
    required this.productName,
    required this.id,
    required this.batchID,
    required this.quantity,
    required this.expiryDate,
  });

  factory StockItem.fromJson(dynamic json) => StockItem(
        productName: json['name'],
        id: json['Id'],
        quantity: json['quantity'],
        expiryDate: json['expiry'],
        batchID: json['stockBatch_Id'],
      );

  Map<String, dynamic> toJson() => {
        'name': productName,
        'stockBatch_Id': batchID,
        'Id': id,
        'quantity': quantity,
        'expiry': expiryDate,
      };
}
