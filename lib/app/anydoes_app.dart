import 'package:anydoes/app/navigation/adaptive_shell.dart';
import 'package:anydoes/app/providers.dart';
import 'package:anydoes/app/theme/calm_sky_theme.dart';
import 'package:anydoes/domain/models/planning_preferences.dart';
import 'package:anydoes/features/settings/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AnydoesApp extends ConsumerWidget {
  const AnydoesApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preferences = ref.watch(appearanceProvider);
    ref.watch(notificationCoordinatorProvider);
    ref.watch(recurrenceMaterializationProvider);
    return MaterialApp(
      title: 'Anydoes',
      debugShowCheckedModeBanner: false,
      theme: CalmSkyTheme.light(highContrast: preferences.highContrast),
      darkTheme: CalmSkyTheme.dark(highContrast: preferences.highContrast),
      themeMode: switch (preferences.themeMode) {
        AppThemeMode.system => ThemeMode.system,
        AppThemeMode.light => ThemeMode.light,
        AppThemeMode.dark => ThemeMode.dark,
      },
      themeAnimationDuration: preferences.reduceMotion
          ? Duration.zero
          : const Duration(milliseconds: 200),
      builder: (context, child) {
        final media = MediaQuery.of(context);
        return MediaQuery(
          data: media.copyWith(
            disableAnimations:
                media.disableAnimations || preferences.reduceMotion,
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
      home: const AdaptiveShell(),
    );
  }
}
