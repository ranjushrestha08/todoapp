import 'package:todoapp/todo_repo.dart';

class TodoController {
  final TodoRepository _repository = TodoRepository();

  Future<void> addTodo(String task) async {
    await _repository.addTodo(task);
  }

  Future<void> editTodo(int id, String newTask) async {
    await _repository.editTodo(id, newTask);
  }

  Future<void> deleteTodo(int id) async {
 

    await _repository.deleteTodo(id);
  }
}
