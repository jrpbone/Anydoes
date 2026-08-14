import 'package:anydoes/app/navigation/adaptive_shell.dart';
import 'package:anydoes/app/theme/calm_sky_theme.dart';
import 'package:flutter/material.dart';

class AnydoesApp extends StatelessWidget {
  const AnydoesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Anydoes',
      debugShowCheckedModeBanner: false,
      theme: CalmSkyTheme.light(),
      home: const AdaptiveShell(),
    );
  }
}
