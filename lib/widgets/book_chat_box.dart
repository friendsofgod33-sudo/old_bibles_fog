import 'package:flutter/material.dart';

import '../services/book_service.dart';

class BookChatBox extends StatefulWidget {
  const BookChatBox({super.key});

  @override
  State<BookChatBox> createState() => _BookChatBoxState();
}

class _BookChatBoxState extends State<BookChatBox> {
  final List<String> _messages = [];
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleSend() async {
    if (_controller.text.trim().isEmpty) {
      return;
    }

    final input = _controller.text.trim();
    setState(() {
      _messages.add('You: $input');
    });

    if (input.toLowerCase().endsWith('.txt')) {
      final content = await BookService.getBookContent(input);
      final preview = content.length > 500 ? '${content.substring(0, 500)}...' : content;
      if (!mounted) {
        return;
      }
      setState(() {
        _messages.add('App: $preview');
      });
    }

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: _messages.length,
            itemBuilder: (context, index) => ListTile(
              title: Text(_messages[index]),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    hintText: 'Enter book filename (e.g. geneva_1560.txt)',
                  ),
                  onSubmitted: (_) => _handleSend(),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: _handleSend,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
