import 'package:flutter/material.dart';

import '../features/mushaf/data/models/mushaf_catalog.dart';
import '../features/mushaf/domain/repositories/mushaf_repository.dart';
import '../features/mushaf/presentation/screens/mushaf_screen.dart';

class QalamApp extends StatelessWidget {
  const QalamApp({required this.mushafRepository, super.key});

  final MushafRepository mushafRepository;

  @override
  Widget build(BuildContext context) {
    const seedColor = Color(0xFF0E6F5C);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Qalam',
      themeMode: ThemeMode.system,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: seedColor,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F1E8),
        appBarTheme: const AppBarTheme(
          centerTitle: false,
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: seedColor,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF0D1211),
        appBarTheme: const AppBarTheme(
          centerTitle: false,
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
      ),
      home: MushafLineSelectionScreen(
        sources: MushafCatalog.sources,
        repository: mushafRepository,
      ),
    );
  }
}
