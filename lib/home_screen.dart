import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _todoController = TextEditingController();

  // LISTA DE TAREFAS
  List<Todo> todoList = [];

  // FUNÇÃO QUE ADICIONA MAIS UM TAREFA NA LISTA
  void createTodo(String name) {
    Todo newTodo = Todo(name: name, isDone: false);
    setState(() {
      todoList.add(newTodo);
      ordenarLista();
      _todoController.clear();
    });
  }

  void completeTask(int index) {
    setState(() {
      todoList[index].isDone = !todoList[index].isDone;
      ordenarLista();
    });
  }

  void ordenarLista() {
    todoList.sort((a, b) {
      if (a.isDone) {
        return 1;
      }
      return -1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Todo List'),
        centerTitle: true,
        backgroundColor: const Color(0xFF2830F0),
      ),
      body: Column(
        children: [
          Container(
            height: 60,
            margin:
                const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 5.0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                      blurRadius: 8,
                      spreadRadius: 1,
                      color: Colors.black.withOpacity(0.3),
                      offset: const Offset(-2, 3))
                ]),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: TextField(
                    controller: _todoController,
                    decoration: const InputDecoration(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: CircleAvatar(
                    backgroundColor: const Color(0xFF2830F0),
                    child: Center(
                      child: IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          createTodo(_todoController.text);
                        },
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          const Divider(
            thickness: 2,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: todoList.length,
              itemBuilder: ((context, index) {
                return TodoItem(
                  todo: todoList[index],
                  onTodoChange: () {
                    completeTask(index);
                  },
                );
              }),
            ),
          )
        ],
      ),
    );
  }
}

class Todo {
  final String name;
  bool isDone;

  Todo({required this.name, required this.isDone});
}

class TodoItem extends StatelessWidget {
  final Todo todo;
  final VoidCallback onTodoChange;

  const TodoItem({Key? key, required this.onTodoChange, required this.todo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: 280,
      margin: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 12.0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
                blurRadius: 8,
                spreadRadius: 1,
                color: Colors.black.withOpacity(0.3),
                offset: const Offset(-2, 3))
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              todo.name,
              style: TextStyle(
                decoration: todo.isDone
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
          ),
          if (todo.isDone) ...[
            CircleAvatar(
              backgroundColor: const Color(0xFF3EF45B),
              child: Center(
                  child: IconButton(
                onPressed: onTodoChange,
                icon: const Icon(
                  Icons.check,
                  color: Colors.white,
                ),
              )),
            ),
          ] else ...[
            InkWell(
              onTap: onTodoChange,
              child: const CircleAvatar(
                backgroundColor: Color.fromARGB(255, 153, 153, 153),
              ),
            ),
          ]
        ],
      ),
    );
  }
}
