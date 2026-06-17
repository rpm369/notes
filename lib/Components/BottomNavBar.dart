// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTapTab;
  final VoidCallback onTapAdd;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTapTab,
    required this.onTapAdd,
  });

  @override
  Widget build(BuildContext context) {
    const Color activeColor = Color(0xFFBE9375); // Beige active tab
    const Color inactiveColor = Colors.grey;

    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1B1A), // Dark warm brown-black bottom bar
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Notes Navigation Tab
          Expanded(
            child: InkWell(
              onTap: () => onTapTab(0),
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    currentIndex == 0 ? Icons.assignment : Icons.assignment_outlined,
                    color: currentIndex == 0 ? activeColor : inactiveColor,
                    size: 24,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Notes",
                    style: TextStyle(
                      color: currentIndex == 0 ? activeColor : inactiveColor,
                      fontSize: 12,
                      fontWeight: currentIndex == 0 ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Central FAB addition button
          GestureDetector(
            onTap: onTapAdd,
            child: Container(
              width: 52,
              height: 52,
              decoration: const BoxDecoration(
                color: Color(0xFFBE9375), // Beige color
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.add,
                color: Colors.black,
                size: 28,
              ),
            ),
          ),

          // Lists Navigation Tab
          Expanded(
            child: InkWell(
              onTap: () => onTapTab(1),
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    currentIndex == 1 ? Icons.assignment_turned_in : Icons.assignment_turned_in_outlined,
                    color: currentIndex == 1 ? activeColor : inactiveColor,
                    size: 24,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Lists",
                    style: TextStyle(
                      color: currentIndex == 1 ? activeColor : inactiveColor,
                      fontSize: 12,
                      fontWeight: currentIndex == 1 ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
