import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DetailsScreen extends StatelessWidget {
  Future<Map<String, dynamic>> fetchData() async {
    final response =
        await http.get(Uri.parse('https://dummyjson.com/todos/random'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Todo Details"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          FutureBuilder(
              future: fetchData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final todoDetails = snapshot.data;

                  return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('ID: ${todoDetails?['id']}'),
                          Text('Todo: ${todoDetails?['todo']}'),
                          Text(
                              'Completed: ${todoDetails?['completed'] ? 'Yes' : 'No'}'),
                          Text('User ID: ${todoDetails?['userId']}'),
                        ],
                      ));
                }
              })
        ],
      ),
    );
  }
}
