import 'package:flutter/material.dart';
import 'package:notes/Components/NotesTile.dart';
import 'package:notes/Databases/NotesDB.dart';
import 'package:notes/Models/Note.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return GridView.builder(
      padding: EdgeInsets.all(5),
      itemCount: context.read<NotesDB>().getDbSize(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 20,
        childAspectRatio: 0.7,
      ),
      itemBuilder: (context, index) {
        Note note = context.read<NotesDB>().getAllNotes()[index];
        return NotesTile(key: ValueKey(note), note: note);
      },
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      actionsPadding: EdgeInsets.only(right: 5),
      actions: [_buildAddButton()],
      centerTitle: true,
      backgroundColor: Colors.black,
      toolbarHeight: 80,
      title: Text(
        "NOTES",
        style: TextStyle(
          color: Colors.white,
          fontSize: 40,
          letterSpacing: 2,
          fontFamily: "Beyno",
        ),
      ),
    );
  }

  Widget _buildAddButton() {
    return IconButton(
      onPressed: () {
        Navigator.pushNamed(context, '/new');
      },
      icon: Icon(Icons.add, color: Colors.white, size: 40),
    );
  }
}
