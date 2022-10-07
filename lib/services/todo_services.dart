import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../models/todo.dart';

class TodoServices with ChangeNotifier {
  List<Todo> todos = [];
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  // late StreamSubscription streamSubscriptionFirebase;

  // TodoServices() {
  //   streamSubscriptionFirebase = firestore
  //       .collection('todos')
  //       .snapshots()
  //       .listen(onError: (error) => print("Listen failed: $error"), (event) {
  //     event.docs.map(
  //       (e) => Todo.fromJson(
  //         e.data(),
  //       ),
  //     );
  //     notifyListeners();
  //   });
  // }

  // @override
  // void dispose() {
  //   streamSubscriptionFirebase.cancel();
  //   super.dispose();
  // }

  // StreamSubscription get todoFromFirebase {
  //   return firestore
  //       .collection('todos')
  //       .snapshots()
  //       .listen(onError: (error) => print("Listen failed: $error"), (event) {
  //     event.docs
  //         .map(
  //           (e) => Todo.fromJson(
  //             e.data(),
  //           ),
  //         )
  //         .toList();

  //     notifyListeners();
  //   });
  // }

  StreamSubscription get todoFromFirebase2 {
    return firestore.collection('todos').snapshots().listen((event) {
      event.docs.map(
        (e) => Todo(
          id: e.data()["id"],
          title: e.data()["title"],
          tog: e.data()["title"],
        ),
      );
      // .toList();
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



  // Stream<List<Todo>> get todoFromFirebase {
  //   return firestore.collection('todos').snapshots().map(
  //         (event) => event.docs.map(
  //           (DocumentSnapshot documentSnapshot) {
  //             Map<String, dynamic> data =
  //                 documentSnapshot.data()! as Map<String, dynamic>;
  //             notifyListeners(); //??????
  //             return Todo(
  //               id: data["id"],
  //               title: data["title"],
  //               tog: data["tog"],
  //             );
  //           },
  //         ).toList(),
  //       );
  // }