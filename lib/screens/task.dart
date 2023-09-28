import 'package:flutterdriverapp/model/loginuser.dart';
import 'package:flutterdriverapp/model/task.dart';
import 'package:flutterdriverapp/model/usermodel.dart';
import 'package:flutterdriverapp/screens/assignUser.dart';
import 'package:flutterdriverapp/screens/home.dart';
import 'package:flutterdriverapp/screens/userhome.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:geocoding/geocoding.dart';
import 'package:url_launcher/url_launcher.dart';



class TaskScreen extends StatefulWidget {
  TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> with WidgetsBindingObserver {
  final List<TaskModel> _taskList = <TaskModel>[];

   
 Future<void> _launchUrl() async {
    const String homeLat = "37.3230";
    const String homeLng = "-122.0312";
    final Uri _url = Uri.parse(
        "https://www.google.com/maps/search/?api=1&query=$homeLat,$homeLng");
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  } 

  viewUser(context, userid) async {
    var url = Uri.https(
        'driverapi.sokoyoyacomrade.com', '/api/user/' + userid.toString());
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
      var parsed = json.decode(response.body);
      UserModel userModel = UserModel.fromJson(parsed);
      showUser(context, userModel);
    } else {
      Fluttertoast.showToast(
          msg: "Failed to send " + response.body,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM, // Also possible "TOP" and "CENTER"
          backgroundColor: Colors.grey,
          textColor: Colors.white);
    }
  }

  getLocation()
  async {
    List<Location> locations = await locationFromAddress("Gronausestraat 710, Enschede");
    print(locations);
  }
  showUser(context, UserModel userModel) {
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
              "Assign User",
              style: TextStyle(fontSize: 24.0),
            ),
            content: Container(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(userModel.name),
                    Text(userModel.email),
                    Text(userModel.UserType),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Future<List<TaskModel>?> getTasks() async {
    var url = Uri.https('driverapi.sokoyoyacomrade.com', '/api/Duties');
    var response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + loginUser!.token,
    }
        // body: {'email': 'mbuguanjane@gmail.com', 'password': '12345678'}
        );

