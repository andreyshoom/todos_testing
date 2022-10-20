import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/todo.dart';

class TodoServices with ChangeNotifier {
  List<Todo> todos = [];
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool toggle = false;

  StreamSubscription get todoFromFirebase {
    return firestore.collection('todos').snapshots().listen((event) {
      for (var change in event.docChanges) {
        switch (change.type) {
          case DocumentChangeType.added:
            todos = event.docs
                .map(
                  (DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;

                    return Todo(
                      id: document.id,
                      title: data['title'],
                      tog: data['tog'] ?? false,
                    );
                  },
                )
                .toList()
                .cast();

            notifyListeners();
            break;
          case DocumentChangeType.modified:
            print("Modified: ${change.doc.data()}");
            break;
          case DocumentChangeType.removed:
            print("Removed: ${change.doc.data()}");
            break;
        }
      }
    });
  }

  Future<void> toggleTodo(Todo todo) async {
    var index = todos.indexWhere(
      (element) => element.id == todo.id,
    );

    if (index != -1) {
      // print(todo.id);
      await firestore.collection('todos').doc(todo.id).update({
        'tog': todo.tog = !todo.tog,
      });

      todos[index].toggleBought();
    }
    notifyListeners();
  }

  Future<void> addTodo(Todo todo) async {
    await firestore.collection('todos').add({
      "title": todo.title,
      // "tog": todo.tog,
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
        "tog": todo.tog,
        "title": todo.title,
      });
      todos[index] = todo;
    }
    notifyListeners();
  }

  // Future<List<Todo>> filtering() async {
  //   final result = await firestore
  //       .collection('todos')
  //       .where('tog', isEqualTo: false)
  //       .get();

  //   return result.docs.map((DocumentSnapshot document) {
  //     final index = firestore.collection('todos').doc().id;

  //     Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

  //     return Todo(
  //       id: index,
  //       title: data['title'],
  //       tog: data['tog'],
  //     );
  //   }).toList();
  //   // notifyListeners();
  // }
}
