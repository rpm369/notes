import 'package:flutter/material.dart';
import 'package:notes/Database/SqlDatabaseProvider.dart';
import 'package:notes/LocalRepos/ContentImageLocalRepository.dart';
import 'package:notes/LocalRepos/LocalBlockRespository.dart';
import 'package:notes/LocalRepos/LocalNotesRepository.dart';
import 'package:notes/LocalRepos/LocalToDoListRepository.dart';
import 'package:notes/LocalRepos/LocalToDoRepository.dart';
import 'package:notes/Services/BlockService.dart';
import 'package:notes/Services/ImageStorageService.dart';
import 'package:notes/Services/NotesService.dart';
import 'package:notes/Services/ReminderService.dart';
import 'package:notes/Services/ToDoListService.dart';
import 'package:notes/Services/ToDoService.dart';
import 'package:notes/Utils/NotificationCenter.dart';
import 'package:notes/ViewModels/NotesPageViewModel.dart';
import 'package:notes/ViewModels/RemindersScreenViewModel.dart';
import 'package:notes/ViewModels/ToDoListPageViewModel.dart';
import 'package:notes/ViewModels/TrashScreenViewModel.dart';
import 'package:notes/ViewModels/NotesDetailViewModel.dart';
import 'package:provider/provider.dart';
import 'package:notes/Screens/HomeScreen.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  await NotificationCenter.initializeChannels();

  final db = await SqlDatabaseProvider.getDatabase();

  final blockRepo = LocalBlockRespository(db: db);
  final contentImageRepo = ContentImageLocalRepository(db: db);
  final noteRepo = LocalNotesRepository(db: db);
  final toDoListRepo = LocalToDoListRepository(db: db);
  final toDoRepo = LocalToDoRepository(db: db);

  final reminderService = ReminderService();
  final imageService = ImageStorageService(imageRepo: contentImageRepo);
  final notesService = NotesService(
    notesRepo: noteRepo,
    reminderService: reminderService,
    imageService: imageService,
  );
  final blockService = BlockService(
    blockRepo: blockRepo,
    notesService: notesService,
  );
  final toDoService = ToDoService(toDoRepo: toDoRepo);
  final toDoListService = ToDoListService(
    listRepo: toDoListRepo,
    toDoService: toDoService,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => NotesPageViewModel(
            notesService: notesService,
            blockService: blockService,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => RemindersScreenViewModel(
            notesService: notesService,
            reminderService: reminderService,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => ToDoListPageViewModel(
            listService: toDoListService,
            toDoService: toDoService,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => TrashScreenViewModel(notesService: notesService),
        ),
        ChangeNotifierProvider(
          create: (_) => NotesDetailViewModel(
            imageService: imageService,
            notesService: notesService,
            blockService: blockService,
          ),
        ),
      ],
      child: MyApp(),
    ),
  );
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      home: const HomeScreen(),
    );
  }
}
