import 'package:flutter/material.dart';
import 'package:notes/Components/NotesTile.dart';
import 'package:notes/Databases/NotesDB.dart';
import 'package:notes/Databases/SystemDB.dart';
import 'package:notes/Models/Note.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
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
      leading: _buildLeadingButton(),
      actions: [_buildAddButton()],
      centerTitle: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      toolbarHeight: 80,
      title: Text(
        "NOTES",
        style: TextStyle(fontSize: 40, letterSpacing: 2, fontFamily: "Beyno"),
      ),
    );
  }

  Widget _buildLeadingButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 5),
      child: IconButton(
        onPressed: () {
          context.read<SystemDB>().alterTheme();
        },
        icon: Icon(
          _getIcon(),
          color: Theme.of(context).colorScheme.onSurface,
          size: 40,
        ),
      ),
    );
  }

  IconData _getIcon() {
    return (Theme.of(context).brightness == Brightness.dark)
        ? Icons.dark_mode_sharp
        : Icons.light_mode;
  }

  Widget _buildAddButton() {
    return IconButton(
      onPressed: () {
        Navigator.pushNamed(context, '/new');
      },
      icon: Icon(
        Icons.add,
        color: Theme.of(context).colorScheme.onSurface,
        size: 40,
      ),
    );
  }
}
