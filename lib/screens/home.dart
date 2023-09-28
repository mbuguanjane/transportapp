import 'package:flutterdriverapp/model/loginuser.dart';
import 'package:flutterdriverapp/screens/chats.dart';
import 'package:flutterdriverapp/screens/login.dart';
import 'package:flutterdriverapp/screens/task.dart';
import 'package:flutterdriverapp/screens/user.dart';
import 'package:flutterdriverapp/screens/userlogs.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  Future LogutMethod(context) async {
    showDialog(
                            context: context,
                            builder: (context) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            });
                            // Navigator.of(context).pop();
    var url = Uri.https('driverapi.sokoyoyacomrade.com', '/api/logout');
    var response = await http.post(url, headers: {
      // 'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + loginUser!.token,
    });

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    if (response.statusCode == 200) {
      Navigator.of(context).pop();
      Fluttertoast.showToast(
          msg: "Loggout successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
    }else{
      Navigator.of(context).pop();
      Fluttertoast.showToast(
          msg: "Loggout Failed",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Management Dashboard",
            style: TextStyle(color: Colors.white),
          ),
          //backgroundColor: Colors.blue,
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              UserAccountsDrawerHeader(
                  accountName: Row(
                    children: <Widget>[
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(shape: BoxShape.circle),
                        child: CircleAvatar(
                          backgroundColor: Colors.redAccent,
                          child: Icon(
                            Icons.check,
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(loginUser!.UserType),
                          Text(loginUser!.userModel.name),
                        ],
                      ),
                    ],
                  ),
                  accountEmail: Text(loginUser!.userModel.email)),
              Column(
                children: [
                  ListTile(
                    onTap: () {
                      LogutMethod(context);
                    },
                    title: Text("Log out"),
                    trailing: Icon(Icons.logout),
                  )
                ],
              )
            ],
          ),
        ),
        body: Center(
            child: Container(
          width: double.infinity,
          //color: Colors.blue,
          alignment: Alignment.center,
          height: double.infinity,
          child: GridView.count(
            primary: false,
            padding: const EdgeInsets.all(20),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            crossAxisCount: 2,
            children: <Widget>[
              InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => UserScreen()));
                },
                child: GridTile(
                    child: new Card(
                        elevation: 5,
                        color: Colors.blue,
                        child: Center(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                              Icon(
                                Icons.person,
                                color: Colors.white,
                              ),
                              Text(
                                'Manage Users',
                                style: TextStyle(color: Colors.white),
                              )
                            ])))),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ChatScreen()));
                },
                child: GridTile(
                    child: new Card(
                        elevation: 5,
                        color: Colors.blue,
                        child: Center(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                              Icon(
                                Icons.chat,
                                color: Colors.white,
                              ),
                              Text(
                                'Chats',
                                style: TextStyle(color: Colors.white),
                              )
                            ])))),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => TaskScreen()));
                },
                child: GridTile(
                    child: new Card(
                        elevation: 5,
                        color: Colors.blue,
                        child: Center(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                              Icon(
                                Icons.task,
                                color: Colors.white,
                              ),
                              Text(
                                'Manage Tasks',
                                style: TextStyle(color: Colors.white),
                              )
                            ])))),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => UserLogs()));
                },
                child: GridTile(
                    child: new Card(
                        elevation: 5,
                        color: Colors.blue,
                        child: Center(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                              Icon(
                                Icons.present_to_all,
                                color: Colors.white,
                              ),
                              Text(
                                'Manage UserLogs',
                                style: TextStyle(color: Colors.white),
                              )
                            ])))),
              ),
            ],
          ),
        )));
  }
}
