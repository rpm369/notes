import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:notes/Databases/NotesDB.dart';
import 'package:notes/Databases/SystemDB.dart';
import 'package:notes/Models/Note.dart';
import 'package:notes/Routes/ErrorPage.dart';
import 'package:notes/Routes/HomePage.dart';
import 'package:notes/Routes/NoteViewPage.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(NoteAdapter());

  await SystemDB.initializeDB();
  NotesDB notesDb = await NotesDB.initialize();

  runApp(Provider(create: (context) => notesDb, child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: generateRoutes,
    );
  }
}

Route<dynamic> generateRoutes(RouteSettings settings) {
  String name = settings.name!;
  switch (name) {
    case "/":
      return MaterialPageRoute(builder: (context) => HomePage());
    case "/new":
      return CupertinoPageRoute(builder: (context) => NoteViewPage());
    case "/edit":
      return CupertinoPageRoute(
        builder: (context) => NoteViewPage(note: settings.arguments as Note),
      );
    default:
      return MaterialPageRoute(builder: (context) => ErrorPage());
  }
}
