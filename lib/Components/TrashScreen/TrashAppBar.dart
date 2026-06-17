import 'package:flutter/material.dart';

class TrashAppBar extends StatelessWidget {
  final int count;
  final VoidCallback onBack;
  final VoidCallback onClear;

  const TrashAppBar({
    super.key,
    required this.count,
    required this.onBack,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    const Color highlightColor = Color(0xFFBE9375); // Warm beige/brown

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: onBack,
                icon: const Icon(
                  Icons.arrow_back,
                  color: highlightColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              const Text(
                "Trash",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 10),
              // Count Badge Pill
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF2E2724), // Dark warm brown pill
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  count.toString(),
                  style: const TextStyle(
                    color: highlightColor,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          TextButton(
            onPressed: onClear,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text(
              "Clear",
              style: TextStyle(
                color: highlightColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
