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
  bool _loading = false;

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
      setState(() => _loading = true);
      final lines = await BookService.getBookLines(input);
      if (!mounted) return;
      final preview = lines.take(20).join('\n');
      setState(() {
        _loading = false;
        _messages.add('App:\n$preview${lines.length > 20 ? '\n…(${lines.length} lines total)' : ''}');
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
        if (_loading) const LinearProgressIndicator(),
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

