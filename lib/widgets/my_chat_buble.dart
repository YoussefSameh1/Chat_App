import 'package:chat_app/models/message.dart';
import 'package:flutter/material.dart';

class MyChatBuble extends StatelessWidget {
  final MessageModel message;
  const MyChatBuble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: EdgeInsets.only(left: 24, top: 32, bottom: 32, right: 24),
        decoration: BoxDecoration(
          color: Color(0xff006488),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
            bottomLeft: Radius.circular(24),
          ),
        ),
        child: Text(
          message.text,
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    );
  }
}
