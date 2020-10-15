

class Message {
  String content;
  String idTo;
  String idFrom;
  String timestamp;

  Message.fromSnap(Map<dynamic, dynamic> json) {
    content = json['content'];
    idTo = json['idTo'];
    idFrom = json['idFrom'];
    timestamp = json['timestamp'];
  }
}
