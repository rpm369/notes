// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class NotesBottomPanel extends StatelessWidget {
  final bool isExpanded;
  final VoidCallback onToggleExpand;
  final VoidCallback onCreateBlockPressed;
  final VoidCallback onCreateListPressed;

  const NotesBottomPanel({
    super.key,
    required this.isExpanded,
    required this.onToggleExpand,
    required this.onCreateBlockPressed,
    required this.onCreateListPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      bottom: 24,
      right: isExpanded ? 16 : 24,
      left: isExpanded ? 16 : null,
      child: AnimatedCrossFade(
        firstChild: FloatingActionButton(
          backgroundColor: const Color(0xFF2E2724), // Match expanded bar color
          shape: const CircleBorder(),
          elevation: 6,
          onPressed: onToggleExpand,
          child: const Icon(Icons.add, color: Colors.white, size: 28),
        ),
        secondChild: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF282321), // Dark brown-grey warm panel
            borderRadius: BorderRadius.circular(32),
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
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 8),
                      _buildPanelButton(
                        icon: Icons.create_new_folder_outlined,
                        label: "Block",
                        onTap: onCreateBlockPressed,
                      ),
                      const SizedBox(width: 24),
                      _buildPanelButton(
                        icon: Icons.playlist_add_check_outlined,
                        label: "List",
                        onTap: onCreateListPressed,
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: onToggleExpand,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: Color(0xFF483D39), // Darker grey circle background
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, color: Colors.white, size: 20),
                ),
              ),
            ],
          ),
        ),
        crossFadeState: isExpanded
            ? CrossFadeState.showSecond
            : CrossFadeState.showFirst,
        duration: const Duration(milliseconds: 200),
      ),
    );
  }

  Widget _buildPanelButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.grey.shade400, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
