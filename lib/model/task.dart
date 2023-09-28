class TaskModel {
  int id;
  int Tripid;
  String MemberName;
  String PhoneNumber;
  String LevelofService;
  String DateofService;
  String PickUpTime;
  String Note;
  String DropOffAddress;
  String TripType;
  String DOB;
  String Miles;
  String taskStatus;
  int userid;

  TaskModel({
    required this.id,
    required this.Tripid,
    required this.MemberName,
    required this.PhoneNumber,
    required this.LevelofService,
    required this.DateofService,
    required this.PickUpTime,
    required this.Note,
    required this.DropOffAddress,
    required this.TripType,
    required this.DOB,
    required this.Miles,
    required this.userid,
    required this.taskStatus,
  });
  factory TaskModel.fromJson(Map<String, dynamic> json) {
    print(json);
    return TaskModel(
      id: json['id'],
      Tripid: json['Tripid'],
      MemberName: json['MemberName'],
      PhoneNumber: json['PhoneNumber'],
      LevelofService: json['LevelofService'],
      DateofService: json['DateofService'],
      PickUpTime: json['PickUpTime'],
      Note: json['Note'],
      DropOffAddress: json['DropOffAddress'],
      TripType: json['TripType'],
      DOB: json['DOB'],
      Miles: json['Miles'],
      userid: json['Userid'],
      taskStatus: json['TaskStatus'],
    );
  }
}

// List<TaskModel> dummyTask = [
//   TaskModel(
//       id: 1,
//       firstname: "John",
//       lastname: "Doe",
//       pickuptime: "12:00 pm",
//       pickupaddress: "Canada",
//       joboffered: "Transport Maize"),
//   TaskModel(
//       id: 2,
//       firstname: "John",
//       lastname: "Doe",
//       pickuptime: "12:00 pm",
//       pickupaddress: "Canada",
//       joboffered: "Transport Maize"),
//   TaskModel(
//       id: 3,
//       firstname: "John",
//       lastname: "Doe",
//       pickuptime: "12:00 pm",
//       pickupaddress: "Canada",
//       joboffered: "Transport Maize"),
//   TaskModel(
//       id: 4,
//       firstname: "John",
//       lastname: "Doe",
//       pickuptime: "12:00 pm",
//       pickupaddress: "Canada",
//       joboffered: "Transport Maize"),
//   TaskModel(
//       id: 5,
//       firstname: "John",
//       lastname: "Doe",
//       pickuptime: "12:00 pm",
//       pickupaddress: "Canada",
//       joboffered: "Transport Maize"),
//   TaskModel(
//       id: 6,
//       firstname: "John",
//       lastname: "Doe",
//       pickuptime: "12:00 pm",
//       pickupaddress: "Canada",
//       joboffered: "Transport Maize"),
//   TaskModel(
//       id: 7,
//       firstname: "John",
//       lastname: "Doe",
//       pickuptime: "12:00 pm",
//       pickupaddress: "Canada",
//       joboffered: "Transport Maize"),
//   TaskModel(
//       id: 8,
//       firstname: "John",
//       lastname: "Doe",
//       pickuptime: "12:00 pm",
//       pickupaddress: "Canada",
//       joboffered: "Transport Maize"),
//   TaskModel(
//       id: 9,
//       firstname: "John",
//       lastname: "Doe",
//       pickuptime: "12:00 pm",
//       pickupaddress: "Canada",
//       joboffered: "Transport Maize"),
//   TaskModel(
//       id: 10,
//       firstname: "John",
//       lastname: "Doe",
//       pickuptime: "12:00 pm",
//       pickupaddress: "Canada",
//       joboffered: "Transport Maize"),
//   TaskModel(
//       id: 11,
//       firstname: "John",
//       lastname: "Doe",
//       pickuptime: "12:00 pm",
//       pickupaddress: "Canada",
//       joboffered: "Transport Maize"),
//   TaskModel(
//       id: 12,
//       firstname: "John",
//       lastname: "Doe",
//       pickuptime: "12:00 pm",
//       pickupaddress: "Canada",
//       joboffered: "Transport Maize"),
//   TaskModel(
//       id: 13,
//       firstname: "John",
//       lastname: "Doe",
//       pickuptime: "12:00 pm",
//       pickupaddress: "Canada",
//       joboffered: "Transport Maize"),
//   TaskModel(
//       id: 14,
//       firstname: "John",
//       lastname: "Doe",
//       pickuptime: "12:00 pm",
//       pickupaddress: "Canada",
//       joboffered: "Transport Maize"),
//   TaskModel(
//       id: 15,
//       firstname: "John",
//       lastname: "Doe",
//       pickuptime: "12:00 pm",
//       pickupaddress: "Canada",
//       joboffered: "Transport Maize"),
//   TaskModel(
//       id: 16,
//       firstname: "John",
//       lastname: "Doe",
//       pickuptime: "12:00 pm",
//       pickupaddress: "Canada",
//       joboffered: "Transport Maize"),
//   TaskModel(
//       id: 17,
//       firstname: "John",
//       lastname: "Doe",
//       pickuptime: "12:00 pm",
//       pickupaddress: "Canada",
//       joboffered: "Transport Maize"),
//   TaskModel(
//       id: 18,
//       firstname: "John",
//       lastname: "Doe",
//       pickuptime: "12:00 pm",
//       pickupaddress: "Canada",
//       joboffered: "Transport Maize"),
//   TaskModel(
//       id: 19,
//       firstname: "John",
//       lastname: "Doe",
//       pickuptime: "12:00 pm",
//       pickupaddress: "Canada",
//       joboffered: "Transport Maize"),
// ];
