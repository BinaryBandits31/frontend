class StockItem {
  final String productName;
  final int quantity;
  final String? stockItemID;
  final String? productID;
  final String? batchID;
  final String? branchID;
  final String? expiryDate;

  StockItem({
    this.stockItemID,
    this.productID,
    this.batchID,
    this.branchID,
    this.expiryDate,
    required this.productName,
    required this.quantity,
  });

  factory StockItem.fromJson(dynamic json) => StockItem(
        productName: json['name'],
        stockItemID: json['Id'],
        productID: json['product_Id'],
        quantity: json['quantity'],
        expiryDate: json['expiry'],
        batchID: json['stockBatch_Id'],
        branchID: json['branch_Id'],
      );

  Map<String, dynamic> toJson() => {
        'name': productName,
        'stockBatch_Id': batchID,
        'branch_Id': branchID,
        'stockItem_Id': stockItemID,
        'product_Id': productID,
        'quantity': quantity,
        'expiry': expiryDate,
      };
}
