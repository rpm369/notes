import 'package:flutter/material.dart';

class NotesDetailToolbar extends StatelessWidget {
  final bool isFormattingMode;
  final bool hasReminder;
  final bool isBold;
  final bool isItalic;
  final bool isUnderline;
  final bool isHighlighted;

  final VoidCallback onToggleFormatting;
  final VoidCallback onBoldTap;
  final VoidCallback onItalicTap;
  final VoidCallback onUnderlineTap;
  final VoidCallback onHighlightTap;
  final VoidCallback onFontTap;
  final VoidCallback onReminderTap;

  const NotesDetailToolbar({
    super.key,
    required this.hasReminder,
    required this.isFormattingMode,
    required this.isBold,
    required this.isItalic,
    required this.isUnderline,
    required this.isHighlighted,
    required this.onToggleFormatting,
    required this.onBoldTap,
    required this.onItalicTap,
    required this.onUnderlineTap,
    required this.onHighlightTap,
    required this.onFontTap,
    required this.onReminderTap,
  });

  @override
  Widget build(BuildContext context) {
    const Color buttonBgActive = Color(0xFFFFD54F); // Bright yellow highlight
    const Color buttonBgInactive = Color(0xFFBE9375); // Beige highlight
    const Color containerBg = Color(0xFF1E1B1A); // Dark toolbar background

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: containerBg,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0xFF2E2724), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(102),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: isFormattingMode
          ? _buildFormattingToolbar(buttonBgActive, buttonBgInactive)
          : _buildDefaultToolbar(),
    );
  }

  Widget _buildDefaultToolbar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(
          onPressed: onFontTap,
          icon: const Icon(Icons.format_size, color: Colors.grey, size: 24),
        ),
        IconButton(
          onPressed: onToggleFormatting,
          icon: const Icon(
            Icons.description_outlined,
            color: Colors.grey,
            size: 24,
          ),
        ),
        IconButton(
          onPressed: onReminderTap,
          icon: Icon(
            (hasReminder)
                ? Icons.notifications_on_outlined
                : Icons.notifications_none_outlined,
            color: Colors.grey,
            size: 24,
          ),
        ),
      ],
    );
  }

  Widget _buildFormattingToolbar(Color activeColor, Color inactiveColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        // Bold Button
        _buildCircularFormatBtn(
          icon: Icons.format_bold,
          isActive: isBold,
          activeBg: inactiveColor,
          onTap: onBoldTap,
        ),
        // Italic Button
        _buildCircularFormatBtn(
          icon: Icons.format_italic,
          isActive: isItalic,
          activeBg: inactiveColor,
          onTap: onItalicTap,
        ),
        // Highlight Button
        _buildCircularFormatBtn(
          icon: Icons.format_color_fill,
          isActive: isHighlighted,
          activeBg: activeColor,
          onTap: onHighlightTap,
        ),
        // Underline Button
        _buildCircularFormatBtn(
          icon: Icons.format_underlined,
          isActive: isUnderline,
          activeBg: inactiveColor,
          onTap: onUnderlineTap,
        ),
        // Close Formatting Button
        GestureDetector(
          onTap: onToggleFormatting,
          child: Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.transparent,
            ),
            child: const Icon(Icons.close, color: Colors.white, size: 22),
          ),
        ),
      ],
    );
  }

  Widget _buildCircularFormatBtn({
    required IconData icon,
    required bool isActive,
    required Color activeBg,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isActive ? activeBg : Colors.transparent,
        ),
        child: Icon(
          icon,
          color: isActive ? Colors.black : Colors.white,
          size: 22,
        ),
      ),
    );
  }
}
