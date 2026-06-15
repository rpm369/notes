import 'package:flutter/material.dart';

class NotesAppBar extends StatelessWidget {
  final VoidCallback onSettingsPressed;

  const NotesAppBar({
    super.key,
    required this.onSettingsPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Text(
                "Notes",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(width: 6),
              GestureDetector(
                onTap: () {},
                child: const Icon(
                  Icons.arrow_drop_down,
                  color: Colors.grey,
                  size: 28,
                ),
              ),
            ],
          ),
          IconButton(
            onPressed: onSettingsPressed,
            icon: const Icon(
              Icons.settings,
              color: Colors.grey,
              size: 26,
            ),
          ),
        ],
      ),
    );
  }
}
