import 'package:flutter/material.dart';

class FontSelectionSheet extends StatelessWidget {
  final String selectedFontFamily;
  final ValueChanged<String> onFontSelected;

  const FontSelectionSheet({
    super.key,
    required this.selectedFontFamily,
    required this.onFontSelected,
  });

  @override
  Widget build(BuildContext context) {
    const Color highlightColor = Color(0xFFBE9375); // Warm beige/brown

    final basicFonts = {
      "Default": "",
      "Sans Serif": "sans-serif",
      "Serif": "serif",
      "Monospace": "monospace",
      "Cursive": "cursive",
    };

    final decorativeFonts = {
      "Matrix Type Display": "Courier",
      "Double Struck": "Courier New",
      "Magnetic Drawing": "cursive",
    };

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF282321), // Dark bottom sheet background
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Font Selection",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Colors.white70),
                  ),
                ],
              ),
            ),
            const Divider(color: Color(0xFF383331), thickness: 1),

            // Scrollable Content
            Flexible(
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                children: [
                  // Basic section
                  const Text(
                    "Basic",
                    style: TextStyle(
                      color: highlightColor,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...basicFonts.entries.map((e) => _buildFontTile(
                        context,
                        title: e.key,
                        fontFamily: e.value,
                        isSelected: selectedFontFamily == e.value,
                      )),

                  const SizedBox(height: 20),

                  // Decorative section
                  const Text(
                    "Decorative",
                    style: TextStyle(
                      color: highlightColor,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...decorativeFonts.entries.map((e) => _buildFontTile(
                        context,
                        title: e.key,
                        fontFamily: e.value,
                        isSelected: selectedFontFamily == e.value,
                      )),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFontTile(
    BuildContext context, {
    required String title,
    required String fontFamily,
    required bool isSelected,
  }) {
    const Color highlightColor = Color(0xFFBE9375);

    return InkWell(
      onTap: () {
        onFontSelected(fontFamily);
        Navigator.pop(context);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF383331) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? highlightColor : Colors.transparent,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: fontFamily.isNotEmpty ? fontFamily : null,
              ),
            ),
            if (isSelected)
              const Icon(Icons.check, color: highlightColor, size: 20),
          ],
        ),
      ),
    );
  }
}
