import 'package:flutter/material.dart';

import '../../data/old_bibles_data.dart';

class VersesPanel extends StatelessWidget {
  const VersesPanel({
    super.key,
    required this.verses,
    required this.fontSize,
    required this.noVersesLabel,
  });

  final List<OldBibleVerse> verses;
  final double fontSize;
  final String noVersesLabel;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: verses.isEmpty
          ? Center(
              child: Text(noVersesLabel),
            )
          : Card(
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: verses.length,
                itemBuilder: (context, index) {
                  final verse = verses[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: fontSize,
                          color: Theme.of(context).colorScheme.onSurface,
                          height: 1.45,
                        ),
                        children: [
                          TextSpan(
                            text: '${verse.verse}. ',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(text: verse.text),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
