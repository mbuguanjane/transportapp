class UserModel {
  final int id;
  final String name;
  final String email;
  final String UserType;
  final String messageStatus;
  UserModel(
      {required this.id,
      required this.name,
      required this.email,
      required this.UserType,
      required this.messageStatus});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      UserType: json['UserType'],
      messageStatus: json['messageStatus'],
    );
  }
}
