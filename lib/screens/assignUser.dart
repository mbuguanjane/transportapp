import 'dart:convert';

import 'package:flutterdriverapp/model/loginuser.dart';
import 'package:flutterdriverapp/model/usermodel.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class AssignUser extends StatefulWidget {
  var data;
  AssignUser({this.data, super.key});

  @override
  State<AssignUser> createState() => _AssignUserState();
}

class _AssignUserState extends State<AssignUser> {
  final List<UserModel> _userList = <UserModel>[];

  Future<List<UserModel>?> getUsers() async {
    var url = Uri.https('driverapi.sokoyoyacomrade.com', '/api/users');
    var response = await http.get(url, headers: {
      //'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + loginUser!.token,
    }
        // body: {'email': 'mbuguanjane@gmail.com', 'password': '12345678'}
        );

    if (response.statusCode == 200) {
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      //userList = json.decode(response.body);
      var parsed = json.decode(response.body);
      // print(parsed);

      List<UserModel> userList = <UserModel>[];
      for (var item in parsed) {
        // print(item['Firstname']);
        if (item['UserType'] == "User") {
          userList.add(UserModel.fromJson(item));
        }
      }
      print(userList.length);
      print("--------------------");
      return userList;
    } else {
      print("Failed to Send");
    }
  }

  AssignUser(context, userid) async {
     showDialog(
                            context: context,
                            builder: (context) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            });
                            // Navigator.of(context).pop();
    var url = Uri.https('driverapi.sokoyoyacomrade.com',
        '/api/Duties/' + widget.data.toString());
    var response = await http.put(url, headers: {
      // 'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + loginUser!.token,
    }, body: {
      "Userid": userid.toString(),
    });

    print('Response status: ${response.statusCode}');
    print("--------------------------------------------");
    print('Response body: ${response.body}');
    if (response.statusCode == 201) {
      Navigator.of(context).pop();
      print("Updated successfully");
      Fluttertoast.showToast(
          msg: "User Assigned" + userid.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM, // Also possible "TOP" and "CENTER"
          backgroundColor: Colors.grey,
          textColor: Colors.white);
    } else {
      Navigator.of(context).pop();
      print("Failed to Send");
      Fluttertoast.showToast(
          msg: "User Assigned" + userid.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM, // Also possible "TOP" and "CENTER"
          backgroundColor: Colors.grey,
          textColor: Colors.white);
    }
  }

  @override
  void initState() {
    getUsers().then((value) => {
          setState(() {
            _userList.addAll(value!);
          })
        });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Assign User"),
        backgroundColor: Colors.blue,
      ),
      body: ListView.separated(
          itemBuilder: (context, index) {
            return ListTile(
              onTap: () {
                AssignUser(context, _userList[index].id);
                print("whatsapp");
                print(_userList[index].id);
              },
              title: Text(_userList[index].name),
              leading: Text(_userList[index].UserType),
              subtitle: Text(_userList[index].email),
            );
          },
          separatorBuilder: (context, index) => Divider(
                color: Colors.blue,
              ),
          itemCount: _userList.length),
    );
  }
}
