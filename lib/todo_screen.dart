import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/detail_screen.dart';
import 'package:todoapp/todo_controller.dart';
import 'package:todoapp/utils/colors.dart';
import 'todo_model.dart';
import 'package:http/http.dart' as http;

class ToDoListScreen extends StatefulWidget {
  @override
  State<ToDoListScreen> createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoListScreen> {
  final TodoController controller = TodoController();
  final List<TodoModel> todos = [];
  TextEditingController editingController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadTodos();
  }

  Future<void> loadTodos() async {
    try {
      setState(() {
        isLoading = true;
      });
      http.Response response =
          await http.get(Uri.parse("https://dummyjson.com/todos/user/5"));
      var data = json.decode(response.body);
      for (var todoJson in data["todos"]) {
        var todo = TodoModel.fromJson(todoJson);
        setState(() {
          todos.add(todo);
        });
      }
    } catch (e) {
      print(e.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> addTodo(String newTodoTitle) async {
    try {
      setState(() {
        isLoading = true;
      });
      final response = await http.post(
        Uri.parse("https://dummyjson.com/todos/add"),
        body: jsonEncode({"todo": newTodoTitle, "userId": 5}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        var newTodoJson = json.decode(response.body);
        var newTodo = TodoModel.fromJson(newTodoJson);
        setState(() {
          todos.add(newTodo);
        });
      } else {
        print('Failed to add todo. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print(e.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> editTodo(int index, String updatedTodoTitle) async {
    try {
      setState(() {
        isLoading = true;
      });
      final response = await http.put(
        Uri.parse("https://dummyjson.com/todos/1"),
        body: jsonEncode({"todo": updatedTodoTitle, "userId": 1}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        var updatedTodoJson = json.decode(response.body);
        var updatedTodo = TodoModel.fromJson(updatedTodoJson);
        setState(() {
          todos[index] = updatedTodo;
        });
      } else {
        print('Failed to edit todo. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print(e.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> deleteTodo(int index) async {
    try {
      setState(() {
        isLoading = true;
      });

      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        todos.removeAt(index);
      });
    } catch (e) {
      print(e.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "To do list",
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Column(
        children: [
          if (isLoading)
            const LinearProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
            ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: todos.length,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 20, top: 20, right: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () async {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return DetailsScreen();
                                }));
                              },
                              child: ListTile(
                                title: Text(todos[index].todo ?? ""),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15, right: 15),
                            child: InkWell(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      String currentTitle =
                                          todos[index].todo ?? "";
                                      editingController.text = currentTitle;
                                      return AlertDialog(
                                        title: const Text('Edit'),
                                        content: SizedBox(
                                          height: 40,
                                          child: TextFormField(
                                            controller: editingController,
                                            decoration: const InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(5.0),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        actions: [
                                          Center(
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  backgroundColor:
                                                      AppColors.primaryColor),
                                              onPressed: () {
                                                // String updatedTodoTitle =
                                                //     editingController.text;
                                                // if (updatedTodoTitle.isNotEmpty) {
                                                //   editTodo(index, updatedTodoTitle);
                                                //   editingController.clear();
                                                //   Navigator.of(context).pop();
                                                // }
                                                // setState(() {
                                                //   todos[index].todo =
                                                //       editingController.text;
                                                // });
                                                setState(() {
                                                  editTodo(index,
                                                      editingController.text);
                                                });
                                                editingController.clear();
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text(
                                                "Submit",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          )
                                        ],
                                      );
                                    });
                              },
                              child: Image.asset(
                                'assets/icons/edit.png',
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              showCupertinoModalPopup(
                                context: context,
                                builder: (BuildContext context) =>
                                    CupertinoAlertDialog(
                                  title: Text(
                                    'Do you really want to delete?',
                                    style: TextStyle(
                                        color: AppColors.primaryColor,
                                        fontSize: 18),
                                  ),
                                  content: const Text(
                                    'You cannot undo this action.',
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 16),
                                  ),
                                  actions: <CupertinoDialogAction>[
                                    CupertinoDialogAction(
                                      isDefaultAction: true,
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('No'),
                                    ),
                                    CupertinoDialogAction(
                                      isDestructiveAction: true,
                                      onPressed: () {
                                        setState(() {
                                          deleteTodo(index);
                                          // todos.removeAt(index);
                                        });
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Yes'),
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: Image.asset(
                              'assets/icons/delete.png',
                              color: AppColors.errorColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return SizedBox(
                  height: 250,
                  width: 350,
                  child: AlertDialog(
                    title: const Text('Add'),
                    content: SizedBox(
                      height: 40,
                      child: TextFormField(
                        controller: editingController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(5.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                    actions: [
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              backgroundColor: AppColors.primaryColor),
                          onPressed: () {
                            String newTodoTitle = editingController.text;
                            if (newTodoTitle.isNotEmpty) {
                              addTodo(
                                  newTodoTitle); // Call the addTodo method here
                              editingController.clear();
                              Navigator.of(context).pop();
                            }
                            // String newTodoTitle = editingController.text;
                            // if (newTodoTitle.isNotEmpty) {
                            //   setState(() {
                            //     todos.add(TodoModel(todo: newTodoTitle));
                            //   });
                            //   editingController.clear();
                            //   Navigator.of(context).pop();
                            // }
                          },
                          child: const Text(
                            "Submit",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              });
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        backgroundColor: const Color.fromARGB(235, 255, 255, 255),
        child: Icon(
          Icons.add,
          color: AppColors.primaryColor,
        ),
      ),
    );
  }
}
