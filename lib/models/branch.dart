class Branch {
  final String name;
  final String branchID;
  final String type;

  Branch({
    required this.name,
    required this.branchID,
    required this.type,
  });

  factory Branch.fromJson(dynamic json) => Branch(
      name: json['name'],
      branchID: json['branch_Id'],
      type: json['branch_Type']);

  Map<String, dynamic> toJson() => {
        'name': name,
        'branch_Id': branchID,
        'branch_Type': type,
      };
}
