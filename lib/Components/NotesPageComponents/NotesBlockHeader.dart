import 'package:flutter/material.dart';

class NotesBlockHeader extends StatelessWidget {
  final String title;
  final int count;
  final bool isExpanded;
  final VoidCallback onTap;
  final VoidCallback? onMenuPressed;

  const NotesBlockHeader({
    super.key,
    required this.title,
    required this.count,
    required this.isExpanded,
    required this.onTap,
    this.onMenuPressed,
  });

  @override
  Widget build(BuildContext context) {
    final bool isOthers = title.toUpperCase() == "OTHERS";
    final Color headerColor = isOthers ? const Color(0xFFD48A5E) : const Color(0xFF29B6F6);

    return InkWell(
      onTap: onTap,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  "${title.toUpperCase()} ($count)",
                  style: TextStyle(
                    color: headerColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                if (onMenuPressed != null) ...[
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: const Icon(Icons.more_vert, color: Colors.grey, size: 20),
                    onPressed: onMenuPressed,
                  ),
                  const SizedBox(width: 8),
                ],
                Icon(
                  isExpanded ? Icons.keyboard_arrow_down : Icons.chevron_right,
                  color: headerColor,
                  size: 22,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
