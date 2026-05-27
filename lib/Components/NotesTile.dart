import 'package:flutter/material.dart';
import 'package:notes/Models/Note.dart';

class NotesTile extends StatefulWidget {
  Note note;

  NotesTile({required this.note, super.key});

  @override
  State<NotesTile> createState() => _NotesTileState();
}

class _NotesTileState extends State<NotesTile> {
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 5,
      children: [
        GestureDetector(
          onTap: () async {
            await Navigator.pushNamed(context, '/edit', arguments: widget.note);
          },
          child: _buildTile(),
        ),
        Text(widget.note.title ?? "TextNote", style: TextStyle(fontSize: 15)),
      ],
    );
  }

  Widget _buildTile() {
    return Container(
      height: 220,
      width: 150,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        widget.note.content,
        style: TextStyle(overflow: TextOverflow.fade),
      ),
    );
  }
}
