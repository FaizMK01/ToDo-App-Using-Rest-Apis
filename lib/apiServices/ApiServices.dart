import 'dart:convert';
import 'dart:ui';
import 'package:todo_app_using_rest_apis/models/postMode.dart';
import 'package:http/http.dart' as http;
import 'package:todo_app_using_rest_apis/models/todos.dart';
import 'package:todo_app_using_rest_apis/views/add_todo.dart';

class ApiServices{
  
  //PostToDo

  Future<PostModel?> postTodo(String title, String description) async {
    try {
      var url = Uri.parse("https://api.nstack.in/v1/todos");
      final response = await http.post(
        url,
        body: jsonEncode({
          "title": title,
          "description": description,
          "is_completed": false
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 201) {
        var data = jsonDecode(response.body);
        PostModel model = PostModel.fromJson(data);
        return model;
      }
    } catch (e) {
      print(e.toString());
    }

    return null;
  }

  //addTodo

  Future<Todos?> addTodo() async{

    try{

      var url = Uri.parse("https://api.nstack.in/v1/todos?page=1&limit=20");
      final response = await http.get(url);

      if(response.statusCode==200){

        var data = jsonDecode(response.body);

        Todos model = Todos.fromJson(data);
        return model;

      }

    }catch(e){
      print(e.toString());
    }

    return null;
  }

  //delete


  // Function to delete a todo
  Future<void> deleteTodo(String id) async {
    final url = Uri.parse('https://api.nstack.in/v1/todos/$id');
    final response = await http.delete(url);

    if (response.statusCode == 200) {

      print("Todo deleted successfully");
    } else {
      throw Exception('Failed to delete todo');
    }
  }

  // Update Edit functionality
  Future<void> updateTodo(String id, String title, String description) async {
    try {
      var url = Uri.parse("https://api.nstack.in/v1/todos/$id"); // Assuming this is the correct endpoint
      final response = await http.put(
        url,
        body: jsonEncode({
          "title": title,
          "description": description,
          "is_completed": false // Adjust as necessary
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        print("Todo updated successfully");
      } else {
        throw Exception("Failed to update todo");
      }
    } catch (e) {
      print(e.toString());
    }
  }



  

}