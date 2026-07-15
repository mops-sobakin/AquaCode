import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/file_node.dart';

class Sidebar extends StatefulWidget {
  final FileSystemProvider fileSystem;

  const Sidebar({super.key, required this.fileSystem});

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
      ),
      child: Column(
        children: [
          _buildHeader(),
          _buildSearchBar(),
          Expanded(child: _buildFileTree()),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(Icons.folder_outlined,
                size: 14, color: Theme.of(context).colorScheme.primary),
          ),
          const SizedBox(width: 10),
          Text(
            'EXPLORER',
            style: GoogleFonts.nunitoSans(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.primary,
              letterSpacing: 1.5,
            ),
          ),
          const Spacer(),
          _buildHeaderAction(Icons.create_new_folder_outlined, () => _showCreateDialog(true)),
          const SizedBox(width: 4),
          _buildHeaderAction(Icons.note_add_outlined, () => _showCreateDialog(false)),
        ],
      ),
    );
  }

  Widget _buildHeaderAction(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Icon(icon, size: 16, color: Theme.of(context).iconTheme.color),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: TextField(
        controller: _searchController,
        onChanged: (v) => setState(() => _searchQuery = v),
        style: GoogleFonts.nunitoSans(fontSize: 12),
        decoration: InputDecoration(
          hintText: 'Search files...',
          prefixIcon: Icon(Icons.search, size: 14, color: Theme.of(context).iconTheme.color),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, size: 14),
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                  },
                )
              : null,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget _buildFileTree() {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 4),
      children: _buildNodeList(widget.fileSystem.root),
    );
  }

  List<Widget> _buildNodeList(FileNode node) {
    if (_searchQuery.isNotEmpty && !_matchesSearch(node)) return [];

    final sorted = List<FileNode>.from(node.children)
      ..sort((a, b) {
        if (a.isDirectory && !b.isDirectory) return -1;
        if (!a.isDirectory && b.isDirectory) return 1;
        return a.name.compareTo(b.name);
      });

    List<Widget> widgets = [];
    for (var child in sorted) {
      widgets.add(_buildNodeTile(child));
    }
    return widgets;
  }

  bool _matchesSearch(FileNode node) {
    if (node.name.toLowerCase().contains(_searchQuery.toLowerCase())) return true;
    if (node.isDirectory) {
      for (var c in node.children) {
        if (_matchesSearch(c)) return true;
      }
    }
    return false;
  }

  Widget _buildNodeTile(FileNode node) {
    final isSelected = widget.fileSystem.selectedNode == node;
    final depth = _getDepth(node);

    List<Widget> children = [];

    children.add(
      InkWell(
        onTap: () {
          if (node.isDirectory) {
            widget.fileSystem.toggleExpand(node);
          }
          widget.fileSystem.selectNode(node);
        },
        onSecondaryTapDown: (d) => _showContextMenu(d, node),
        borderRadius: BorderRadius.circular(8),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
          padding: EdgeInsets.only(
            left: 8.0 + depth * 16.0,
            right: 8,
            top: 6,
            bottom: 6,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? Theme.of(context).colorScheme.primary.withOpacity(0.12)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: isSelected
                ? Border.all(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                  )
                : null,
          ),
          child: Row(
            children: [
              if (node.isDirectory)
                AnimatedRotation(
                  turns: node.isExpanded ? 0.25 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    Icons.keyboard_arrow_right,
                    size: 16,
                    color: Theme.of(context).iconTheme.color,
                  ),
                )
              else
                const SizedBox(width: 16),
              const SizedBox(width: 2),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: node.iconColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(node.icon, size: 14, color: node.iconColor),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  node.name,
                  style: GoogleFonts.nunitoSans(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (node.isExpanded && node.isDirectory) {
      children.addAll(_buildNodeList(node));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }

  int _getDepth(FileNode node) {
    int depth = 0;
    var current = node.parent;
    while (current != null) {
      depth++;
      current = current.parent;
    }
    return depth - 1;
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildFooterAction(Icons.folder_outlined, () => _showCreateDialog(true)),
          _buildFooterAction(Icons.note_add_outlined, () => _showCreateDialog(false)),
          _buildFooterAction(Icons.refresh, () => setState(() {})),
        ],
      ),
    );
  }

  Widget _buildFooterAction(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.08),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 18, color: Theme.of(context).colorScheme.primary),
      ),
    );
  }

  void _showContextMenu(TapDownDetails details, FileNode node) {
    List<PopupMenuEntry<dynamic>> items = [];

    if (node.isDirectory) {
      items.add(PopupMenuItem(
        child: Row(
          children: [
            Icon(Icons.create_new_folder_outlined, size: 16,
                color: Theme.of(context).iconTheme.color),
            const SizedBox(width: 8),
            Text('New Folder', style: GoogleFonts.nunitoSans(fontSize: 12)),
          ],
        ),
        onTap: () => _showCreateDialog(true, parent: node),
      ));
      items.add(PopupMenuItem(
        child: Row(
          children: [
            Icon(Icons.note_add_outlined, size: 16,
                color: Theme.of(context).iconTheme.color),
            const SizedBox(width: 8),
            Text('New File', style: GoogleFonts.nunitoSans(fontSize: 12)),
          ],
        ),
        onTap: () => _showCreateDialog(false, parent: node),
      ));
      items.add(const PopupMenuDivider());
    }

    items.add(PopupMenuItem(
      child: Row(
        children: [
          Icon(Icons.edit_outlined, size: 16,
              color: Theme.of(context).iconTheme.color),
          const SizedBox(width: 8),
          Text('Rename', style: GoogleFonts.nunitoSans(fontSize: 12)),
        ],
      ),
      onTap: () => _showRenameDialog(node),
    ));

    items.add(PopupMenuItem(
      child: Row(
        children: [
          Icon(Icons.content_copy_outlined, size: 16,
              color: Theme.of(context).iconTheme.color),
          const SizedBox(width: 8),
          Text('Copy Path', style: GoogleFonts.nunitoSans(fontSize: 12)),
        ],
      ),
      onTap: () {
        Clipboard.setData(ClipboardData(text: node.path));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Copied: ${node.path}')),
        );
      },
    ));

    items.add(const PopupMenuDivider());

    items.add(PopupMenuItem(
      child: Row(
        children: [
          const Icon(Icons.delete_outline, size: 16, color: Colors.redAccent),
          const SizedBox(width: 8),
          Text('Delete', style: GoogleFonts.nunitoSans(fontSize: 12, color: Colors.redAccent)),
        ],
      ),
      onTap: () => _showDeleteDialog(node),
    ));

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        details.globalPosition.dx,
        details.globalPosition.dy,
        details.globalPosition.dx + 1,
        details.globalPosition.dy + 1,
      ),
      items: items,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  void _showCreateDialog(bool isFolder, {FileNode? parent}) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isFolder ? 'New Folder' : 'New File'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(
            hintText: isFolder ? 'folder_name' : 'file_name.dart',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                final target = parent ?? widget.fileSystem.root;
                if (isFolder) {
                  widget.fileSystem.createFolder(target, controller.text);
                } else {
                  widget.fileSystem.createFile(target, controller.text);
                }
                Navigator.pop(ctx);
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showRenameDialog(FileNode node) {
    final controller = TextEditingController(text: node.name);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Rename'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'New name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                widget.fileSystem.renameNode(node, controller.text);
                Navigator.pop(ctx);
              }
            },
            child: const Text('Rename'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(FileNode node) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete'),
        content: Text('Delete "${node.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              widget.fileSystem.deleteNode(node);
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
