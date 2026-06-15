import 'package:flutter/material.dart';

class NotesSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const NotesSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF231F1D), // Dark grey-brown search bar background
          borderRadius: BorderRadius.circular(14),
        ),
        child: TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white, fontSize: 16),
          cursorColor: const Color(0xFF29B6F6),
          onChanged: onChanged,
          decoration: const InputDecoration(
            hintText: "Search notes...",
            hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
            prefixIcon: Icon(Icons.search, color: Colors.grey, size: 22),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ),
    );
  }
}
