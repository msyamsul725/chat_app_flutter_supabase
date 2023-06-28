class RoomData {
  final int? id;
  final int? sender;
  final int? rec;
  final String? recname;
  final String? sendname;

  RoomData({this.id, this.sender, this.rec, this.recname, this.sendname});

  factory RoomData.fromJson(Map<String, dynamic> json) => RoomData(
        id: json['id'],
        sender: json['sender'],
        rec: json['rec'],
        recname: json['recname'],
        sendname: json['sendname'],
      );
}
