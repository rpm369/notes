import 'package:flutter/material.dart';
import 'package:notes/Databases/NotesDB.dart';
import 'package:notes/Models/Note.dart';
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
      backgroundColor: Colors.black,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return SafeArea(
      child: TextField(
        maxLines: 1000000,
        focusNode: node,
        style: TextStyle(color: Colors.white, fontSize: 16),
        controller: contentController,
        cursorColor: Colors.white,
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
          color: Colors.white,
          size: 25,
        ),
      ),
      actionsPadding: EdgeInsets.only(right: 10),
      actions: [
        if (widget.note != null) _buildDeleteButton(),
        _buildExportButton(),
      ],
      backgroundColor: Colors.black,
      toolbarHeight: 50,
      title: _buildAppBarText(),
    );
  }

  Future<void> leadingButtonFunction() async {
    String titlecontrollerText = titleController.text;
    String contentControllerText = contentController.text;
    bool needToRebuildParent = false;

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
        needToRebuildParent = true;
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
      icon: Icon(Icons.delete, size: 28, color: Colors.white),
    );
  }

  Widget _buildExportButton() {
    return IconButton(
      onPressed: () {},
      icon: Icon(Icons.sim_card_download_sharp, color: Colors.white, size: 28),
    );
  }

  Widget _buildAppBarText() {
    return TextField(
      cursorColor: Colors.white,
      controller: titleController,
      style: TextStyle(
        color: Colors.white,
        fontSize: 28,
        letterSpacing: 2,
        fontFamily: "Beyno",
      ),
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
