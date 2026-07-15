import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';

class ThemeSelector extends StatelessWidget {
  const ThemeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Theme',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildThemeOption(
              context,
              'Dark Theme',
              ThemeType.dark,
              themeProvider,
            ),
            _buildThemeOption(
              context,
              'Aqua Theme',
              ThemeType.aqua,
              themeProvider,
            ),
            _buildThemeOption(
              context,
              'White Theme',
              ThemeType.white,
              themeProvider,
            ),
          ],
        );
      },
    );
  }

  Widget _buildThemeOption(
    BuildContext context,
    String title,
    ThemeType theme,
    ThemeProvider provider,
  ) {
    final isSelected = provider.currentTheme == theme;
    return ListTile(
      leading: Icon(
        isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
        color: Theme.of(context).colorScheme.primary,
      ),
      title: Text(title),
      onTap: () => provider.setTheme(theme),
    );
  }
}
