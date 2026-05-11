import 'package:flutter/material.dart';

import '../widgets/book_chat_box.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: BookChatBox(),
    );
  }
}
