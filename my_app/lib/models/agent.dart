class AgentModel {
  String name;
  String? uid;
  String email;
  String userType;

  AgentModel({required this.name, this.uid, required this.email, required this.userType});

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
  factory AgentModel.fromMap(Map<String, dynamic> map) {
    return AgentModel(
      name: map['name'],
      uid: map['uid'],
      email: map['email'],
      userType: map['userType'],
    );
  }
}
