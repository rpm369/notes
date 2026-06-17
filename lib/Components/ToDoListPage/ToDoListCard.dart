import 'package:flutter/material.dart';
import 'package:notes/Models/ToDoListModel.dart';
import 'package:notes/Models/ToDoModel.dart';

class ToDoListCard extends StatelessWidget {
  final ToDoListModel list;
  final List<ToDoModel> toDos;
  final bool isExpanded;
  final VoidCallback onToggleExpand;
  final VoidCallback onRename;
  final VoidCallback onDelete;
  final Function(ToDoModel) onToggleCompletion;

  const ToDoListCard({
    super.key,
    required this.list,
    required this.toDos,
    required this.isExpanded,
    required this.onToggleExpand,
    required this.onRename,
    required this.onDelete,
    required this.onToggleCompletion,
  });

  @override
  Widget build(BuildContext context) {
    final int totalCount = toDos.length;
    final int completedCount = toDos.where((todo) => todo.completionStatus).length;

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
          // Header Row
          Row(
            children: [
              // Yellow dot indicator
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFFFBC02D), // Yellow dot
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              // Title and progress
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      list.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "$completedCount of $totalCount completed",
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              // Action buttons on the right
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: Icon(
                  isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  color: Colors.grey,
                  size: 24,
                ),
                onPressed: onToggleExpand,
              ),
              const SizedBox(width: 12),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(
                  Icons.edit_outlined,
                  color: Colors.grey,
                  size: 20,
                ),
                onPressed: onRename,
              ),
              const SizedBox(width: 12),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(
                  Icons.delete_outline,
                  color: Color(0xFFC39B84), // Soft delete icon color
                  size: 20,
                ),
                onPressed: onDelete,
              ),
            ],
          ),

          // Task List (visible if expanded)
          if (isExpanded) ...[
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: toDos.length,
              itemBuilder: (context, index) {
                final todo = toDos[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: InkWell(
                    onTap: () => onToggleCompletion(todo),
                    borderRadius: BorderRadius.circular(8),
                    child: Row(
                      children: [
                        // Custom Checkbox
                        Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            color: todo.completionStatus
                                ? const Color(0xFFBE9375) // Checked beige
                                : Colors.transparent,
                            border: Border.all(
                              color: todo.completionStatus
                                  ? const Color(0xFFBE9375)
                                  : Colors.grey,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: todo.completionStatus
                              ? const Icon(
                                  Icons.check,
                                  size: 16,
                                  color: Colors.black,
                                )
                              : null,
                        ),
                        const SizedBox(width: 16),
                        // Task text with optional strikethrough
                        Expanded(
                          child: Text(
                            todo.name,
                            style: TextStyle(
                              color: todo.completionStatus ? Colors.grey : Colors.white,
                              fontSize: 16,
                              decoration: todo.completionStatus
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}
