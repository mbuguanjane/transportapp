import 'package:csv/csv.dart';
import 'package:flutterdriverapp/model/loginuser.dart';
import 'package:flutterdriverapp/model/usermodel.dart';
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

class UserScreen extends StatefulWidget {
  UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  var valueChoose;
  List listItem = ["Admin", "User"];
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
        userList.add(UserModel.fromJson(item));
      }
      print(userList.length);
      print("--------------------");
      return userList;
    } else {
      print("Failed to Send");
    }
  }

  Future<String> loadAsset(String path) async {
    return await rootBundle.loadString(path);
  }

  var userlist = [];
  Future<String?> getPdfAndUpload() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      PlatformFile file = result.files.first;

      print(file.name);
      print(file.bytes);
      print(file.size);
      print(file.extension);
      print(file.path);
      return file.path;
    } else {
      // User canceled the picker
      print("Fail file upload");
      return null;
    }
  }

  Future<void> loadCSV() async {
    loadAsset('assets/importexcel.csv').then((dynamic output) {
      final res = _fast_csv.parse(output);
      userlist = res;

      for (var item in res) {
        print(item[0]);
      }
    });
  }

  String? filePath;
  void _pickleFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result == null) return;
    print(result.files.first.path);
    filePath = result.files.first.path!;
    final input = File(filePath!).openRead();
    final fields = await input
        .transform(utf8.decoder)
        .transform(const CsvToListConverter())
        .toList();
    print(fields);

    for (var element in fields.skip(1)) {
      print(element);
    }
  }

  readExcel() async {
    ByteData data = await rootBundle.load('assets/importexcel.xlsx');
    var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    var excel = Excel.decodeBytes(bytes);
    List<String> rowdetail = [];
    for (var table in excel.tables.keys) {
      for (var row in excel.tables[table]!.rows) {
        print("wao start here");
        print(row.length);
        row.forEach((element) {
          print(element!.value);
          rowdetail.add(element.value);
        });
        print("wao start here");
        print(rowdetail);
      }
    }
  }

  showDataAlert(context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(
                  20.0,
                ),
              ),
            ),
            contentPadding: EdgeInsets.only(
              top: 10.0,
            ),
            title: Text(
              "Create User",
              style: TextStyle(fontSize: 24.0),
            ),
            content: Container(
              height: 400,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Name",
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: namecontroller,
                        decoration: InputDecoration(
                            errorText: namempty ? "Name Required" : null,
                            border: OutlineInputBorder(),
                            hintText: 'Enter Name',
                            labelText: 'Name'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "User Type",
                      ),
                    ),
                    DropdownButton(
                        hint: Text("Select Task Status"),
                        value: valueChoose,
                        items: listItem
                            .map((valueItem) => DropdownMenuItem(
                                value: valueItem, child: Text(valueItem)))
                            .toList(),
                        onChanged: (newValue) {
                          setState(() {
                            valueChoose = newValue.toString();
                          });
                          print("-------------");
                          setState(() {
                            valueChoose;
                          });
                          print(valueChoose);
                        }),

                    // Email Here
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Email",
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: emailcontroller,
                        decoration: InputDecoration(
                            errorText: emailempty ? "Email required" : null,
                            border: OutlineInputBorder(),
                            hintText: 'Enter Email',
                            labelText: 'Email'),
                      ),
                    ),
                    // Password
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Password",
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: passwordcontroller,
                        obscureText: true,
                        decoration: InputDecoration(
                            errorText: passwordempty ? "Password" : null,
                            border: OutlineInputBorder(),
                            hintText: 'Enter Password',
                            labelText: 'Password'),
                      ),
                    ),

                    Container(
                      width: double.infinity,
                      height: 60,
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          _userList.clear();
                          createUser(context);
                          getUsers().then((value) => {
                                setState(() {
                                  _userList.addAll(value!);
                                })
                              });
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blue,
                          // fixedSize: Size(250, 50),
                        ),
                        child: Text(
                          "Create",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
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

  bool emailempty = false, passwordempty = false, namempty = false;
  TextEditingController namecontroller = new TextEditingController();
  TextEditingController emailcontroller = new TextEditingController();
  TextEditingController passwordcontroller = new TextEditingController();
  Future createUser(context) async {
    if (emailcontroller.text.isNotEmpty &&
        passwordcontroller.text.isNotEmpty &&
        namecontroller.text.isNotEmpty) {
      var url = Uri.https('driverapi.sokoyoyacomrade.com', '/api/register');
      print(emailcontroller.text);
      var response = await http.post(
        url,
        body: {
          'name': namecontroller.text,
          'email': emailcontroller.text,
          'password': passwordcontroller.text,
          'password_confirmation': passwordcontroller.text,
          'UserType': valueChoose,
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      if (response.statusCode == 201) {
        Navigator.of(context).pop();
        Fluttertoast.showToast(
            msg: "Created successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM, // Also possible "TOP" and "CENTER"
            backgroundColor: Colors.grey,
            textColor: Colors.white);
        final Map parsed = json.decode(response.body);
      } else {
        print("Failed to Login");
        Fluttertoast.showToast(
            msg: "Create Fail",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM, // Also possible "TOP" and "CENTER"
            backgroundColor: Colors.grey,
            textColor: Colors.white);
      }
      setState(() {
        if (emailcontroller.text.isEmpty) {
          emailempty = true;
        } else {
          emailempty = false;
        }
        if (passwordcontroller.text.isEmpty) {
          passwordempty = true;
        } else {
          passwordempty = false;
        }
        if (namecontroller.text.isEmpty) {
          namempty = true;
        } else {
          namempty = false;
        }
      });
    } else {
      setState(() {
        if (emailcontroller.text.isEmpty) {
          emailempty = true;
        } else {
          emailempty = false;
        }
        if (passwordcontroller.text.isEmpty) {
          passwordempty = true;
        } else {
          passwordempty = false;
        }
        if (namecontroller.text.isEmpty) {
          namempty = true;
        } else {
          namempty = false;
        }
      });
      Fluttertoast.showToast(
          msg: "Empty  Fields",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM, // Also possible "TOP" and "CENTER"
          backgroundColor: Colors.grey,
          textColor: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Manage Users",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: ListView.separated(
          itemBuilder: (context, index) {
            return ListTile(
              onTap: () {},
              leading: Text(_userList[index].UserType),
              title: Text(_userList[index].name),
              subtitle: Text(_userList[index].email),
            );
          },
          separatorBuilder: (context, index) => Divider(color: Colors.black),
          itemCount: _userList.length),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: IconThemeData(size: 22),
        backgroundColor: Colors.blue,
        visible: true,
        curve: Curves.bounceIn,
        children: [
          // FAB 1
          SpeedDialChild(
              child: Icon(
                Icons.document_scanner_sharp,
                color: Colors.white,
              ),
              backgroundColor: Colors.blue,
              onTap: () {
                //readExcel();
                //getPdfAndUpload();
                setState(() {
                  _pickleFile();
                });

                //FilePick();
              },
              label: 'Import Excel',
              labelStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  fontSize: 16.0),
              labelBackgroundColor: Colors.blue),
          // FAB 2
          SpeedDialChild(
              child: Icon(
                Icons.person,
                color: Colors.white,
              ),
              backgroundColor: Colors.blue,
              onTap: () {
                showDataAlert(context);
              },
              label: 'Create User',
              labelStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  fontSize: 16.0),
              labelBackgroundColor: Colors.blue)
        ],
      ),
    );
  }
}
