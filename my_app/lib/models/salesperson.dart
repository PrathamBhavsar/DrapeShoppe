class SalespersonModel {
  String name;
  String? uid;
  String email;
  String userType;

  SalespersonModel({required this.name, this.uid, required this.email, required this.userType});

  // Convert a User object into a map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'uid': uid,
      'email': email,
      'userType': userType,
    };
  }

  // Create a User object from a map
  factory SalespersonModel.fromMap(Map<String, dynamic> map) {
    return SalespersonModel(
      name: map['name'],
      uid: map['uid'],
      email: map['email'],
      userType: map['userType'],
    );
  }
}
