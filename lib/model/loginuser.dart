import 'package:transportapp/model/usermodel.dart';

class LoginUser {
  final int userid;
  final String token;
  final String UserType;
  final UserModel userModel;



  const LoginUser(
      {required this.userid,
      required this.token,
      required this.UserType,
      required this.userModel});

  factory LoginUser.fromJson(Map<dynamic, dynamic> json) {
    return LoginUser(
      userid: json['user']['id'],
      token: json['token'],
      UserType: json['user']['UserType'],
      userModel: UserModel.fromJson(json['user']),
      // userModel: new UserModel(
      //     name: json['user']['name'], email: json['user']['email']),
    );
  }
}

LoginUser? loginUser;
