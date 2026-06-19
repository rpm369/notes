import 'package:flutter/material.dart';

class ReminderCheckDialog extends StatelessWidget {
  final String noteTitle;
  final DateTime reminderTime;
  final VoidCallback onCancel;
  final VoidCallback onBackPress;

  const ReminderCheckDialog({
    super.key,
    required this.noteTitle,
    required this.reminderTime,
    required this.onCancel,
    required this.onBackPress,
  });

  String _formatReminderDate(DateTime dateTime) {
    final months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December",
    ];
    final day = dateTime.day;
    final month = months[dateTime.month - 1];
    final year = dateTime.year;

    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');

    return "$day $month $year at $hour:$minute";
  }

  @override
  Widget build(BuildContext context) {
    const Color highlightColor = Color(0xFFBE9375); // Warm beige
    const Color innerBoxColor = Color(0xFF38302B); // Dark brown interior box

    return AlertDialog(
      backgroundColor: const Color(0xFF231F1D), // Dark dialog background
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: const BorderSide(color: Color(0xFF2E2724), width: 1),
      ),
      titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
      actionsPadding: const EdgeInsets.fromLTRB(16, 16, 24, 20),
      title: Row(
        spacing: 10,
        children: [
          IconButton(
            onPressed: onBackPress,
            icon: Icon(
              Icons.arrow_back_ios_new_outlined,
              color: Colors.white,
              size: 30,
            ),
          ),
          const Text(
            "Review Reminder",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Reminder for note \"$noteTitle\"",
            style: const TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: innerBoxColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.notifications_active,
                  color: highlightColor,
                  size: 32,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Reminder:",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatReminderDate(reminderTime),
                        style: const TextStyle(
                          color: highlightColor,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: onCancel,
          child: const Text(
            "Cancel Reminder",
            style: TextStyle(
              color: highlightColor,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
