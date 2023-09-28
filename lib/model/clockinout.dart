class ClockInOutModel {
  final int id;
  final String CheckDate;
  final String TimeIn;
  final String TimeOut;
  final int Userid;
  final String Name;

  const ClockInOutModel(
      {required this.id,
      required this.CheckDate,
      required this.TimeIn,
      required this.TimeOut,
      required this.Name,
      required this.Userid});

  factory ClockInOutModel.fromJson(Map<String, dynamic> json) {
    print(json);
    return ClockInOutModel(
      id: json['id'],
      CheckDate: json['CheckDate'],
      TimeIn: json['TimeIn'],
      TimeOut: json['TimeOut'] ?? "0.00",
      Name: json['Name'],
      Userid: json['Userid'],
    ); //  as String);
  }
}
