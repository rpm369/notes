import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:notes/ViewModels/ToDoListPageViewModel.dart';
import 'package:notes/Components/ToDoListPage/ToDoAppBar.dart';
import 'package:notes/Components/ToDoListPage/ToDoListCard.dart';
import 'package:notes/Models/ToDoListModel.dart';

class ToDoListPageView extends StatefulWidget {
  const ToDoListPageView({super.key});

  @override
  State<ToDoListPageView> createState() => _ToDoListPageViewState();
}

class _ToDoListPageViewState extends State<ToDoListPageView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ToDoListPageViewModel>().loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ToDoListPageViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFF131110), // Warm dark background
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ToDoAppBar(),
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
                      : _buildListsView(viewModel),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListsView(ToDoListPageViewModel viewModel) {
    final lists = viewModel.toDoLists;
    if (lists.isEmpty) {
      return const Center(
        child: Text(
          "No to-do lists found",
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      itemCount: lists.length,
      itemBuilder: (context, index) {
        final list = lists[index];
        final toDos = viewModel.toDosByList[list.id!] ?? [];
        final isExpanded = viewModel.isListExpanded(listId: list.id!);

        return ToDoListCard(
          list: list,
          toDos: toDos,
          isExpanded: isExpanded,
          onToggleExpand: () {
            viewModel.toggleListExpansion(listId: list.id!);
          },
          onRename: () {
            _showRenameDialog(viewModel, list);
          },
          onDelete: () async {
            await viewModel.deleteToDoList(listId: list.id!);
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Deleted list '${list.title}'")),
              );
            }
          },
          onToggleCompletion: (todo) {
            viewModel.toggleToDoCompletion(toDoId: todo.id!);
          },
        );
      },
    );
  }

  void _showRenameDialog(ToDoListPageViewModel viewModel, ToDoListModel list) {
    final controller = TextEditingController(text: list.title);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF282321),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text("Rename List", style: TextStyle(color: Colors.white)),
          content: TextField(
            controller: controller,
            autofocus: true,
            style: const TextStyle(color: Colors.white),
            cursorColor: const Color(0xFFBE9375),
            decoration: const InputDecoration(
              hintText: "Enter list title...",
              hintStyle: TextStyle(color: Colors.grey),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFBE9375)),
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
                backgroundColor: const Color(0xFFBE9375),
              ),
              onPressed: () async {
                final text = controller.text.trim();
                if (text.isNotEmpty) {
                  await viewModel.renameList(listId: list.id!, newTitle: text);
                  if (mounted) Navigator.pop(context);
                }
              },
              child: const Text("Rename", style: TextStyle(color: Colors.black)),
            ),
          ],
        );
      },
    );
  }
}
