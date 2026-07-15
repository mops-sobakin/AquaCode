import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'theme/theme_provider.dart';
import 'screens/main_screen.dart';

class AquaCodeApp extends StatelessWidget {
  const AquaCodeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'Aqua Code V1',
            debugShowCheckedModeBanner: false,
            theme: themeProvider.themeData,
            themeMode: ThemeMode.dark,
            home: const MainScreen(),
          );
        },
      ),
    );
  }
}
