import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:todo_api_test/screens/add_page.dart';
import 'package:http/http.dart' as http;

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  @override
  void initState() {
    fetchTodo();
    super.initState();
  }

  bool isLoading = true;
  List items = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: const Text('Todo List APP'),
        ),
        body: Visibility(
          visible: isLoading,
          replacement: RefreshIndicator(
            onRefresh: fetchTodo,
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index] as Map;
                final id = item['_id'] as String;
                return ListTile(
                  leading: CircleAvatar(child: Text('${index + 1}')),
                  title: Text(item['title']),
                  subtitle: Text(item['description']),
                  trailing: PopupMenuButton(onSelected: (value) {
                    if (value == 'Edit') {
                      navigateToEditTodoPage(item);
                    }
                    if (value == 'Delete') {
                      deleteById(id);
                    }
                  }, itemBuilder: (context) {
                    return [
                      const PopupMenuItem(
                        value: 'Edit',
                        child: Text('Edit'),
                      ),
                      const PopupMenuItem(
                        value: 'Delete',
                        child: Text('Delete'),
                      ),
                    ];
                  }),
                );
              },
            ),
          ),
          child: const Center(child: CircularProgressIndicator()),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: navigateTOAddTodoPage,
          label: const Text('Add Todo'),
        ));
  }

  Future<void> navigateToEditTodoPage(Map item) async {
    final route = MaterialPageRoute(
      builder: (context) => AddTodoPage(todo: item),
    );
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchTodo();
  }

  Future<void> navigateTOAddTodoPage() async {
    final route = MaterialPageRoute(
      builder: (context) => const AddTodoPage(),
    );
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchTodo();
  }

  Future<void> deleteById(id) async {
    final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final response = await http.delete(uri);

    if (response.statusCode == 200) {
      final filtered = items.where((element) => element['_id'] != id).toList();
      setState(() {
        items = filtered;
      });
    } else {
      showErrorMassage('Eleltion Failed');
    }
  }

  Future<void> fetchTodo() async {
    // ignore: prefer_const_declarations
    final url = 'https://api.nstack.in/v1/todos?page=1&limit=10';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;
      final result = json['items'] as List;
      setState(() {
        items = result;
      });
    } else {
      //show Error
    }

    setState(() {
      isLoading = false;
    });
  }

  void showErrorMassage(String message) {
    final snackbar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: const Color.fromARGB(255, 194, 0, 0),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
}
