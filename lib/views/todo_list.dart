import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:todo_app_using_rest_apis/apiServices/ApiServices.dart';
import 'package:todo_app_using_rest_apis/models/todos.dart';
import 'package:todo_app_using_rest_apis/uiHelper/uiHelper.dart';
import 'package:todo_app_using_rest_apis/views/add_todo.dart';

class ToDoList extends StatefulWidget {
  const ToDoList({super.key});

  @override
  State<ToDoList> createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  Todos? todos;

  Future<void> addTodos() async {
    try {
      var fetchedTodos = await ApiServices().addTodo();
      setState(() {
        todos = fetchedTodos;
      });
    } catch (e) {
      print("Error fetching todos: $e");
    }
  }

  //delete

  Future<void> deleteTodoItem(String id, int index) async {
    try {
      await ApiServices().deleteTodo(id);
      setState(() {
        todos!.items!.removeAt(index); // Remove from the list after successful deletion
      });
    } catch (e) {
      print("Error deleting todo: $e");
    }
  }


  @override
  void initState() {
    super.initState();
    addTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text("ToDo List",style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 20
        ),),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueGrey,
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddToDo()));
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          const Gap(8),
          Expanded(
            child: todos == null
                ? const Center(child: CircularProgressIndicator())
                : todos!.items == null || todos!.items!.isEmpty
                    ? const Center(
                        child: Text("No Todo available.",style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 25
                        ),))
                    : RefreshIndicator(
                    onRefresh: addTodos,
                      child: ListView.builder(
                          itemCount: todos!.items!.length,
                          itemBuilder: (context, index) {
                            return SingleChildScrollView(
                              physics: BouncingScrollPhysics(),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 2),
                                child: Card(
                                  color: Colors.teal,
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.black,
                                      child: Text('${index + 1}'),
                                    ),
                                    title: Text(
                                        todos!.items![index].title ?? "No Title",style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 20
                                    ),),
                                    // Nullable check for safety
                                    subtitle: Text(todos!
                                            .items![index].description ??
                                        "No Description",style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                        fontSize: 15
                                    ),),
                                    trailing: PopupMenuButton(
                                      onSelected: (value) {
                                        if (value == "Edit") {
                                          // Navigate to the AddToDo screen in Edit mode, passing the selected todo
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => AddToDo(todo: todos!.items![index]), // Pass the selected todo item for editing
                                            ),
                                          );
                                        } else if (value == "Delete") {
                                          // Delete functionality
                                          deleteTodoItem(todos!.items![index].sId.toString(), index);
                                          UiHelper.message("Deleted", context, Colors.red);
                                        }
                                      },
                                      itemBuilder: (context) {
                                        return [
                                          const PopupMenuItem(
                                            child: Text("Edit"),
                                            value: "Edit",
                                          ),
                                          const PopupMenuItem(
                                            child: Text("Delete"),
                                            value: "Delete",
                                          ),
                                        ];
                                      },
                                    ),


                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                    ),
          ),
        ],
      ),
    );
  }
}
