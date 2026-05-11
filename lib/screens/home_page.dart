import 'package:flutter/material.dart';

import 'chat_screen.dart';
import 'reader_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Old Bibles Reader'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.book), text: 'Reader'),
              Tab(icon: Icon(Icons.chat_bubble), text: 'Book Chat'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            ReaderScreen(),
            ChatScreen(),
          ],
        ),
      ),
    );
  }
}
