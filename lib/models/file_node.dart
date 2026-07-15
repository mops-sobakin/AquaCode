import 'package:flutter/material.dart';

class FileNode {
  String name;
  bool isDirectory;
  List<FileNode> children;
  bool isExpanded;
  FileNode? parent;

  FileNode({
    required this.name,
    this.isDirectory = false,
    List<FileNode>? children,
    this.isExpanded = false,
    this.parent,
  }) : children = children ?? [];

  String get path {
    if (parent == null) return name;
    return '${parent!.path}/$name';
  }

  IconData get icon {
    if (isDirectory) {
      return isExpanded ? Icons.folder_open : Icons.folder;
    }
    switch (name.split('.').last) {
      case 'dart':
        return Icons.code;
      case 'yaml':
        return Icons.settings;
      case 'json':
        return Icons.data_object;
      case 'md':
        return Icons.description;
      case 'txt':
        return Icons.article;
      default:
        return Icons.insert_drive_file;
    }
  }

  Color get iconColor {
    if (isDirectory) return const Color(0xFFFFCA28);
    switch (name.split('.').last) {
      case 'dart':
        return const Color(0xFF00BCD4);
      case 'yaml':
        return const Color(0xFFE91E63);
      case 'json':
        return const Color(0xFF4CAF50);
      case 'md':
        return const Color(0xFF9C27B0);
      default:
        return const Color(0xFF78909C);
    }
  }
}

class FileSystemProvider extends ChangeNotifier {
  final FileNode root;
  FileNode? selectedNode;

  FileSystemProvider()
      : root = FileNode(name: 'aqua_code', isDirectory: true, children: [
          FileNode(name: 'lib', isDirectory: true, children: [
            FileNode(name: 'main.dart'),
            FileNode(name: 'app.dart'),
            FileNode(name: 'screens', isDirectory: true, children: [
              FileNode(name: 'main_screen.dart'),
              FileNode(name: 'settings_screen.dart'),
            ]),
            FileNode(name: 'widgets', isDirectory: true, children: [
              FileNode(name: 'sidebar.dart'),
              FileNode(name: 'editor_area.dart'),
              FileNode(name: 'ai_chat_panel.dart'),
            ]),
            FileNode(name: 'theme', isDirectory: true, children: [
              FileNode(name: 'app_theme.dart'),
              FileNode(name: 'theme_provider.dart'),
            ]),
          ]),
          FileNode(name: 'test', isDirectory: true, children: [
            FileNode(name: 'widget_test.dart'),
          ]),
          FileNode(name: 'pubspec.yaml'),
          FileNode(name: 'README.md'),
        ]) {
    _setParent(root, null);
  }

  void _setParent(FileNode node, FileNode? parent) {
    node.parent = parent;
    for (var child in node.children) {
      _setParent(child, node);
    }
  }

  void selectNode(FileNode node) {
    selectedNode = node;
    notifyListeners();
  }

  void toggleExpand(FileNode node) {
    node.isExpanded = !node.isExpanded;
    notifyListeners();
  }

  void createFile(FileNode parent, String name) {
    if (!parent.isDirectory) return;
    parent.children.add(FileNode(name: name, parent: parent));
    parent.isExpanded = true;
    notifyListeners();
  }

  void createFolder(FileNode parent, String name) {
    if (!parent.isDirectory) return;
    parent.children
        .add(FileNode(name: name, isDirectory: true, parent: parent));
    parent.isExpanded = true;
    notifyListeners();
  }

  void renameNode(FileNode node, String newName) {
    node.name = newName;
    notifyListeners();
  }

  void deleteNode(FileNode node) {
    if (node.parent == null) return;
    node.parent!.children.remove(node);
    if (selectedNode == node) selectedNode = null;
    notifyListeners();
  }

  List<FileNode> _flatten(FileNode node) {
    var list = <FileNode>[node];
    for (var child in node.children) {
      list.addAll(_flatten(child));
    }
    return list;
  }

  List<FileNode> get allNodes => _flatten(root);
}
