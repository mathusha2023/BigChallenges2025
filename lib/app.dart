import 'package:bc_phthalmoscopy/ui/router/router.dart';
import 'package:bc_phthalmoscopy/ui/themes/dark_theme.dart';
import 'package:bc_phthalmoscopy/ui/themes/light_theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final ValueNotifier<ThemeMode> notifier = ValueNotifier(
    ThemeMode.light,
  );

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: notifier,
      builder: (_, mode, __) {
        return MaterialApp.router(
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('ru', 'RU'), // Русский язык
          ],
          theme: LightTheme().themeData,
          darkTheme: DarkTheme().themeData,
          themeMode: mode,
          routerConfig: router,
        );
      },
    );
  }
}
