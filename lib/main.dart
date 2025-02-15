import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:terminflow/data/common/theme.dart';
import 'package:terminflow/data/l10n/generated/l10n.dart';
import 'package:terminflow/screens/main/main_screen.dart';

void main() {
  runApp(
    // For widgets to be able to read providers, we need to wrap the entire
    // application in a "ProviderScope" widget.
    // This is where the state of our providers will be stored.
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Terminflow',
      // 默认为浅色主题
      // themeMode: ThemeMode.dark,
      themeMode: ThemeMode.dark,
      // 默认为英文
      // locale: const Locale('en'),
      theme: m3LightThemeData(context),
      darkTheme: m3DarkThemeData(context),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const MainScreen(),
      builder: EasyLoading.init(),
    );
  }
}
