import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../models/todo.dart';

class TodoServices with ChangeNotifier {
  List<Todo> todos = [];
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> addTodo(Todo todo) async {
    await firestore.collection('todos').add({
      "title": todo.title,
      "tog": false,
    }).then((value) {
      todo.id = value.id;
      todos.add(todo);
    });
    notifyListeners();
  }

  Future<void> removeToDo(id) async {
    var index = todos.indexWhere(
      (element) => element.id == id,
    );
    if (index != -1) {
      await firestore.collection('todos').doc(id).delete();
      todos.removeAt(index);
    }
    notifyListeners();
  }

  Future<void> updateTodo(Todo todo) async {
    var index = todos.indexWhere(
      (el) => el.id == todo.id,
    );
    if (index != -1) {
      await firestore.collection('todos').doc(todo.id).update({
        "title": todo.title,
      });
      todos[index] = todo;
    }
    notifyListeners();
  }

  Future<void> toggleTodo(Todo todo) async {
    var index = todos.indexWhere(
      (element) => element.id == todo.id,
    );
    if (index != -1) {
      await firestore.collection('todos').doc(todo.id).update({
        "tog": todo.tog = !todo.tog,
      });

      todos[index].toggleBought();
    }
    notifyListeners();
  }
}
