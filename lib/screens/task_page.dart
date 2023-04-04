import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_app/screens/add_task_page.dart';
import '../models/task_model.dart';
import '../widgets/task_item.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  TasksState createState() => TasksState();
}

class TasksState extends State<TaskPage> {
  // ignore: prefer_const_constructors
  Stream<List<Task>> _foundTasks = Stream.empty();

  @override
  void initState() {
    _foundTasks = readTasks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
          backgroundColor: Colors.grey[300],
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                iconSize: 30,
                icon: const Icon(Icons.add),
                color: Colors.black,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddTaskPage()),
                  );
                },
              ),
              SizedBox(
                height: 40,
                width: 40,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset('assets/images/avatar.jpg')),
              )
            ],
          )),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: TextField(
                onChanged: (value) {
                  _runFilter(value);
                },
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(0),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey,
                    size: 20,
                  ),
                  prefixIconConstraints: BoxConstraints(
                    maxHeight: 20,
                    maxWidth: 25,
                  ),
                  border: InputBorder.none,
                  hintText: 'Search',
                )),
          ),
          Expanded(
            child: StreamBuilder<List<Task>>(
                stream: _foundTasks,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text("Something went wrong", style: TextStyle(color: Colors.red, fontSize: 20, fontWeight: FontWeight.bold)),
                          Icon(Icons.error_outline)
                        ]);
                  } else if (snapshot.hasData) {
                    final tasks = snapshot.data!;

                    return ListView(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(
                            top: 50,
                            bottom: 20,
                          ),
                          child: const Text(
                            'All Tasks',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        ...tasks.map((t) => TaskItem(task: t)).toList()
                      ],
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                }),
          )
        ]),
      ),
      // body: _buildList(),
    );
  }

  Stream<List<Task>> readTasks() {
    return FirebaseFirestore.instance.collection("/tasks").snapshots().map(
        (snapshot) =>
            snapshot.docs.map((doc) => Task.fromJson(doc.data())).toList());
  }

  void _runFilter(String enteredKeyword) {
    Stream<List<Task>> results;
    if (enteredKeyword.isEmpty) {
      results = readTasks();
    } else {
      results = readTasks().map((snapshot) => snapshot
          .where((task) =>
              task.task.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList());
    }

    setState(() {
      _foundTasks = results;
    });
  }
}
