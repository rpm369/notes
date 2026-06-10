class BlockModel {
  final int? id;
  final String title;

  const BlockModel({this.id, required this.title});

  Map<String, dynamic> toJson() {
    return {'id': this.id, 'title': this.title};
  }

  factory BlockModel.fromJson({required Map<String, dynamic> json}) {
    return BlockModel(id: json['id'], title: json['title']);
  }

  BlockModel copyWith({int? id, String? title}) {
    return BlockModel(id: id ?? this.id, title: title ?? this.title);
  }
}
