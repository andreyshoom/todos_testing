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
  late CollectionReference<Todo> _todos;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _todos = FirebaseFirestore.instance.collection('todos').withConverter(
        fromFirestore: (snapshot, options) => Todo.fromJson(snapshot.data()!),
        toFirestore: (todo, _) => todo.toJson());
  }

  void toggle() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('todos').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Consumer<TodoServices>(
            builder: (context, value, child) => ListView.builder(
              itemCount: snapshot.data?.docs.length,
              /*value.todos.length,*/
              itemBuilder: (_, index) => ListTile(
                title: Text(snapshot.data!.docs[index]['title']),
                subtitle: Text((snapshot.data!.docs[index]['tog']).toString()),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                        onPressed: () {
                          /// ------- для StreamBuilder
                          var tempTodo = Todo(
                            id: snapshot.data!.docs[index].id,
                            title: snapshot.data!.docs[index]['title'],
                          );
                          tempTodo.tog = snapshot.data?.docs[index]['tog'];
                          print(tempTodo.id.toString());

                          //-------- без стрим билдера
                          // var tempTodo = Todo(
                          //     id: value.todos[index].id,
                          //     title: value.todos[index].title);
                          // tempTodo.tog = value.todos[index].tog;
                          // context.read<TodoServices>().toggleTodo(tempTodo);

                          Provider.of<TodoServices>(context, listen: false)
                              .toggleTodo(tempTodo);

                          FirebaseFirestore.instance
                              .collection('todos')
                              .doc(tempTodo.id)
                              .update({'tog': tempTodo.tog = !tempTodo.tog});
                        },
                        icon: const Icon(Icons.change_circle)),
                    IconButton(
                      onPressed: () {
                        TextEditingController _textContoller =
                            TextEditingController(
                                text: value.todos[index].title);
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
                                      title: _textContoller.text);
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
                      icon: Icon(Icons.edit),
                    ),
                    IconButton(
                      onPressed: () {
                        context
                            .read<TodoServices>()
                            .removeToDo(value.todos[index].id);
                      },
                      icon: Icon(
                        Icons.delete_rounded,
                        color: Colors.red,
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
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
    );
  }
}
