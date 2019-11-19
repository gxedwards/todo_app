import 'dart:collection';

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

/// Todo model object
class Todo {
  String title;
  String description;
  bool completed;
  Todo({@required this.title, this.description, this.completed = false});

  void toggleCompleted() {
    this.completed = !this.completed;
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Passing Data',
      home: TodosListScreen(),
    );
  }
}

class TodosListScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TodosListScreenState();
  }
}

class TodosListScreenState extends State<TodosListScreen> {
  final List<Todo> todos = List.generate(
    5,
    (i) => Todo(
      title: 'Todo $i',
      description: 'A description of what needs to be done for Todo $i',
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Flutter Todos')),
      body: ListView.builder(
          itemCount: todos.length,
          itemBuilder: (context, index) {
            final todo = todos[index];

            return Dismissible(
                // make the background red as swiped to right
                background: Container(color: Colors.red),
                // this has to be unique or issues will arise
                key: ObjectKey(todos[index]),
                onDismissed: (direction) {
                  // tell the screen to refresh
                  setState(() {
                    this.todos.removeAt(index);
                  });
                  // Then show a snackbar.
                  //   Scaffold.of(context)
                  //       .showSnackBar(SnackBar(content: Text("$todo dismissed")));
                },
                child: ListTile(
                  title: Text(todos[index].title),
                  trailing: IconButton(
                    icon: Icon(Icons.delete_forever),
                    onPressed: () {
                      setState(() {
                        this.todos.removeAt(index);
                      });
                      // Then show a snackbar.
                      //     Scaffold.of(context)
                      //         .showSnackBar(SnackBar(content: Text("$todo dismissed")));
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              DetailScreen(todo: todos[index])),
                    );
                  },
                ));
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NewTodoForm(todoList: todos),
              ));
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }
}

class NewTodoForm extends StatefulWidget {

  final List<Todo> todoList;

  NewTodoForm({Key key, @required this.todoList}) : super(key: key);

  @override
  NewTodoFormState createState() {
    return NewTodoFormState(this.todoList);
  }
}

class NewTodoFormState extends State<NewTodoForm> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  final List<Todo> _todoList;

  // constructor
  NewTodoFormState(this._todoList);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Todo'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (String value) {
                  if (value.trim().isEmpty) {
                    return 'Title is required';
                  }
                  return null;
                }),
            TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: RaisedButton(
                onPressed: () {
                  // Validate returns true if the form is valid, or false
                  // otherwise.
                  if (_formKey.currentState.validate()) {
                    final todo = new Todo(
                        title: _titleController.value.text,
                        description: _descriptionController.value.text);

                    // add to the top of the list
                    _todoList.insert(0,todo);

                    //Provider
                    Navigator.of(context).pop();
                  }
                },
                child: Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  // Declare a field that holds the Todo.
  final Todo todo;

  // In the constructor, require a Todo.
  DetailScreen({Key key, @required this.todo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use the Todo to create the UI.
    return Scaffold(
      appBar: AppBar(
        title: Text(todo.title),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(todo.description),
      ),
    );
  }
}
