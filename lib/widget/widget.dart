import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final Color color;
  final String text;
  final bool isSender;
  final TextStyle textStyle;

  const MessageBubble({
    Key? key,
    required this.color,
    required this.text,
    required this.isSender,
    required this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
            bottomLeft: isSender ? Radius.circular(15) : Radius.circular(0),
            bottomRight: isSender ? Radius.circular(0) : Radius.circular(15),
          ),
        ),
        child: Text(
          text,
          style: textStyle,
        ),
      ),
    );
  }
}
