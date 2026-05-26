import 'package:flutter/material.dart';

class NotesTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 5,
      children: [
        _buildTile(),
        Text("abc", style: TextStyle(color: Colors.white, fontSize: 15)),
      ],
    );
  }

  Widget _buildTile() {
    return Container(
      height: 220,
      width: 150,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        "xyz",
        style: TextStyle(color: Colors.white, overflow: TextOverflow.fade),
      ),
    );
  }
}
