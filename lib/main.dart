import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes/Databases/NotesDB.dart';
import 'package:notes/Databases/SystemDB.dart';
import 'package:notes/Models/Note.dart';
import 'package:notes/Routes/ErrorPage.dart';
import 'package:notes/Routes/HomePage.dart';
import 'package:notes/Routes/NoteViewPage.dart';
import 'package:notes/Themes/ThemeProvider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemDB systemDB = await SystemDB.initializeDB();
  NotesDB notesDb = await NotesDB.getDatabase();

  runApp(
    MultiProvider(
      providers: [
        Provider(create: (context) => notesDb),
        ChangeNotifierProvider(create: (context) => systemDB),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    bool themeStatus = context.watch<SystemDB>().isThemeDark();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeProvider.getCurrentTheme(themeStatus),
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
