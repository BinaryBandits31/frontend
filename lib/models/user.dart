class User {
  final String id;
  final String firstName;
  final String lastName;
  final String username;
  final String dob;
  final String empLevel;
  final String empType;
  final String branchId;
  final String orgId;
  final String token;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.dob,
    required this.empLevel,
    required this.empType,
    required this.branchId,
    required this.orgId,
    required this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['Id'],
        firstName: json['first_Name'],
        lastName: json['last_Name'],
        username: json['username'],
        dob: json['dob'],
        empLevel: json['emp_Level'],
        empType: json['emp_Type'],
        branchId: json['branch_Id'],
        orgId: json['org_ID'],
        token: json['token'],
      );
}
