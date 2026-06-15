// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class NotesSelectionBar extends StatelessWidget {
  final int selectedCount;
  final VoidCallback onClosePressed;
  final VoidCallback onMoveToBlockPressed;
  final VoidCallback onDeletePressed;

  const NotesSelectionBar({
    super.key,
    required this.selectedCount,
    required this.onClosePressed,
    required this.onMoveToBlockPressed,
    required this.onDeletePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 24,
      left: 16,
      right: 16,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B), // Dark blue slate selection bar
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: onClosePressed,
                  icon: const Icon(Icons.close, color: Colors.white),
                ),
                Text(
                  "$selectedCount selected",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                IconButton(
                  onPressed: onMoveToBlockPressed,
                  icon: const Icon(Icons.folder_shared_outlined, color: Color(0xFF29B6F6)),
                  tooltip: "Move to Block",
                ),
                IconButton(
                  onPressed: onDeletePressed,
                  icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                  tooltip: "Move to Trash",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
