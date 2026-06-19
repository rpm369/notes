// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:notes/Models/NotesModel.dart';
import 'package:provider/provider.dart';
import 'package:notes/ViewModels/NotesPageViewModel.dart';
import 'package:notes/Models/BlockModel.dart';
import 'package:notes/Screens/TrashView.dart';
import 'package:notes/Screens/NotesDetailView.dart';

// Import modular subcomponents
import 'package:notes/Components/NotesPageComponents/NotesAppBar.dart';
import 'package:notes/Components/NotesPageComponents/NotesSearchBar.dart';
import 'package:notes/Components/NotesPageComponents/NotesBlockHeader.dart';
import 'package:notes/Components/NotesPageComponents/NoteCard.dart';
import 'package:notes/Components/NotesPageComponents/NotesSelectionBar.dart';

class NotesPageView extends StatefulWidget {
  const NotesPageView({super.key});

  @override
  State<NotesPageView> createState() => _NotesPageViewState();
}

class _NotesPageViewState extends State<NotesPageView> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSelectionMode = false;
  final Set<int> _selectedNoteIds = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotesPageViewModel>().loadData();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _formatNoteDate(DateTime dt) {
    final now = DateTime.now();
    final difference = now.difference(dt);

    if (difference.inSeconds < 60) {
      return "edited just now";
    } else if (difference.inMinutes < 60) {
      final mins = difference.inMinutes;
      return "edited $mins minute${mins == 1 ? '' : 's'} ago";
    } else if (difference.inHours < 24 && dt.day == now.day) {
      final hrs = difference.inHours;
      return "edited $hrs hour${hrs == 1 ? '' : 's'} ago";
    } else {
      final months = [
        "Jan",
        "Feb",
        "Mar",
        "Apr",
        "May",
        "Jun",
        "Jul",
        "Aug",
        "Sep",
        "Oct",
        "Nov",
        "Dec",
      ];
      final monthStr = months[dt.month - 1];
      final hour = dt.hour == 0 ? 12 : (dt.hour > 12 ? dt.hour - 12 : dt.hour);
      final minuteStr = dt.minute.toString().padLeft(2, '0');
      final ampm = dt.hour >= 12 ? 'PM' : 'AM';
      return "${dt.day} $monthStr • $hour:$minuteStr $ampm";
    }
  }

  void _toggleSelection(int noteId) {
    setState(() {
      if (_selectedNoteIds.contains(noteId)) {
        _selectedNoteIds.remove(noteId);
        if (_selectedNoteIds.isEmpty) {
          _isSelectionMode = false;
        }
      } else {
        _selectedNoteIds.add(noteId);
        _isSelectionMode = true;
      }
    });
  }

  void _clearSelection() {
    setState(() {
      _selectedNoteIds.clear();
      _isSelectionMode = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<NotesPageViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFF131110),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NotesAppBar(
                  onTrashPressed: () async {
                    await Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => const TrashView(),
                      ),
                    );
                    await viewModel.loadData();
                  },
                ),
                NotesSearchBar(
                  controller: _searchController,
                  onChanged: (val) {
                    viewModel.updateSearchQuery(query: val);
                  },
                ),
                Expanded(
                  child: viewModel.isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF29B6F6),
                          ),
                        )
                      : viewModel.errorMessage.isNotEmpty
                      ? Center(
                          child: Text(
                            viewModel.errorMessage,
                            style: const TextStyle(color: Colors.red),
                          ),
                        )
                      : _buildBlocksList(viewModel),
                ),
              ],
            ),

            if (_isSelectionMode)
              NotesSelectionBar(
                selectedCount: _selectedNoteIds.length,
                onClosePressed: _clearSelection,
                onMoveToBlockPressed: () {
                  _showMoveToBlockDialog(viewModel);
                },
                onDeletePressed: () async {
                  await viewModel.moveNotesToTrash(
                    noteIds: _selectedNoteIds.toList(),
                  );
                  _clearSelection();
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Moved to Trash")),
                    );
                  }
                },
              ),

            // NotesBottomPanel has been moved to HomeScreen's unified bottom navigation bar.
          ],
        ),
      ),
    );
  }

  Widget _buildBlocksList(NotesPageViewModel viewModel) {
    final blocks = viewModel.blocks;
    final otherNotes = viewModel.notesByBlock[null] ?? [];

    // Render database blocks, followed by the hardcoded default "OTHERS" block.
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
      itemCount: blocks.length + 1,
      itemBuilder: (context, index) {
        final bool isOthers = index == blocks.length;
        final String title = isOthers ? "OTHERS" : blocks[index].title;
        final int? blockId = isOthers ? null : blocks[index].id;
        final List<NotesModel> notes = isOthers
            ? otherNotes
            : (viewModel.notesByBlock[blockId] ?? []);
        final isExpanded = viewModel.isExpanded(blockId: blockId);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NotesBlockHeader(
              title: title,
              count: notes.length,
              isExpanded: isExpanded,
              onTap: () {
                viewModel.toggleBlockExpansion(blockId: blockId);
              },
              onMenuPressed: isOthers
                  ? null
                  : () {
                      _showBlockMenu(viewModel, blocks[index]);
                    },
            ),
            const SizedBox(height: 10),
            if (isExpanded) ...[
              if (notes.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(left: 8.0, bottom: 20.0),
                  child: Text(
                    "Empty block",
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                )
              else
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: notes.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.1,
                  ),
                  itemBuilder: (context, noteIndex) {
                    final note = notes[noteIndex];
                    final isSelected = _selectedNoteIds.contains(note.id);
                    return NoteCard(
                      note: note,
                      formattedDate: _formatNoteDate(note.updatedAt),
                      isSelected: isSelected,
                      onTap: () async {
                        if (_isSelectionMode) {
                          _toggleSelection(note.id!);
                        } else {
                          final result = await Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => NotesDetailView(existingNote: note),
                            ),
                          );
                          if (result == true) {
                            viewModel.loadData();
                          }
                        }
                      },
                      onLongPress: () {
                        _toggleSelection(note.id!);
                      },
                    );
                  },
                ),
              const SizedBox(height: 24),
            ],
          ],
        );
      },
    );
  }

  void _showBlockMenu(NotesPageViewModel viewModel, BlockModel block) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF282321),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit, color: Colors.white),
                title: const Text(
                  "Rename Block",
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showRenameBlockDialog(viewModel, block);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.delete_sweep,
                  color: Colors.redAccent,
                ),
                title: const Text(
                  "Delete Block & Notes",
                  style: TextStyle(color: Colors.redAccent),
                ),
                onTap: () async {
                  Navigator.pop(context);
                  await viewModel.deleteBlockWithNotes(blockId: block.id!);
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Block and notes deleted")),
                    );
                  }
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.delete_outline,
                  color: Colors.orangeAccent,
                ),
                title: const Text(
                  "Delete Block, Keep Notes",
                  style: TextStyle(color: Colors.orangeAccent),
                ),
                onTap: () async {
                  Navigator.pop(context);
                  await viewModel.deleteBlockWithoutNotes(blockId: block.id!);
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Block deleted; notes moved to Uncategorized",
                        ),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showRenameBlockDialog(NotesPageViewModel viewModel, BlockModel block) {
    final controller = TextEditingController(text: block.title);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF282321),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            "Rename Block",
            style: TextStyle(color: Colors.white),
          ),
          content: TextField(
            controller: controller,
            autofocus: true,
            style: const TextStyle(color: Colors.white),
            cursorColor: const Color(0xFF29B6F6),
            decoration: const InputDecoration(
              hintText: "Enter new title...",
              hintStyle: TextStyle(color: Colors.grey),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF29B6F6)),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF29B6F6),
              ),
              onPressed: () async {
                if (controller.text.trim().isNotEmpty) {
                  await viewModel.renameBlock(
                    blockId: block.id!,
                    newTitle: controller.text.trim(),
                  );
                  Navigator.pop(context);
                }
              },
              child: const Text(
                "Rename",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showMoveToBlockDialog(NotesPageViewModel viewModel) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF282321),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            "Select Destination Block",
            style: TextStyle(color: Colors.white),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: viewModel.blocks.length + 1,
              itemBuilder: (context, index) {
                final bool isOthers = index == viewModel.blocks.length;
                final String blockTitle = isOthers
                    ? "OTHERS"
                    : viewModel.blocks[index].title;
                final int? targetBlockId = isOthers
                    ? null
                    : viewModel.blocks[index].id;

                return ListTile(
                  title: Text(
                    blockTitle,
                    style: const TextStyle(color: Colors.white),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey,
                    size: 14,
                  ),
                  onTap: () async {
                    await viewModel.moveNotesToBlock(
                      noteIds: _selectedNoteIds.toList(),
                      blockId: targetBlockId,
                    );
                    _clearSelection();
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Moved notes to $blockTitle")),
                    );
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
          ],
        );
      },
    );
  }
}
