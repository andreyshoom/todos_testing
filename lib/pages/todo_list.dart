import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_firebase/models/todo.dart';
import 'package:todo_firebase/services/todo_services.dart';

class TodoList extends StatefulWidget {
  const TodoList({Key? key}) : super(key: key);

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  @override
  Widget build(BuildContext context) {
    // List<Todo> todoProvider = Provider.of<List<Todo>>(context);
    return Scaffold(
        body: Consumer<TodoServices>(builder: (context, value, child) {
          // value.todoFromFirebase2.asFuture();
          return ListView.builder(
            itemCount: value.todos.length,
            itemBuilder: (_, index) => ListTile(
              title: Text(value.todos[index].title),
              subtitle: Text(value.todos[index].tog.toString()),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                      onPressed: () async {
                        var tempTodo = Todo(
                            id: value.todos[index].id,
                            title: value.todos[index].title,
                            tog: value.todos[index].tog);
                        tempTodo.tog = value.todos[index].tog;

                        context.read<TodoServices>().toggleTodo(tempTodo);
                      },
                      icon: const Icon(Icons.change_circle)),
                  IconButton(
                    onPressed: () {
                      TextEditingController _textContoller =
                          TextEditingController(text: value.todos[index].title);
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: TextField(
                            controller: _textContoller,
                          ),
                          actions: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                var tempTodo = Todo(
                                    id: value.todos[index].id,
                                    title: _textContoller.text,
                                    tog: value.todos[index].tog);
                                // tempTodo.id = value.todos[index].id;
                                context
                                    .read<TodoServices>()
                                    .updateTodo(tempTodo);
                                Navigator.pop(context);
                              },
                              child: Text('Udpade'),
                            ),
                          ],
                        ),
                      );
                    },
                    icon: const Icon(Icons.edit),
                  ),
                  IconButton(
                    onPressed: () {
                      context
                          .read<TodoServices>()
                          .removeToDo(value.todos[index].id);
                    },
                    icon: const Icon(
                      Icons.delete_rounded,
                      color: Colors.red,
                    ),
                  )
                ],
              ),
            ),
          );
        }),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () {
                TextEditingController _textContoller = TextEditingController();
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: TextField(
                      controller: _textContoller,
                    ),
                    actions: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          context.read<TodoServices>().addTodo(
                                Todo(
                                  id: '',
                                  title: _textContoller.text,
                                  tog: false,
                                ),
                              );
                          Navigator.pop(context);
                        },
                        child: Text('Add'),
                      ),
                    ],
                  ),
                );
              },
              child: const Icon(Icons.add),
            ),
            FloatingActionButton(
              onPressed: () {
                // context.read<TodoServices>().filtering();
              },
              child: const Icon(Icons.filter_2_sharp),
            )
          ],
        ));
  }
}
