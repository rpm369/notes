import 'package:flutter/material.dart';
import 'package:notes/Models/BlockModel.dart';

class NotesDetailAppBar extends StatelessWidget {
  final int? currentBlockId;
  final List<BlockModel> blocks;
  final VoidCallback onBack;
  final VoidCallback onSave;
  final ValueChanged<int?> onBlockChanged;

  const NotesDetailAppBar({
    super.key,
    required this.currentBlockId,
    required this.blocks,
    required this.onBack,
    required this.onSave,
    required this.onBlockChanged,
  });

  @override
  Widget build(BuildContext context) {
    const Color highlightColor = Color(0xFFBE9375); // Warm beige/brown

    // Find the current block title
    String currentBlockTitle = "Main";
    if (currentBlockId != null) {
      final matchedBlock = blocks.where((b) => b.id == currentBlockId);
      if (matchedBlock.isNotEmpty) {
        currentBlockTitle = matchedBlock.first.title;
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back Button
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back, color: Colors.grey, size: 26),
          ),

          // Dropdown Block Selector
          Theme(
            data: Theme.of(
              context,
            ).copyWith(cardColor: const Color(0xFF282321)),
            child: PopupMenuButton<int?>(
              color: const Color(0xFF282321),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: Color(0xFF383331), width: 1),
              ),
              offset: const Offset(0, 45),
              onSelected: onBlockChanged,
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem<int?>(
                    value: null,
                    child: Row(
                      children: [
                        const Icon(
                          Icons.description,
                          color: Colors.grey,
                          size: 18,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "Main",
                          style: TextStyle(
                            color: currentBlockId == null
                                ? highlightColor
                                : Colors.white,
                            fontSize: 15,
                          ),
                        ),
                        if (currentBlockId == null) ...[
                          const Spacer(),
                          const Icon(
                            Icons.check,
                            color: highlightColor,
                            size: 18,
                          ),
                        ],
                      ],
                    ),
                  ),
                  ...blocks.map((block) {
                    final isSelected = block.id == currentBlockId;
                    return PopupMenuItem<int?>(
                      value: block.id,
                      child: Row(
                        children: [
                          const Icon(
                            Icons.folder,
                            color: Colors.grey,
                            size: 18,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            block.title,
                            style: TextStyle(
                              color: isSelected ? highlightColor : Colors.white,
                              fontSize: 15,
                            ),
                          ),
                          if (isSelected) ...[
                            const Spacer(),
                            const Icon(
                              Icons.check,
                              color: highlightColor,
                              size: 18,
                            ),
                          ],
                        ],
                      ),
                    );
                  }),
                ];
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1B1A),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF2E2724), width: 1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.folder, color: highlightColor, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      currentBlockTitle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.arrow_drop_down,
                      color: Colors.grey,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Checkmark Save Button
          GestureDetector(
            onTap: onSave,
            child: Container(
              width: 38,
              height: 38,
              decoration: const BoxDecoration(
                color: highlightColor,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: Colors.black, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}
