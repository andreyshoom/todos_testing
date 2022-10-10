import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:todo_firebase/pages/todo_list.dart';
import 'package:todo_firebase/services/todo_services.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  late StreamSubscription _sub;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TodoServices>(
      create: (context) {
        final service = TodoServices();
        _sub = service.todoFromFirebase;

        return service;
      },
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: TodoList(),
      ),
    );
  }
}
