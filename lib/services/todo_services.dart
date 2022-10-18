import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/todo.dart';

class TodoServices with ChangeNotifier {
  List<Todo> todos = [];
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  StreamSubscription get todoFromFirebase {
    return firestore
        .collection('todos')
        .snapshots()
        .listen(onError: (error) => print("Listen failed: $error"), (event) {
      todos = event.docs
          .map((DocumentSnapshot document) {
            final index = firestore.collection('todos').doc().id;
            print(index);
            Map<String, dynamic> data =
                document.data()! as Map<String, dynamic>;
            print(data[index].toString());
            return Todo(
              id: index,
              title: data['title'],
              tog: data['tog'],
            );
          })
          .toList()
          .cast();

      notifyListeners();
    });
  }

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
