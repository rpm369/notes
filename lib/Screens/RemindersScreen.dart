import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:notes/ViewModels/RemindersScreenViewModel.dart';
import 'package:notes/Components/RemindersScreen/RemindersAppBar.dart';
import 'package:notes/Components/RemindersScreen/ReminderNoteCard.dart';

class RemindersScreen extends StatefulWidget {
  const RemindersScreen({super.key});

  @override
  State<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RemindersScreenViewModel>().loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<RemindersScreenViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFF131110), // Warm dark background
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RemindersAppBar(
              count: viewModel.totalReminderCount,
              onBack: () => Navigator.pop(context),
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
                  : _buildRemindersListView(viewModel),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRemindersListView(RemindersScreenViewModel viewModel) {
    final notes = viewModel.reminderNotes;
    if (notes.isEmpty) {
      return const Center(
        child: Text(
          "No active reminders",
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        return ReminderNoteCard(
          note: note,
          onCancel: () async {
            if (note.id != null) {
              await viewModel.cancelReminder(note: note);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "Cancelled reminder for '${note.title ?? 'note'}'",
                    ),
                  ),
                );
              }
            }
          },
        );
      },
    );
  }
}
