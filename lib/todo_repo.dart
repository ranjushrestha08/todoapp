import 'dart:convert';
import 'package:http/http.dart' as http;

import 'todo_model.dart';

class TodoRepository {
  Future<void> addTodo(String task) async {
    await http.post(
      Uri.parse('https://dummyjson.com/todos/add'),
      body: jsonEncode({'title': task}),
      headers: {'Content-Type': 'application/json'},
    );
  }

  Future<void> editTodo(int id, String newTask) async {
    await http.put(
      Uri.parse('https://dummyjson.com/todos/$id'),
      body: jsonEncode({'title': newTask}),
      headers: {'Content-Type': 'application/json'},
    );
  }

  Future<void> deleteTodo(int id) async {
    await http.delete(Uri.parse('https://dummyjson.com/todos/$id'));
  }

  Future<void> getTodos() async {
    await http.get(
      Uri.parse("https://dummyjson.com/todos/user/5"),
    );
  }

  Future<void> sendDataToAPI(TodoModel data) async {
    final url = Uri.parse("https://dummyjson.com/todos/user/5");
    final response = await http.post(url, body: jsonEncode(data.toJson()));
    if (response.statusCode == 200) {
      print('sent to API: ${response.body}');
    } else {
      print('Response body: ${response.body}');
    }
  }
}
