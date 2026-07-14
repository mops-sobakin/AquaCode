import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/file_node.dart';
import '../widgets/sidebar.dart';
import '../widgets/editor_area.dart';
import '../widgets/ai_chat_panel.dart';
import 'settings_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  final FileSystemProvider _fileSystem = FileSystemProvider();
  bool _showSidebar = true;
  bool _showAiPanel = true;
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          _buildTitleBar(),
          Expanded(
            child: Row(
              children: [
                _buildActivityBar(),
                if (_showSidebar) Sidebar(fileSystem: _fileSystem),
                const VerticalDivider(width: 1, thickness: 1),
                Expanded(child: EditorArea(fileSystem: _fileSystem)),
                if (_showAiPanel) ...[
                  const VerticalDivider(width: 1, thickness: 1),
                  const AiChatPanel(),
                ],
              ],
            ),
          ),
          _buildStatusBar(),
        ],
      ),
    );
  }

  Widget _buildTitleBar() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.surface,
            Theme.of(context).colorScheme.surface.withOpacity(0.8),
          ],
        ),
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.15),
          ),
        ),
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.secondary,
                ],
              ),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              'AQUA CODE',
              style: GoogleFonts.orbitron(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: 2.5,
              ),
            ),
          ),
          const SizedBox(width: 20),
          _buildMenuButton('File'),
          _buildMenuButton('Edit'),
          _buildMenuButton('View'),
          _buildMenuButton('Run'),
          _buildMenuButton('Help'),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'V1.0',
              style: GoogleFonts.orbitron(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.primary,
                letterSpacing: 1,
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
    );
  }

  Widget _buildMenuButton(String title) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Text(
          title,
          style: GoogleFonts.nunitoSans(
            color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildActivityBar() {
    return Container(
      width: 52,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withOpacity(0.5),
        border: Border(
          right: BorderSide(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
          ),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          _buildActivityIcon(Icons.folder_outlined, 0),
          _buildActivityIcon(Icons.search, 1),
          _buildActivityIcon(Icons.smart_toy_outlined, 2),
          _buildActivityIcon(Icons.extension_outlined, 3),
          const Spacer(),
          _buildActivityIcon(Icons.settings_outlined, 4),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildActivityIcon(IconData icon, int index) {
    final isSelected = _selectedIndex == index;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Tooltip(
        message: ['Explorer', 'Search', 'AI', 'Extensions', 'Settings'][index],
        child: InkWell(
          onTap: () {
            setState(() {
              _selectedIndex = index;
              if (index == 0) _showSidebar = !_showSidebar;
              if (index == 2) _showAiPanel = !_showAiPanel;
              if (index == 4) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsScreen()),
                );
              }
            });
          },
          borderRadius: BorderRadius.circular(12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary.withOpacity(0.15)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: isSelected
                  ? Border.all(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                    )
                  : null,
            ),
            child: Icon(
              icon,
              size: 20,
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).iconTheme.color,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBar() {
    return Container(
      height: 28,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.secondary,
          ],
        ),
      ),
      child: Row(
        children: [
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              'AQUA CODE V1',
              style: GoogleFonts.orbitron(
                fontSize: 9,
                color: Colors.white,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Ready',
            style: TextStyle(
              fontSize: 11,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          const Spacer(),
          _buildStatusItem('UTF-8'),
          _buildStatusItem('Dart'),
          _buildStatusItem('Windows'),
          const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _buildStatusItem(String text) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          color: Colors.white.withOpacity(0.85),
        ),
      ),
    );
  }
}
