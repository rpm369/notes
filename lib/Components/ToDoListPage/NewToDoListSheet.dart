import 'package:flutter/material.dart';

class NewToDoListSheet extends StatefulWidget {
  final Function(String title, List<String> tasks) onCreate;

  const NewToDoListSheet({
    super.key,
    required this.onCreate,
  });

  @override
  State<NewToDoListSheet> createState() => _NewToDoListSheetState();
}

class _NewToDoListSheetState extends State<NewToDoListSheet> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _taskController = TextEditingController();
  final List<String> _tasks = [];
  bool _isAddingTask = false;

  @override
  void dispose() {
    _titleController.dispose();
    _taskController.dispose();
    super.dispose();
  }

  void _addTask() {
    final text = _taskController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _tasks.add(text);
        _taskController.clear();
        _isAddingTask = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF282321), // Dark warm grey-brown background
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF38312E),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.playlist_add_check,
                        color: Color(0xFFBE9375),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Text(
                      "New to-do list",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Color(0xFF38312E),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.grey,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // List Title input field
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFF4E433F)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _titleController,
                style: const TextStyle(color: Colors.white, fontSize: 16),
                cursorColor: const Color(0xFFBE9375),
                decoration: const InputDecoration(
                  labelText: "List title",
                  labelStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Tasks subheader
            Text(
              "Tasks (${_tasks.length}/30)",
              style: const TextStyle(
                color: Color(0xFFBE9375),
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            // Tasks List
            if (_tasks.isNotEmpty)
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _tasks.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: Color(0xFFBE9375),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              _tasks[index],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _tasks.removeAt(index);
                            });
                          },
                          child: const Icon(
                            Icons.close,
                            color: Colors.grey,
                            size: 18,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

            // Add Task input / button
            const SizedBox(height: 8),
            if (_isAddingTask)
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _taskController,
                      style: const TextStyle(color: Colors.white),
                      autofocus: true,
                      cursorColor: const Color(0xFFBE9375),
                      decoration: const InputDecoration(
                        hintText: "Enter task name...",
                        hintStyle: TextStyle(color: Colors.grey),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFBE9375)),
                        ),
                      ),
                      onSubmitted: (_) => _addTask(),
                    ),
                  ),
                  IconButton(
                    onPressed: _addTask,
                    icon: const Icon(Icons.check, color: Color(0xFFBE9375)),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _isAddingTask = false;
                        _taskController.clear();
                      });
                    },
                    icon: const Icon(Icons.close, color: Colors.grey),
                  ),
                ],
              )
            else
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isAddingTask = true;
                  });
                },
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Color(0xFF38312E),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Color(0xFFBE9375),
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      "New task",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 32),

            // Bottom Actions (Cancel / Create)
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF4E433F)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      "Cancel",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      final title = _titleController.text.trim();
                      if (title.isNotEmpty) {
                        widget.onCreate(title, _tasks);
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFBE9375), // Beige color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      "Create",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
