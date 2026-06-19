import 'package:flutter/material.dart';
import 'package:notes/Models/NotesModel.dart';
import 'package:notes/Utils/DeltaParser.dart';

class TrashNoteCard extends StatelessWidget {
  final NotesModel note;
  final String formattedDate;
  final VoidCallback onRestore;
  final VoidCallback onDelete;

  const TrashNoteCard({
    super.key,
    required this.note,
    required this.formattedDate,
    required this.onRestore,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
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
          if (note.title != null && note.title!.isNotEmpty) ...[
            Text(
              note.title!,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
          ],
          
          // Content
          if (note.content != null && note.content!.isNotEmpty) ...[
            Text(
              DeltaParser.parseToPlainText(note.content),
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
          ],
          
          // Date
          Text(
            formattedDate,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Action Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Restore Button
              GestureDetector(
                onTap: onRestore,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFBE9375), // Beige color
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.restore_page_outlined,
                        color: Colors.black,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        "Restore",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              
              // Delete Button
              GestureDetector(
                onTap: onDelete,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF5E3530), // Dark reddish brown
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.delete_outline,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        "Delete",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
