enum Constants {
  FIRST_TIME("first"),
  IS_THEME_DARK("isDark"),
  NOTES_BOX("NotesDB");

  final String value;
  const Constants(this.value);
}

enum NotesDBConst {
  TABLE_NAME("Note"),
  ID("id"),
  TITLE("title"),
  CONTENT("content");

  final String value;
  const NotesDBConst(this.value);
}
