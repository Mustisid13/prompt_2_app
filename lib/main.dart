import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/task_bloc.dart';
import 'blocs/task_event.dart';
import 'models/task_model.dart';
import 'repositories/task_repositories.dart';
import 'screens/add_task_screen.dart';
import 'screens/home_screen.dart';
import 'screens/task_detail_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
  
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TaskBloc(taskRepository: TaskRepository())..add(LoadTasks()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'TODO App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const HomeScreen(),
          '/addTask': (context) => const AddTaskScreen(),
          '/taskDetail': (context) => TaskDetailScreen(
              task: ModalRoute.of(context)!.settings.arguments as Task),
        },
      ),
    );
  }
}
