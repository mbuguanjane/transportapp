import 'dart:convert';

import 'package:flutterdriverapp/model/loginuser.dart';
import 'package:flutterdriverapp/model/clockinout.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ClockInOut extends StatefulWidget {
  const ClockInOut({super.key});

  @override
  State<ClockInOut> createState() => _ClockInOutState();
}

class _ClockInOutState extends State<ClockInOut> {
  late String currentDate;
  late ClockInOutModel? currentClock = null;
  Future<ClockInOutModel?> checkClockInOut() async {
    var now = DateTime.now();
    var formatterDate = DateFormat('yyyy-MM-dd');
    var formatterTime = DateFormat('kk:mm');
    String actualDate = formatterDate.format(now);
    String actualTime = formatterTime.format(now);
    print(actualTime);
    print(actualDate);
    var url = Uri.https('driverapi.sokoyoyacomrade.com',
        '/api/UserLogs/' + loginUser!.userid.toString() + "/" + actualDate);
    var response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + loginUser!.token,
    }
        // body: {'email': 'mbuguanjane@gmail.com', 'password': '12345678'}
        );
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    if (response.statusCode == 200) {
      //taskList = json.decode(response.body);
      var parsed = json.decode(response.body);
      ClockInOutModel clockInOutModel = ClockInOutModel.fromJson(parsed);

      print("--------------------");
      return clockInOutModel;
    } else {
      print("Failed to Send");
    }
  }

  ClockOut(context, id) async {
    var now = DateTime.now();
    var formatterDate = DateFormat('yyyy-MM-dd');
    var formatterTime = DateFormat('kk:mm');
    String actualDate = formatterDate.format(now);
    String actualTime = formatterTime.format(now);
    var url = Uri.https('driverapi.sokoyoyacomrade.com', '/api/UserLogs/' + id);
    var response = await http.put(url, headers: {
      // 'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + loginUser!.token,
    }, body: {
      "TimeOut": actualTime,
    });

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          msg: "Clock Out successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM, // Also possible "TOP" and "CENTER"
          backgroundColor: Colors.grey,
          textColor: Colors.white);
    } else {
      print("Failed to Send");
      Fluttertoast.showToast(
          msg: "Failed successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM, // Also possible "TOP" and "CENTER"
          backgroundColor: Colors.grey,
          textColor: Colors.white);
    }
  }

  createClock(context) async {
    var now = DateTime.now();
    var formatterDate = DateFormat('yyyy-MM-dd');
    var formatterTime = DateFormat('kk:mm');
    String actualDate = formatterDate.format(now);
    String actualTime = formatterTime.format(now);
    showDialog(
                            context: context,
                            builder: (context) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            });
                            // Navigator.of(context).pop();
    var url = Uri.https('driverapi.sokoyoyacomrade.com', '/api/UserLogs');
    var response = await http.post(url, headers: {
      // 'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + loginUser!.token,
    }, body: {
      "CheckDate": actualDate,
      "TimeIn": actualTime,
      "Name": loginUser!.userModel.name,
      "Userid": loginUser?.userid.toString(),
    });

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    if (response.statusCode == 201) {
      Navigator.of(context).pop();
      Fluttertoast.showToast(
          msg: "Clock in successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM, // Also possible "TOP" and "CENTER"
          backgroundColor: Colors.grey,
          textColor: Colors.white);
    } else {
      Navigator.of(context).pop();
      print("Failed to Send");
      Fluttertoast.showToast(
          msg: "Failed successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM, // Also possible "TOP" and "CENTER"
          backgroundColor: Colors.grey,
          textColor: Colors.white);
    }
  }

  @override
  void initState() {
    checkClockInOut().then((value) => {
          setState(() {
            currentClock = value!;
            print(currentClock!.TimeOut);
          })
        });

    var now = DateTime.now();
    var formatterDate = DateFormat('yyyy-MM-dd');
    var formatterTime = DateFormat('kk:mm');
    String actualDate = formatterDate.format(now);
    String actualTime = formatterTime.format(now);
    currentDate = actualDate;
    print(actualTime);
    print(actualDate);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: Text("Clock In and Out"),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     var now = DateTime.now();
      //     var formatterDate = DateFormat('dd/MM/yy');
      //     var formatterTime = DateFormat('kk:mm');
      //     String actualDate = formatterDate.format(now);
      //     String actualTime = formatterTime.format(now);
      //     print(actualDate);
      //     print(actualTime);
      //   },
      //   child: Icon(Icons.add),
      // ),
      body: Center(
        child: Container(
          width: 300,
          height: 300,
          alignment: Alignment.center,
          child: Card(
            color: Colors.grey,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 5,
            shadowColor: Colors.blue,
            margin: EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.date_range_sharp,
                      color: Colors.white,
                    ),
                    Text(
                      "Date: " + currentDate,
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(
                      Icons.punch_clock_sharp,
                      color: Colors.white,
                    ),
                    Icon(
                      Icons.punch_clock_sharp,
                      color: Colors.white,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(currentClock != null ? currentClock!.TimeIn : ""),
                    Text(currentClock != null ? currentClock!.TimeOut : "")
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        onPressed: currentClock == null
                            ? () {
                                createClock(context);

                                setState(() {
                                  checkClockInOut().then((value) => {
                                        setState(() {
                                          currentClock = value!;
                                          print(currentClock!.TimeOut);
                                        })
                                      });
                                });
                              }
                            : null,
                        child: Text("Clock In")),
                    ElevatedButton(
                        onPressed: currentClock?.TimeOut == "0.00"
                            ? () {
                                ClockOut(context, currentClock!.id.toString());
                                checkClockInOut().then((value) => {
                                      setState(() {
                                        currentClock = value!;
                                        print(currentClock!.TimeOut);
                                      })
                                    });
                              }
                            : null,
                        child: Text("Clock Out"))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
