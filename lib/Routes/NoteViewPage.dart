import 'package:flutter/material.dart';

class NoteViewPage extends StatefulWidget {
  bool isForNewCreation;
  TextEditingController contentController;
  TextEditingController titleController;

  NoteViewPage({this.isForNewCreation = true})
    : contentController = TextEditingController(),
      titleController = TextEditingController(text: "Notes");

  State<NoteViewPage> createState() => _NoteViewPageState();
}

class _NoteViewPageState extends State<NoteViewPage> {
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
        style: TextStyle(color: Colors.white, fontSize: 16),
        controller: widget.contentController,
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
        onPressed: () {},
        icon: Icon(
          Icons.arrow_back_ios_new_sharp,
          color: Colors.white,
          size: 25,
        ),
      ),
      actionsPadding: EdgeInsets.only(right: 10),
      actions: [
        if (!widget.isForNewCreation) _buildDeleteButton(),
        _buildExportButton(),
      ],
      backgroundColor: Colors.black,
      toolbarHeight: 50,
      title: _buildAppBarText(),
    );
  }

  Widget _buildDeleteButton() {
    return IconButton(
      onPressed: () {},
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
      controller: widget.titleController,
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

String sum =
    """Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."

Section 1.10.32 of "de Finibus Bonorum et Malorum", written by Cicero in 45 BC
"Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?""";
