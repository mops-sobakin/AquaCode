import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int _selectedSection = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Row(
        children: [
          _buildSidebar(),
          Expanded(child: _buildContent()),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 260,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          right: BorderSide(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
          ),
        ),
      ),
      child: Column(
        children: [
          _buildHeader(),
          Expanded(child: _buildMenuList()),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          InkWell(
            onTap: () => Navigator.pop(context),
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.arrow_back_ios_new,
                  size: 16, color: Theme.of(context).colorScheme.primary),
            ),
          ),
          const SizedBox(width: 14),
          Text(
            'SETTINGS',
            style: GoogleFonts.orbitron(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.primary,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuList() {
    final items = [
      _MenuItem(Icons.palette_outlined, 'Appearance'),
      _MenuItem(Icons.smart_toy_outlined, 'Aqua Code V1'),
      _MenuItem(Icons.edit_outlined, 'Editor'),
      _MenuItem(Icons.keyboard_outlined, 'Keyboard'),
      _MenuItem(Icons.info_outline, 'About'),
    ];

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final isSelected = _selectedSection == index;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 3),
          child: InkWell(
            onTap: () => setState(() => _selectedSection = index),
            borderRadius: BorderRadius.circular(12),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary.withOpacity(0.12)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: isSelected
                    ? Border.all(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.25),
                      )
                    : null,
              ),
              child: Row(
                children: [
                  Icon(
                    item.icon,
                    size: 18,
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).iconTheme.color,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    item.title,
                    style: GoogleFonts.nunitoSans(
                      fontSize: 13,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent() {
    return ListView(
      padding: const EdgeInsets.all(36),
      children: [
        if (_selectedSection == 0) _buildAppearanceSection(),
        if (_selectedSection == 1) _buildAiSection(),
        if (_selectedSection == 2) _buildEditorSection(),
        if (_selectedSection == 3) _buildKeyboardSection(),
        if (_selectedSection == 4) _buildAboutSection(),
      ],
    );
  }

  Widget _buildAppearanceSection() {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Theme'),
            const SizedBox(height: 16),
            _buildThemeCard('Dark', 'Deep navy with cyan accents', ThemeType.dark, themeProvider, const Color(0xFF0F0F23)),
            const SizedBox(height: 12),
            _buildThemeCard('Aqua', 'Light blue with water vibes', ThemeType.aqua, themeProvider, const Color(0xFFF0F9FF)),
            const SizedBox(height: 12),
            _buildThemeCard('White', 'Clean and minimal', ThemeType.white, themeProvider, const Color(0xFFFFFFFF)),
            const SizedBox(height: 36),
            _buildSectionTitle('Font Size'),
            const SizedBox(height: 12),
            _buildSliderTile('Editor Font', '14', 12, 20),
            const SizedBox(height: 36),
            _buildSectionTitle('UI Scale'),
            const SizedBox(height: 12),
            _buildSliderTile('Interface Scale', '100%', 80, 150),
          ],
        );
      },
    );
  }

  Widget _buildThemeCard(String name, String desc, ThemeType theme, ThemeProvider provider, Color previewColor) {
    final isSelected = provider.currentTheme == theme;
    return InkWell(
      onTap: () => provider.setTheme(theme),
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outline.withOpacity(0.15),
            width: isSelected ? 2 : 1,
          ),
          color: isSelected
              ? Theme.of(context).colorScheme.primary.withOpacity(0.05)
              : null,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: previewColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.15),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: GoogleFonts.nunitoSans(
                          fontSize: 15, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 3),
                  Text(desc,
                      style: GoogleFonts.nunitoSans(
                          fontSize: 12,
                          color: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.color
                              ?.withOpacity(0.5))),
                ],
              ),
            ),
            if (isSelected)
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, size: 14, color: Colors.white),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAiSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Aqua Code V1'),
        const SizedBox(height: 8),
        Text(
          'Configure your AI coding assistant',
          style: GoogleFonts.nunitoSans(
            fontSize: 13,
            color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.5),
          ),
        ),
        const SizedBox(height: 28),
        _buildSettingTile('Model', 'Aqua Code V1 (Latest)'),
        const SizedBox(height: 12),
        _buildSettingTile('Temperature', '0.7'),
        const SizedBox(height: 12),
        _buildSettingTile('Max Tokens', '4096'),
        const SizedBox(height: 12),
        _buildSettingTile('Context Window', '128K'),
        const SizedBox(height: 28),
        _buildSectionTitle('Features'),
        const SizedBox(height: 12),
        _buildSwitchTile('Code Completion', true),
        const SizedBox(height: 8),
        _buildSwitchTile('Error Explanation', true),
        const SizedBox(height: 8),
        _buildSwitchTile('Code Refactoring', true),
        const SizedBox(height: 8),
        _buildSwitchTile('Auto Documentation', false),
      ],
    );
  }

  Widget _buildEditorSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Editor'),
        const SizedBox(height: 16),
        _buildSettingTile('Font Family', 'Fira Code'),
        const SizedBox(height: 12),
        _buildSettingTile('Tab Size', '2 Spaces'),
        const SizedBox(height: 12),
        _buildSettingTile('Line Height', '1.5'),
        const SizedBox(height: 28),
        _buildSectionTitle('Behavior'),
        const SizedBox(height: 12),
        _buildSwitchTile('Auto Save', true),
        const SizedBox(height: 8),
        _buildSwitchTile('Word Wrap', true),
        const SizedBox(height: 8),
        _buildSwitchTile('Minimap', true),
        const SizedBox(height: 8),
        _buildSwitchTile('Bracket Matching', true),
        const SizedBox(height: 8),
        _buildSwitchTile('Auto Indent', true),
      ],
    );
  }

  Widget _buildKeyboardSection() {
    final shortcuts = [
      ['Ctrl+N', 'New File'],
      ['Ctrl+Shift+N', 'New Folder'],
      ['Ctrl+S', 'Save'],
      ['Ctrl+Z', 'Undo'],
      ['Ctrl+Shift+Z', 'Redo'],
      ['Ctrl+/', 'Toggle Comment'],
      ['Ctrl+D', 'Select Next'],
      ['Ctrl+Shift+F', 'Find in Files'],
      ['F12', 'Go to Definition'],
      ['Ctrl+Space', 'Suggestions'],
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Keyboard Shortcuts'),
        const SizedBox(height: 16),
        ...shortcuts.map((s) => _buildShortcutRow(s[0], s[1])),
      ],
    );
  }

  Widget _buildShortcutRow(String key, String action) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary.withOpacity(0.15),
                  Theme.of(context).colorScheme.primary.withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
              ),
            ),
            child: Text(
              key,
              style: GoogleFonts.firaCode(
                fontSize: 11,
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Text(action, style: GoogleFonts.nunitoSans(fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildAboutSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary.withOpacity(0.15),
                  Theme.of(context).colorScheme.secondary.withOpacity(0.08),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  blurRadius: 40,
                  spreadRadius: 10,
                ),
              ],
            ),
            child: Icon(
              Icons.code,
              size: 72,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
            ),
          ),
        ),
        const SizedBox(height: 28),
        Center(
          child: Text(
            'AQUA CODE V1',
            style: GoogleFonts.orbitron(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.primary,
              letterSpacing: 4,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Center(
          child: Text(
            'AI-Powered Development Environment',
            style: GoogleFonts.nunitoSans(
              fontSize: 14,
              color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.5),
            ),
          ),
        ),
        const SizedBox(height: 36),
        _buildSettingTile('Version', '1.0.0'),
        const SizedBox(height: 12),
        _buildSettingTile('Flutter', '3.24.0'),
        const SizedBox(height: 12),
        _buildSettingTile('Dart', '3.5.0'),
        const SizedBox(height: 12),
        _buildSettingTile('Platform', 'Windows'),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.orbitron(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: Theme.of(context).colorScheme.primary,
        letterSpacing: 1.5,
      ),
    );
  }

  Widget _buildSettingTile(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.nunitoSans(fontSize: 13)),
          Text(
            value,
            style: GoogleFonts.nunitoSans(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile(String label, bool value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.nunitoSans(fontSize: 13)),
          Switch(value: value, onChanged: (_) {}),
        ],
      ),
    );
  }

  Widget _buildSliderTile(String label, String value, double min, double max) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: GoogleFonts.nunitoSans(fontSize: 13)),
              Text(
                value,
                style: GoogleFonts.nunitoSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
          Slider(value: min + (max - min) / 2, min: min, max: max, onChanged: (_) {}),
        ],
      ),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String title;
  _MenuItem(this.icon, this.title);
}
