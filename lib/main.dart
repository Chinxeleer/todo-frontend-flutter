import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:todo_app/services/model.dart';

void main() {
  runApp(const MyApp());
}

const url = "http://10.0.2.2:8000/todo/todolist/";
List todos = [];

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Todo>> todos;
  @override
  void initState() {
    super.initState();
    todos = getTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          FutureBuilder(
            future: todos,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  if (snapshot.hasData) {
                    final todoList = snapshot.data!.toList();
                    return Expanded(
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: todoList.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: ListTile(
                              tileColor: Colors.white10,
                              leading: const Icon(Icons.book),
                              contentPadding: const EdgeInsets.all(8),
                              subtitle: Text(
                                  "${todoList[index].description.substring(1, 50)}..."),
                              title: Text(todoList[index].title),
                              trailing: const Icon(Icons.delete),
                            ),
                          );
                        },
                      ),
                    );
                  } else {
                    return const Text("No Todo's yet");
                  }

                default:
                  return const CircularProgressIndicator();
              }
            },
          ),
        ],
      ),
    );
  }
}

Future<List<Todo>> getTodos() async {
  final todoResponse = await http.get(Uri.parse(url));
  if (todoResponse.statusCode == 200) {
    List<dynamic> todoDecode = jsonDecode(todoResponse.body);
    List<Todo> todos =
        List<Todo>.from(todoDecode.map<Todo>((dynamic i) => Todo.fromJson(i)));
    return todos;
  } else {
    throw Exception("Failed to Load Todos");
  }
}
