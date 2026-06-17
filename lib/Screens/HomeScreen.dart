import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:notes/Screens/NotesPageView.dart';
import 'package:notes/Screens/ToDoListPageView.dart';
import 'package:notes/Components/BottomNavBar.dart';
import 'package:notes/Components/ToDoListPage/NewToDoListSheet.dart';
import 'package:notes/ViewModels/NotesPageViewModel.dart';
import 'package:notes/ViewModels/ToDoListPageViewModel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    NotesPageView(),
    ToDoListPageView(),
  ];

  void _showCreateBlockDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF282321),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text("New Block", style: TextStyle(color: Colors.white)),
          content: TextField(
            controller: controller,
            autofocus: true,
            style: const TextStyle(color: Colors.white),
            cursorColor: const Color(0xFF29B6F6),
            decoration: const InputDecoration(
              hintText: "Enter block title...",
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
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF29B6F6),
              ),
              onPressed: () async {
                final text = controller.text.trim();
                if (text.isNotEmpty) {
                  await context.read<NotesPageViewModel>().createBlock(title: text);
                  if (dialogContext.mounted) Navigator.pop(dialogContext);
                }
              },
              child: const Text("Create", style: TextStyle(color: Colors.black)),
            ),
          ],
        );
      },
    );
  }

  void _showCreateToDoListSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return NewToDoListSheet(
          onCreate: (title, tasks) async {
            await context
                .read<ToDoListPageViewModel>()
                .createToDoList(title: title, toDoNames: tasks);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF131110),
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        color: const Color(0xFF131110), // Seamless container color
        child: SafeArea(
          child: BottomNavBar(
            currentIndex: _currentIndex,
            onTapTab: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            onTapAdd: () {
              if (_currentIndex == 0) {
                _showCreateBlockDialog(context);
              } else {
                _showCreateToDoListSheet(context);
              }
            },
          ),
        ),
      ),
    );
  }
}
