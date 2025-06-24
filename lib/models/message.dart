import 'package:chat_app/constants.dart';

class MessageModel {
  final String text;
  final String user;

  MessageModel({required this.text, required this.user});

  factory MessageModel.fromJson(jsonData) {
    return MessageModel(text: jsonData[kMessage], user: jsonData[kUser]);
  }
}
