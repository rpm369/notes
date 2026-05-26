class Note {
  String? _title;
  late String _content;

  Note({this._title, required this._content});

  set title(String newTitle) => this._title = newTitle;
  set content(String newContent) => this._content = newContent;

  String? get title => this._title;
  String get content => this._content;
}
