import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:notes/ViewModels/TrashScreenViewModel.dart';
import 'package:notes/Components/TrashScreen/TrashAppBar.dart';
import 'package:notes/Components/TrashScreen/TrashSearchBar.dart';
import 'package:notes/Components/TrashScreen/TrashNoteCard.dart';

class TrashView extends StatefulWidget {
  const TrashView({super.key});

  @override
  State<TrashView> createState() => _TrashViewState();
}

class _TrashViewState extends State<TrashView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TrashScreenViewModel>().loadData();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _formatNoteDate(DateTime date) {
    final months = [
      "Jan", "Feb", "Mar", "Apr", "May", "Jun",
      "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ];
    final day = date.day;
    final month = months[date.month - 1];

    int hour = date.hour;
    final minute = date.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? "PM" : "AM";
    hour = hour % 12;
    if (hour == 0) hour = 12;

    return "$day $month • $hour:$minute $period";
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<TrashScreenViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFF131110), // Warm dark background
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TrashAppBar(
              count: viewModel.totalNotesInTrash,
              onBack: () => Navigator.pop(context),
              onClear: () async {
                final noteIds = viewModel.allNotes.map((n) => n.id!).toList();
                if (noteIds.isNotEmpty) {
                  await viewModel.restoreNote(noteIds: noteIds);
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Restored all notes from Trash")),
                    );
                  }
                }
              },
            ),
            TrashSearchBar(
              controller: _searchController,
              onChanged: (value) {
                viewModel.updateQuery(query: value);
              },
            ),
            Expanded(
              child: viewModel.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFBE9375),
                      ),
                    )
                  : viewModel.errorMessage.isNotEmpty
                      ? Center(
                          child: Text(
                            viewModel.errorMessage,
                            style: const TextStyle(color: Colors.red),
                          ),
                        )
                      : _buildTrashListView(viewModel),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrashListView(TrashScreenViewModel viewModel) {
    final notes = viewModel.allNotes;
    if (notes.isEmpty) {
      return const Center(
        child: Text(
          "No notes in Trash",
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        return TrashNoteCard(
          note: note,
          formattedDate: _formatNoteDate(note.updatedAt),
          onRestore: () async {
            await viewModel.restoreNote(noteIds: [note.id!]);
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Restored '${note.title ?? 'note'}'")),
              );
            }
          },
          onDelete: () async {
            await viewModel.deletePermanently(noteIds: [note.id!]);
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Permanently deleted '${note.title ?? 'note'}'")),
              );
            }
          },
        );
      },
    );
  }
}
