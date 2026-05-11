import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'data/language_catalog.dart';
import 'screens/home_page.dart';

void main() {
  runApp(const OldBiblesApp());
}

class OldBiblesApp extends StatelessWidget {
  const OldBiblesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Old Bibles',
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: AppLanguageCatalog.languages
          .map((language) => language.locale)
          .toList(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6A4A2F)),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

