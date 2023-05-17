import 'dart:convert';

import 'package:http/http.dart' as htttp;
import 'package:flutter/material.dart';

class AddTodoPage extends StatefulWidget {
  final Map? todo;
  const AddTodoPage({super.key, this.todo});

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  TextEditingController titleControlelr = TextEditingController();
  TextEditingController descriptionControlelr = TextEditingController();

  bool isEdit = false;

  @override
  void initState() {
   
    super.initState();
    final todo = widget.todo;
    if (todo != null) {
      isEdit = !isEdit;
      final title = todo['title'];
      final description = todo['description'];
      titleControlelr.text = title;
      descriptionControlelr.text = description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          isEdit ? 'Edit Todo' : 'Add Todo',
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: titleControlelr,
                  decoration: const InputDecoration(hintText: 'Title'),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: descriptionControlelr,
                  decoration: const InputDecoration(hintText: 'Description'),
                  keyboardType: TextInputType.multiline,
                  minLines: 5,
                  maxLines: 8,
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: isEdit ? upateDate : submitData,
                  child: SizedBox(
                    width: double.infinity,
                    child: Center(child: Text(isEdit ? 'Update' : 'Submit')),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<void> upateDate() async {
    final todo = widget.todo;
    if (todo == null) {
      print('you cannot call the update method For this todo');
      return;
    }

    final id = todo['_id'];

    final title = titleControlelr.text;
    final description = descriptionControlelr.text;

    final body = {
      'title': title,
      'description': description,
      'is_completed': false.toString(),
    };
// ignore: prefer_const_declarations
    final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);

    final response = await htttp.put(uri,
        body: jsonEncode(body), headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      showSuccessMassage('Updation Success');
    } else {
      showErrorMassage('Updation failed');
    }
  }

  Future<void> submitData() async {
    // Get the data from the form
    final title = titleControlelr.text;
    final description = descriptionControlelr.text;

    final body = {
      'title': title,
      'description': description,
      'is_completed': false.toString(),
    };

    // ignore: prefer_const_declarations
    final url = 'https://api.nstack.in/v1/todos';
    final uri = Uri.parse(url);

    final response = await htttp.post(uri,
        body: jsonEncode(body), headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 201) {
      titleControlelr.text = '';
      descriptionControlelr.text = '';
      showSuccessMassage('Creation Success');
    } else {
      showErrorMassage('Creation failed');
    }
  }

  void showSuccessMassage(String message) {
    final snackbar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: const Color.fromARGB(255, 35, 192, 41),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
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
