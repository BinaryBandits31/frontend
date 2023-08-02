class StockItem {
  final String productName;
  final String id;
  final String batchID;
  final String branchID;
  final int quantity;
  final String expiryDate;

  StockItem({
    required this.productName,
    required this.id,
    required this.batchID,
    required this.quantity,
    required this.expiryDate,
    required this.branchID,
  });

  factory StockItem.fromJson(dynamic json) => StockItem(
        productName: json['name'],
        id: json['Id'],
        quantity: json['quantity'],
        expiryDate: json['expiry'],
        batchID: json['stockBatch_Id'],
        branchID: json['branch_Id'],
      );

  Map<String, dynamic> toJson() => {
        'name': productName,
        'stockBatch_Id': batchID,
        'branch_Id': branchID,
        'Id': id,
        'quantity': quantity,
        'expiry': expiryDate,
      };
}
