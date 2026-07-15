import 'package:flutter/material.dart';
import 'code_block.dart';

class MessageBubble extends StatelessWidget {
  final String text;
  final bool isUser;

  const MessageBubble({
    super.key,
    required this.text,
    required this.isUser,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAvatar(context),
          const SizedBox(width: 12),
          Expanded(child: _buildContent(context)),
        ],
      ),
    );
  }

  Widget _buildAvatar(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      child: Icon(
        isUser ? Icons.person : Icons.smart_toy,
        color: Colors.white,
        size: 20,
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isUser ? 'You' : 'Ice Code V1',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 4),
        _buildMessageBody(context),
      ],
    );
  }

  Widget _buildMessageBody(BuildContext context) {
    final codeBlocks = _extractCodeBlocks(text);
    if (codeBlocks.isEmpty) {
      return Text(text);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: codeBlocks.map((block) {
        if (block['isCode'] == true) {
          return CodeBlock(
            code: block['content']!,
            language: block['language'] ?? '',
          );
        }
        return Text(block['content']!);
      }).toList(),
    );
  }

  List<Map<String, dynamic>> _extractCodeBlocks(String text) {
    final blocks = <Map<String, dynamic>>[];
    final regex = RegExp(r'```(\w+)?\n([\s\S]*?)```');
    int lastIndex = 0;

    for (final match in regex.allMatches(text)) {
      if (match.start > lastIndex) {
        blocks.add({
          'content': text.substring(lastIndex, match.start),
          'isCode': false,
        });
      }
      blocks.add({
        'content': match.group(2) ?? '',
        'isCode': true,
        'language': match.group(1) ?? '',
      });
      lastIndex = match.end;
    }

    if (lastIndex < text.length) {
      blocks.add({
        'content': text.substring(lastIndex),
        'isCode': false,
      });
    }

    return blocks;
  }
}
