class UserModel {
  String? uid;
  String email;
  String userType;

  UserModel({this.uid, required this.email, required this.userType});

  // Convert a User object into a map
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'userType': userType,
    };
  }

  // Create a User object from a map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      userType: map['userType'],
    );
  }
}
