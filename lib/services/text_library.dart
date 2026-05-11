import 'dart:convert';

import 'package:flutter/services.dart';

class TextAssetEntry {
  const TextAssetEntry({
    required this.assetPath,
    required this.fileName,
    required this.displayName,
  });

  final String assetPath;
  final String fileName;
  final String displayName;
}

class TextLibrary {
  Future<List<TextAssetEntry>> listTextAssets() async {
    final manifestJson = await rootBundle.loadString('AssetManifest.json');
    final manifest = jsonDecode(manifestJson) as Map<String, dynamic>;

    final entries = manifest.keys
        .where((path) => path.startsWith('assets/texts/') && path.toLowerCase().endsWith('.txt'))
        .map((path) {
          final fileName = path.split('/').last;
          return TextAssetEntry(
            assetPath: path,
            fileName: fileName,
            displayName: _displayName(fileName),
          );
        })
        .toList()
      ..sort((a, b) => a.displayName.compareTo(b.displayName));

    return entries;
  }

  Future<String> loadText(String assetPath) {
    return rootBundle.loadString(assetPath);
  }

  String _displayName(String fileName) {
    final withoutExtension = fileName.replaceAll(RegExp(r'\.txt$', caseSensitive: false), '');
    return withoutExtension
        .replaceAll('_', ' ')
        .replaceAll('-', ' ')
        .split(' ')
        .where((part) => part.trim().isNotEmpty)
        .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
        .join(' ');
  }
}
