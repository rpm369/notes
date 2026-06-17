import 'package:flutter/material.dart';

class NotesAppBar extends StatelessWidget {
  final VoidCallback onSettingsPressed;

  const NotesAppBar({super.key, required this.onSettingsPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const IconButton(
                onPressed: null,
                icon: Icon(
                  Icons.delete_sweep_sharp,
                  color: Colors.white,
                  size: 25,
                ),
              ),
              const IconButton(
                onPressed: null,
                icon: Icon(
                  Icons.schedule_rounded,
                  color: Colors.white,
                  size: 25,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
