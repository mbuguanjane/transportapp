import 'package:flutterdriverapp/model/ChatMessage.dart';
import 'package:flutterdriverapp/model/loginuser.dart';
import 'package:flutterdriverapp/model/usermodel.dart';
import 'package:flutterdriverapp/screens/chatDetail.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'dart:io';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:excel/excel.dart';
import 'package:fast_csv/fast_csv.dart' as _fast_csv;
import 'package:file_picker/file_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class ChatScreen extends StatefulWidget {
  ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  updateChat(receiverid) async {
    //updateChat
    var url = Uri.https('driverapi.sokoyoyacomrade.com',
        '/api/updateChat/' + receiverid.toString());
    var response = await http.get(url, headers: {
      //'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + loginUser!.token,
    }
        // body: {'email': 'mbuguanjane@gmail.com', 'password': '12345678'}
        );
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  }

  final List<ChatMessage> _chatList = <ChatMessage>[];

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
        if (loginUser!.userid != item['id']) {
          userList.add(new UserModel(
            id: item['id'],
            name: item['name'],
            email: item['email'],
            UserType: item['UserType'],
            messageStatus: item['messageStatus'],
          ));
        }
      }
      print(userList.length);
      print("--------------------");
      return userList;
    } else {
      print("Failed to Send");
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
        title: Text(
          "Users",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: ListView.separated(
          itemBuilder: (context, index) {
            return ListTile(
              onTap: _userList[index].id != loginUser!.userid
                  ? () {
                      updateChat(_userList[index].id);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChatDetail(
                                    userReceiver: _userList[index],
                                  )));
                    }
                  : null,
              leading: CircleAvatar(
                backgroundImage: NetworkImage(
                    "https://randomuser.me/api/portraits/men/" +
                        _userList[index].id.toString() +
                        ".jpg"),
                maxRadius: 20,
              ),
              title: Text(_userList[index].name),
              subtitle: Text("Hello"),
              trailing: _userList[index].messageStatus == "unseen"
                  ? Column(
                      children: [
                        Text("New message"),
                        Icon(
                          Icons.message_rounded,
                          color: Colors.blue,
                        )
                      ],
                    )
                  : null,
            );
          },
          separatorBuilder: (context, index) => Divider(color: Colors.blue),
          itemCount: _userList.length),
    );
  }
}
