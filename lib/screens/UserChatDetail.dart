import 'dart:convert';

import 'package:flutterdriverapp/model/ChatMessage.dart';
import 'package:flutterdriverapp/model/loginuser.dart';
import 'package:flutterdriverapp/model/usermodel.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class UserChatDetail extends StatefulWidget {
  UserModel userReceiver;
  UserChatDetail({super.key, required this.userReceiver});

  @override
  State<UserChatDetail> createState() => _UserChatDetailState();
}

class _UserChatDetailState extends State<UserChatDetail> {
  TextEditingController messageController = TextEditingController();
  bool messageempty = false;
  final List<ChatMessage> _chatList = <ChatMessage>[];

  Future<List<ChatMessage>?> getChats() async {
    var url = Uri.https('driverapi.sokoyoyacomrade.com', '/api/chats');
    var response = await http.get(url, headers: {
      //'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + loginUser!.token,
    }
        // body: {'email': 'mbuguanjane@gmail.com', 'password': '12345678'}
        );
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      //userList = json.decode(response.body);
      var parsed = json.decode(response.body);
      // print(parsed);

      List<ChatMessage> chatList = <ChatMessage>[];
      for (var item in parsed) {
        // print(item['Firstname']);

        if (item["receiverID"] == widget.userReceiver.id &&
            item["senderID"] == loginUser!.userid) {
          chatList.add(new ChatMessage(
              id: item['id'],
              messageContent: item['messageContent'],
              messageType: "sender",
              senderID: item['senderID'],
              receiverID: item['receiverID'],
              CheckDate: item['CheckDate'],
              created_at: item['created_at']));
        }
        if (item["receiverID"] == loginUser!.userid &&
            item["senderID"] == widget.userReceiver.id) {
          chatList.add(new ChatMessage(
              id: item['id'],
              messageContent: item['messageContent'],
              messageType: "receiver",
              senderID: item['senderID'],
              receiverID: item['receiverID'],
              CheckDate: item['CheckDate'],
              created_at: item['created_at']));
        }
      }
      print(chatList.length);
      print("--------------------");
      return chatList;
    } else {
      print("Failed to Send");
    }
  }

  createChat(context) async {
    if (messageController.text.isNotEmpty) {
      setState(() {
        if (messageController.text.isEmpty) {
          messageempty = true;
        } else {
          messageempty = false;
        }
      });
      var now = DateTime.now();
      var formatterDate = DateFormat('yyyy-MM-dd');
      var formatterTime = DateFormat('kk:mm');
      String actualDate = formatterDate.format(now);
      String actualTime = formatterTime.format(now);
      print(actualTime);
      print(actualDate);
      showDialog(
                            context: context,
                            builder: (context) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            });
                            // Navigator.of(context).pop();
      var url = Uri.https('driverapi.sokoyoyacomrade.com', '/api/chats');
      var response = await http.post(url, headers: {
        // 'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + loginUser!.token,
      }, body: {
        "messageContent": messageController.text,
        "senderID": loginUser!.userid.toString(),
        "receiverID": widget.userReceiver.id.toString(),
        "CheckDate": actualDate,
      });

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      if (response.statusCode == 201) {
         _chatList.clear();
                      setState(() {
                        getChats().then((value) => {
                              setState(() {
                                _chatList.addAll(value!);
                              })
                            });
                      });
        Navigator.of(context).pop();
        messageController.text = "";
        Fluttertoast.showToast(
            msg: "sent successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM, // Also possible "TOP" and "CENTER"
            backgroundColor: Colors.grey,
            textColor: Colors.white);
      } else {
        Navigator.of(context).pop();
        Fluttertoast.showToast(
            msg: "Failed to sent",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM, // Also possible "TOP" and "CENTER"
            backgroundColor: Colors.grey,
            textColor: Colors.white);
        print("Failed to Send");
      }
    } else {
      setState(() {
        if (messageController.text.isEmpty) {
          messageempty = true;
        } else {
          messageempty = false;
        }
      });
    }
  }

  @override
  void initState() {
    getChats().then((value) => {
          setState(() {
            _chatList.addAll(value!);
          })
        });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.grey,
        flexibleSpace: SafeArea(
          child: Container(
            padding: EdgeInsets.only(right: 16),
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  width: 2,
                ),
                CircleAvatar(
                  backgroundImage: NetworkImage(
                      "https://randomuser.me/api/portraits/men/" +
                          widget.userReceiver.id.toString() +
                          ".jpg"),
                  maxRadius: 20,
                ),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        widget.userReceiver.name,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        "Online",
                        style: TextStyle(color: Colors.white, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.settings,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          ListView.builder(
            itemCount: _chatList.length,
            //shrinkWrap: true,
            padding: EdgeInsets.only(top: 10, bottom: 80),
            //physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              // ................................................................
              return Container(
                padding:
                    EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
                child: Align(
                  alignment: (_chatList[index].messageType == "receiver"
                      ? Alignment.topLeft
                      : Alignment.topRight),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: (_chatList[index].messageType == "receiver"
                          ? Colors.grey.shade200
                          : Colors.blue[200]),
                    ),
                    padding: EdgeInsets.all(16),
                    child: Text(
                      _chatList[index].messageContent,
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ),
              );
//.................................................................
            },
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
              height: 60,
              width: double.infinity,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          if(value.isNotEmpty)
                          {
                            messageempty=false;
                          }
                        });
                      },
                      controller: messageController,
                      decoration: InputDecoration(
                        errorText: messageempty?"please write a message":null,
                          hintText: "Write message...",
                          hintStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  FloatingActionButton(
                    onPressed: () {
                      createChat(context);
                     
                    },
                    child: Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 18,
                    ),
                    backgroundColor: Colors.grey,
                    elevation: 0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
