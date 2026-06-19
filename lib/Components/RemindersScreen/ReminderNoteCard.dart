import 'package:flutter/material.dart';
import 'package:notes/Models/NotesModel.dart';
import 'package:notes/ViewModels/NotesPageViewModel.dart';
import 'package:provider/provider.dart';

class ReminderNoteCard extends StatelessWidget {
  final NotesModel note;
  final VoidCallback onCancel;

  const ReminderNoteCard({
    super.key,
    required this.note,
    required this.onCancel,
  });

  String _getBlockName(BuildContext context, int? blockId) {
    if (blockId == null) return "OTHERS";
    try {
      final blocks = context.read<NotesPageViewModel>().blocks;
      for (final b in blocks) {
        if (b.id == blockId) return b.title;
      }
    } catch (_) {}
    return "OTHERS";
  }

  String _formatReminderDate(DateTime dt) {
    final months = [
      "Jan", "Feb", "Mar", "Apr", "May", "Jun",
      "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ];
    final monthStr = months[dt.month - 1];
    final hour = dt.hour.toString().padLeft(2, '0');
    final minuteStr = dt.minute.toString().padLeft(2, '0');
    return "Due: ${dt.day} $monthStr, $hour:$minuteStr";
  }

  @override
  Widget build(BuildContext context) {
    final blockName = _getBlockName(context, note.blockId);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1B1A), // Dark warm card background
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF2E2724), // Subtle warm border
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            note.title ?? "Untitled",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),

          // Block Subtitle
          Text(
            blockName,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),

          // Reminder Time
          if (note.reminder != null) ...[
            Text(
              _formatReminderDate(note.reminder!),
              style: const TextStyle(
                color: Color(0xFFBE9375), // Warm beige text color for due date
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Cancel Reminder Button on the bottom right
          Align(
            alignment: Alignment.bottomRight,
            child: GestureDetector(
              onTap: onCancel,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFBE9375), // Warm beige
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  "Cancel Reminder",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
