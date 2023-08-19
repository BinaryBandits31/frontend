class StockItem {
  final String productName;
  final String stockItemID;
  final String productID;
  final String batchID;
  final String branchID;
  final int quantity;
  final String expiryDate;

  StockItem({
    required this.productName,
    required this.stockItemID,
    required this.productID,
    required this.batchID,
    required this.quantity,
    required this.expiryDate,
    required this.branchID,
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
