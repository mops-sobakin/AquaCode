import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/file_node.dart';

class EditorArea extends StatefulWidget {
  final FileSystemProvider fileSystem;

  const EditorArea({super.key, required this.fileSystem});

  @override
  State<EditorArea> createState() => _EditorAreaState();
}

class _EditorAreaState extends State<EditorArea> {
  final List<FileNode> _openFiles = [];
  FileNode? _activeFile;
  final TextEditingController _editorController = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.fileSystem.addListener(_onFsChange);
  }

  @override
  void dispose() {
    widget.fileSystem.removeListener(_onFsChange);
    _editorController.dispose();
    super.dispose();
  }

  void _onFsChange() {
    final selected = widget.fileSystem.selectedNode;
    if (selected != null && !selected.isDirectory && !_openFiles.contains(selected)) {
      _openFile(selected);
    }
    setState(() {});
  }

  void _openFile(FileNode file) {
    _openFiles.add(file);
    _activeFile = file;
    _loadFileContent(file);
  }

  void _loadFileContent(FileNode file) {
    final ext = file.name.split('.').last;
    String content;
    switch (ext) {
      case 'dart':
        content = _sampleDartContent(file.name);
        break;
      case 'yaml':
        content = _sampleYamlContent();
        break;
      case 'md':
        content = _sampleMdContent();
        break;
      default:
        content = '// ${file.name}';
    }
    _editorController.text = content;
  }

  String _sampleDartContent(String name) {
    if (name == 'main.dart') {
      return "import 'package:flutter/material.dart';\nimport 'app.dart';\n\nvoid main() {\n  runApp(const AquaCodeApp());\n}";
    }
    if (name == 'app.dart') {
      return "import 'package:flutter/material.dart';\nimport 'package:provider/provider.dart';\nimport 'theme/theme_provider.dart';\n\nclass AquaCodeApp extends StatelessWidget {\n  const AquaCodeApp({super.key});\n\n  @override\n  Widget build(BuildContext context) {\n    return ChangeNotifierProvider(\n      create: (_) => ThemeProvider(),\n      child: Consumer<ThemeProvider>(\n        builder: (context, themeProvider, _) {\n          return MaterialApp(\n            title: 'Aqua Code V1',\n            theme: themeProvider.themeData,\n            home: const MainScreen(),\n          );\n        },\n      ),\n    );\n  }\n}";
    }
    return "// $name\nimport 'package:flutter/material.dart';";
  }

  String _sampleYamlContent() {
    return "name: aqua_code\ndescription: AI-powered IDE with Aqua Code V1\nversion: 1.0.0+1\n\nenvironment:\n  sdk: '>=3.0.0 <4.0.0'\n\ndependencies:\n  flutter:\n    sdk: flutter\n  google_fonts: ^6.1.0\n  provider: ^6.1.1";
  }

  String _sampleMdContent() {
    return "# Aqua Code V1\n\nAI-powered IDE with Aqua Code V1 integration.\n\n## Features\n\n- Three themes: Dark, Aqua, White\n- File explorer with operations\n- Code editor\n- AI chat with Aqua Code V1";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_openFiles.isNotEmpty) _buildTabs(),
        Expanded(
          child: _activeFile != null ? _buildEditor() : _buildWelcomeScreen(),
        ),
      ],
    );
  }

  Widget _buildTabs() {
    return Container(
      height: 38,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withOpacity(0.5),
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
          ),
        ),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _openFiles.length,
        itemBuilder: (context, index) {
          final file = _openFiles[index];
          final isActive = file == _activeFile;
          return InkWell(
            onTap: () {
              setState(() {
                _activeFile = file;
                _loadFileContent(file);
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: isActive
                    ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: isActive
                    ? Border.all(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                      )
                    : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(file.icon, size: 14, color: file.iconColor),
                  const SizedBox(width: 8),
                  Text(
                    file.name,
                    style: GoogleFonts.nunitoSans(
                      fontSize: 12,
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                      color: isActive
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _openFiles.removeAt(index);
                        if (_activeFile == file) {
                          _activeFile = _openFiles.isNotEmpty ? _openFiles.last : null;
                          if (_activeFile != null) _loadFileContent(_activeFile!);
                        }
                      });
                    },
                    borderRadius: BorderRadius.circular(4),
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Theme.of(context).iconTheme.color?.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Icon(Icons.close,
                          size: 10,
                          color: Theme.of(context).iconTheme.color?.withOpacity(0.5)),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEditor() {
    return Row(
      children: [
        _buildLineNumbers(),
        Expanded(
          child: Stack(
            children: [
              TextField(
                controller: _editorController,
                maxLines: null,
                expands: true,
                keyboardType: TextInputType.multiline,
                style: GoogleFonts.firaCode(
                  fontSize: 13,
                  color: Theme.of(context).colorScheme.onSurface,
                  height: 1.6,
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(20),
                ),
              ),
              Positioned(
                right: 16,
                bottom: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                    ),
                  ),
                  child: Text(
                    _activeFile?.name ?? '',
                    style: GoogleFonts.nunitoSans(
                      fontSize: 10,
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLineNumbers() {
    final lineCount = _editorController.text.split('\n').length;
    return Container(
      width: 50,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withOpacity(0.3),
        border: Border(
          right: BorderSide(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
          ),
        ),
      ),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 20),
        itemCount: lineCount,
        itemBuilder: (context, index) {
          return Container(
            height: 20.8,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 14),
            child: Text(
              '${index + 1}',
              style: GoogleFonts.firaCode(
                fontSize: 11,
                color: Theme.of(context).iconTheme.color?.withOpacity(0.4),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildWelcomeScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
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
          const SizedBox(height: 32),
          Text(
            'AQUA CODE V1',
            style: GoogleFonts.orbitron(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.primary,
              letterSpacing: 5,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'AI-Powered Development Environment',
            style: GoogleFonts.nunitoSans(
              fontSize: 15,
              color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 48),
          _buildWelcomeHint(Icons.folder_outlined, 'Open a file from the explorer'),
          const SizedBox(height: 14),
          _buildWelcomeHint(Icons.smart_toy_outlined, 'Chat with Aqua Code V1'),
          const SizedBox(height: 14),
          _buildWelcomeHint(Icons.keyboard, 'Ctrl+N: New File'),
        ],
      ),
    );
  }

  Widget _buildWelcomeHint(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Theme.of(context).colorScheme.primary.withOpacity(0.5)),
          const SizedBox(width: 10),
          Text(
            text,
            style: GoogleFonts.nunitoSans(
              fontSize: 13,
              color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }
}
