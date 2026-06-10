class ToDoListModel {
  final int? id;
  final String title;

  const ToDoListModel({this.id, required this.title});

  Map<String, dynamic> toJson() {
    return {'id': this.id, 'title': this.title};
  }

  factory ToDoListModel.fromJson({required Map<String, dynamic> json}) {
    return ToDoListModel(id: json['id'], title: json['title']);
  }

  ToDoListModel copyWith({int? id, String? title}) {
    return ToDoListModel(id: id ?? this.id, title: title ?? this.title);
  }
}
