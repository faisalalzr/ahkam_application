import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final Map<String, dynamic> message;

  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    bool isSentByCurrentUser = message['senderId'] ==
        'currentUserId'; // Replace with actual user ID check

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment:
            isSentByCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Material(
          borderRadius: BorderRadius.circular(10.0),
          color: isSentByCurrentUser ? Colors.blue : Colors.grey,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              message['text'],
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
