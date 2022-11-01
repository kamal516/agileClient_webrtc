class MessageList {
  String message;
  String to;
  String from;
  MessageList(
    this.message,
    this.to,
    this.from,
  );

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{'message': message, 'to': to, 'from': from};
    return map;
  }

  MessageList.fromMap(Map<String, dynamic> map) {
    message = map['message'];
    to = map['to'];
    from = map['from'];
  }
}
