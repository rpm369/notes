class ToDoModel {
  final int? id;
  final int listId;
  final String name;
  final bool completionStatus;

  const ToDoModel({
    this.id,
    required this.listId,
    required this.name,
    this.completionStatus = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'listId': this.listId,
      'name': this.name,
      'completionStatus': (this.completionStatus) ? 1 : 0,
    };
  }

  factory ToDoModel.fromJson({required Map<String, dynamic> json}) {
    return ToDoModel(
      id: json['id'],
      listId: json['listId'],
      name: json['name'],
      completionStatus: json['completionStatus'] == 1,
    );
  }

  ToDoModel copyWith({
    int? id,
    int? listId,
    String? name,
    bool? completionStatus,
  }) {
    return ToDoModel(
      id: id ?? this.id,
      listId: listId ?? this.listId,
      name: name ?? this.name,
      completionStatus: completionStatus ?? this.completionStatus,
    );
  }
}
