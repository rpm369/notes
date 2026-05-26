import 'package:hive/hive.dart';

part 'Note.g.dart';

@HiveType(typeId: 0)
class Note extends HiveObject {
  @HiveField(0)
  String? title;
  @HiveField(1)
  late String content;

  Note(this.title, this.content);
}
