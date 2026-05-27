import 'package:flutter/material.dart';
import 'package:notes/Databases/NotesDB.dart';
import 'package:notes/Models/Note.dart';
import 'package:notes/Services/DocumentSaver.dart';
import 'package:provider/provider.dart';

class NoteViewPage extends StatefulWidget {
  Note? note;

  NoteViewPage({this.note});

  State<NoteViewPage> createState() => _NoteViewPageState();
}

class _NoteViewPageState extends State<NoteViewPage> {
  late TextEditingController contentController;
  late TextEditingController titleController;
  late FocusNode node;

  void initState() {
    String preContent = widget.note?.content ?? "";
    contentController = new TextEditingController(text: preContent);

    String preTitle = widget.note?.title ?? "Title";
    titleController = new TextEditingController(text: preTitle);
    node = new FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      node.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return SafeArea(
      child: TextField(
        maxLines: null,
        keyboardType: TextInputType.multiline,
        focusNode: node,
        style: TextStyle(fontSize: 16),
        controller: contentController,
        cursorColor: Theme.of(context).colorScheme.onSurface,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      leadingWidth: 45,
      leading: IconButton(
        onPressed: () async {
          await leadingButtonFunction();
        },
        icon: Icon(
          Icons.arrow_back_ios_new_sharp,
          color: Theme.of(context).colorScheme.onSurface,
          size: 25,
        ),
      ),
      actionsPadding: EdgeInsets.only(right: 10),
      actions: [
        if (widget.note != null) _buildDeleteButton(),
        _buildExportButton(),
      ],
      backgroundColor: Theme.of(context).colorScheme.surface,
      toolbarHeight: 50,
      title: _buildAppBarText(),
    );
  }

  Future<void> leadingButtonFunction() async {
    String titlecontrollerText = titleController.text;
    String contentControllerText = contentController.text;

    if (widget.note == null) {
      if (contentController.text.isNotEmpty) {
        String title = (titlecontrollerText.isNotEmpty)
            ? titleController.text
            : "No Title";

        await context.read<NotesDB>().addNewNote(
          Note(title, contentController.text),
        );
      }
    } else {
      if (widget.note!.title != titlecontrollerText ||
          widget.note!.content != contentControllerText) {
        widget.note!.title = titlecontrollerText;
        widget.note!.content = contentControllerText;

        await widget.note!.save();
      }
    }

    Navigator.pop(context);
  }

  Widget _buildDeleteButton() {
    return IconButton(
      onPressed: () async {
        await context.read<NotesDB>().deleteNote(widget.note!);
        Navigator.pop(context, false);
      },
      icon: Icon(
        Icons.delete,
        size: 28,
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }

  Widget _buildExportButton() {
    return IconButton(
      onPressed: () async {
        if (contentController.text.isEmpty) {
          _showSnackBar(content: "No content to store");
          return;
        }

        bool status = await DocumentSaver.saveNote(
          Note(titleController.text, contentController.text),
        );
        _showSnackBar(content: (status) ? "File Saved !" : "File not Saved !");
      },
      icon: Icon(
        Icons.sim_card_download_sharp,
        color: Theme.of(context).colorScheme.onSurface,
        size: 28,
      ),
    );
  }

  void _showSnackBar({required String content}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Theme.of(context).colorScheme.onSurface,
        content: Text(content, style: TextStyle(fontSize: 15)),
        padding: EdgeInsets.all(6),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Widget _buildAppBarText() {
    return TextField(
      cursorColor: Theme.of(context).colorScheme.onSurface,
      controller: titleController,
      style: TextStyle(fontSize: 28, letterSpacing: 2, fontFamily: "Beyno"),
      maxLines: 1,
      maxLength: 20,
      textAlignVertical: TextAlignVertical.center,
      decoration: InputDecoration(
        counterText: "",
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
      ),
    );
  }
}