    if (response.statusCode == 200) {
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      //taskList = json.decode(response.body);
      var parsed = json.decode(response.body);
      // print(parsed);

      List<TaskModel> taskList = <TaskModel>[];
      for (var item in parsed) {
        // print(item['Firstname']);
        taskList.add(TaskModel.fromJson(item));
      }
      print(taskList.length);
      print("--------------------");
      return taskList;
    } else {
      print("Failed to Send");
    }
  }

  TextEditingController Tripid = new TextEditingController();
  TextEditingController MemberName = new TextEditingController();
  TextEditingController PhoneNumber = new TextEditingController();
  TextEditingController LevelofService = new TextEditingController();
  TextEditingController DateofService = new TextEditingController();
  TextEditingController PickUpTime = new TextEditingController();
  TextEditingController Note = new TextEditingController();
  TextEditingController DropOffAddress = new TextEditingController();
  TextEditingController TripType = new TextEditingController();
  TextEditingController DOB = new TextEditingController();
  TextEditingController Miles = new TextEditingController();
  
  clearFields()
  {
    Tripid.text="";
    MemberName.text="";
    PhoneNumber.text="";
    LevelofService.text="";
    DateofService.text="";
    PickUpTime.text="";
    Note.text="";
    DropOffAddress.text="";
    DOB.text="";
    Miles.text="";
  }
  bool checkEmpty()
  {
    if(Tripid.text.isEmpty){
       Fluttertoast.showToast(
            msg: "Tripid is empty",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM, // Also possible "TOP" and "CENTER"
            backgroundColor: Colors.grey,
            textColor: Colors.white);
      return false;
    }else  if(MemberName.text.isEmpty){
       Fluttertoast.showToast(
            msg: "MemberName is empty",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM, // Also possible "TOP" and "CENTER"
            backgroundColor: Colors.grey,
            textColor: Colors.white);
      return false;
    }else  if(PhoneNumber.text.isEmpty){
       Fluttertoast.showToast(
            msg: "PhoneNumber is empty",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM, // Also possible "TOP" and "CENTER"
            backgroundColor: Colors.grey,
            textColor: Colors.white);
      return false;
    }else  if(LevelofService.text.isEmpty){
       Fluttertoast.showToast(
            msg: "LevelofService is empty",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM, // Also possible "TOP" and "CENTER"
            backgroundColor: Colors.grey,
            textColor: Colors.white);
      return false;
    }else  if(DateofService.text.isEmpty){
       Fluttertoast.showToast(
            msg: "DateofService is empty",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM, // Also possible "TOP" and "CENTER"
            backgroundColor: Colors.grey,
            textColor: Colors.white);
      return false;
    }else  if(PickUpTime.text.isEmpty){
       Fluttertoast.showToast(
            msg: "PickUpTime is empty",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM, // Also possible "TOP" and "CENTER"
            backgroundColor: Colors.grey,
            textColor: Colors.white);
      return false;
    }else  if(Note.text.isEmpty){
       Fluttertoast.showToast(
            msg: "Note is empty",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM, // Also possible "TOP" and "CENTER"
            backgroundColor: Colors.grey,
            textColor: Colors.white);
      return false;
    }else  if(DropOffAddress.text.isEmpty){
       Fluttertoast.showToast(
            msg: "DropOffAddress is empty",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM, // Also possible "TOP" and "CENTER"
            backgroundColor: Colors.grey,
            textColor: Colors.white);
      return false;
    }else  if(TripType.text.isEmpty){
       Fluttertoast.showToast(
            msg: "TripType is empty",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM, // Also possible "TOP" and "CENTER"
            backgroundColor: Colors.grey,
            textColor: Colors.white);
      return false;
    }else  if(DOB.text.isEmpty){
       Fluttertoast.showToast(
            msg: "DOB is empty",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM, // Also possible "TOP" and "CENTER"
            backgroundColor: Colors.grey,
            textColor: Colors.white);
      return false;
    }else  if(Miles.text.isEmpty){
       Fluttertoast.showToast(
            msg: "Miles is empty",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM, // Also possible "TOP" and "CENTER"
            backgroundColor: Colors.grey,
            textColor: Colors.white);
      return false;
    }else
     {
       return true;
     }
  }

  createTask(context) async {
    if(checkEmpty()){
      showDialog(
                            context: context,
                            builder: (context) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            });
                            // Navigator.of(context).pop();
        var url = Uri.https('driverapi.sokoyoyacomrade.com', '/api/Duties');
    var response = await http.post(url, headers: {
      // 'Content-Type': 'application/json',
      // 'Accept': 'application/json',
      'Authorization': 'Bearer ' + loginUser!.token,
    }, body: {
      "Tripid": Tripid.text,
      "MemberName": MemberName.text,
      "PhoneNumber": PhoneNumber.text,
      "LevelofService": LevelofService.text,
      "DateofService": DateofService.text,
      "PickUpTime": PickUpTime.text,
      "Note": Note.text,
      "DropOffAddress": DropOffAddress.text,
      "TripType": TripType.text,
      "DOB": DOB.text,
      "Miles": Miles.text,
      "TaskStatus": "pending",
      "Userid": "0",
    });

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    if (response.statusCode == 201) {
      clearFields();
      Navigator.of(context).pop();
      Fluttertoast.showToast(
          msg: "Task created successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM, // Also possible "TOP" and "CENTER"
          backgroundColor: Colors.grey,
          textColor: Colors.white);
      Navigator.of(context).pop();
      _taskList.clear();
      getTasks().then((value) => {
            setState(() {
              _taskList.addAll(value!);
            })
          });
    } else {
      Navigator.of(context).pop();
      print("Failed to Send");
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
              "Create Task",
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
                        "Tripid",
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: Tripid,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter Trip id',
                            labelText: 'First Trip id'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Member Name",
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: MemberName,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter Member Name',
                            labelText: 'First MemberName'),
                      ),
                    ),

                    // Email Here
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Phone Number",
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: PhoneNumber,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter PhoneNumber',
                            labelText: 'Phone Number'),
                      ),
                    ),
                    // Password
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Level of Service",
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: LevelofService,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter Level of Service',
                            labelText: 'Level of Service'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Date of Service",
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: DateofService,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter Date of Service',
                            labelText: 'Enter Date of Service'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Pick Up Time",
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: PickUpTime,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter Note',
                            labelText: 'Enter Note'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Drop Off Address",
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: DropOffAddress,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter Drop Off Address',
                            labelText: 'Enter Drop Off Address'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Trip Type",
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: TripType,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter Trip Type',
                            labelText: 'Enter Trip Type'),
                      ),
                    ),
                     Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "DOB",
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: DOB,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter DOB',
                            labelText: 'Enter DOB'),
                      ),
                    ),
                     Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Note",
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: Note,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter Note',
                            labelText: 'Enter Note'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Miles",
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: Miles,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter Miles',
                            labelText: 'Enter Miles'),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 60,
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          createTask(context);
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
    getTasks().then((value) => {
          setState(() {
            _taskList.addAll(value!);
          })
        });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("Ati nini");
    print(_taskList?.length);
    print("Mzai");
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Task Page",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
          itemBuilder: (context, index) {
            return Container(
              width: double.infinity,
              color: Colors.blue,
              height: 450,
              child: Card(
                color: _taskList[index].taskStatus == "Completed"
                    ? Colors.amberAccent
                    : null,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 5,
                shadowColor: Colors.blue,
                margin: EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Icon(Icons.person),
                        Text("Tripid:\n" +
                                _taskList[index].Tripid.toString() 
                                ??
                            'Tripid'),
                        Icon(Icons.punch_clock),
                        Text("MemberName: \n" + _taskList[index].MemberName ??
                            'MemberName'),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Icon(Icons.place),
                        Text("PhoneNumber:\n" +
                                _taskList[index].PhoneNumber ??
                            'PhoneNumber'),
                        Icon(Icons.task),
                        Text("Level of Service:\n" + _taskList[index].LevelofService ??
                            'Level of Service'),
                      ],
                    ),


                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Icon(Icons.person),
                        Text("Date of Service:\n" +
                                _taskList[index].DateofService 
                                ??
                            'Date of Service'),
                        Icon(Icons.punch_clock),
                        
                        Text("Pick Up Time: \n" + _taskList[index].PickUpTime ??
                            'Pick Up Time'),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Icon(Icons.place),
                        GestureDetector(
                          onTap: (){
                            _launchUrl();
                          },
                          child: Text("Drop Off Address:\n" +
                                  _taskList[index].DropOffAddress ??
                              'Drop Off Address'),
                        ),
                        Icon(Icons.task),
                        Text("Trip Type:\n" + _taskList[index].TripType ??
                            'Trip Type'),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Icon(Icons.place),
                        Text("DOB:\n" +
                                _taskList[index].DOB ??
                            'DOB'),
                        Icon(Icons.task),
                        Text("Miles:\n" + _taskList[index].Miles ??
                            'Miles'),
                      ],
                    ),  
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                     
                        Icon(Icons.task),
                        Text("Note:\n" + _taskList[index].Note ??
                            'Note'),
                      ],
                    ),
                     
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                            style: _taskList[index].userid == 0
                                ? ButtonStyle(
                                    backgroundColor:
                                        MaterialStatePropertyAll<Color>(
                                            Colors.blue))
                                : ButtonStyle(
                                    backgroundColor:
                                        MaterialStatePropertyAll<Color>(
                                            Colors.green)),
                            onPressed: _taskList[index].userid == 0
                                ? () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => AssignUser(
                                                  data: _taskList[index].id,
                                                )));
                                  }
                                : () {
                                    viewUser(context, _taskList[index].userid);
                                  },
                            child: _taskList[index].userid == 0
                                ? Text("Assign Task")
                                : Text(
                                    "View User",
                                  ))
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(Icons.task_alt),
                        Text(
                          "Task Status: " + _taskList[index].taskStatus,
                          style: TextStyle(
                              backgroundColor:
                                  _taskList[index].taskStatus == "Completed"
                                      ? Colors.blue
                                      : null),
                        )
                      ],
                    )
                  ],
                ),
              ),
            );
          },
          itemCount: _taskList.length),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
        showDataAlert(context);
         
          
          
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
