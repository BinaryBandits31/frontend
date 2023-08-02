class User {
  final String id;
  final String? firstName;
  final String? lastName;
  final String username;
  final String? dob;
  final String? empLevel;
  final String empType;
  final String branchId;
  final String orgId;
  final bool? isActive;
  final String? token;

  User({
    required this.id,
    this.firstName,
    this.lastName,
    required this.username,
    this.dob,
    required this.empLevel,
    required this.empType,
    required this.branchId,
    required this.orgId,
    this.token,
    this.isActive,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['employee_Id'],
        firstName: json['first_Name'],
        lastName: json['last_Name'],
        username: json['username'],
        dob: json['dob'],
        empLevel: json['emp_Level'],
        empType: json['emp_Type'],
        branchId: json['branch_Id'],
        orgId: json['org_Id'],
        isActive: json['is_Active'],
        token: json['token'],
      );

  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'first_Name': firstName,
      'last_Name': lastName,
      'username': username,
      'dob': dob,
      'emp_Level': empLevel,
      'emp_Type': empType,
      'branch_Id': branchId,
      'org_Id': orgId,
      'is_Active': isActive,
      'token': token,
    };
  }
}
