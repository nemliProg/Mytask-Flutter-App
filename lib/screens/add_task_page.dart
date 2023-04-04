import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/task_model.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  TasksState createState() => TasksState();
}

class TasksState extends State<AddTaskPage> {
  final _taskController = TextEditingController();
  String _value = "normal";

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
              const Text(
                'Add Task',
                style: TextStyle(fontSize: 20, color: Colors.black),
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
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: ListView(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20)),
                      child: TextField(
                          controller: _taskController,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.all(0),
                            prefixIcon: Icon(
                              Icons.task,
                              color: Colors.grey,
                              size: 20,
                            ),
                            prefixIconConstraints: BoxConstraints(
                              maxHeight: 20,
                              maxWidth: 25,
                            ),
                            border: InputBorder.none,
                            hintText: 'Write Your Task !!!',
                          )),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      margin: const EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20)),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Radio(
                                  value: "normal",
                                  groupValue: _value,
                                  onChanged: (value) => {
                                        setState(() => {_value = "normal"}),
                                      }),
                              const SizedBox(
                                width: 10.0,
                              ),
                              const Text("Normal",
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ))
                            ],
                          ),
                          Row(
                            children: [
                              Radio(
                                  value: "medium",
                                  groupValue: _value,
                                  onChanged: (value) => {
                                        setState(() => {_value = "medium"}),
                                      }),
                              const SizedBox(
                                width: 10.0,
                              ),
                              const Text("Medium",
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange,
                                  ))
                            ],
                          ),
                          Row(
                            children: [
                              Radio(
                                  value: "hard",
                                  groupValue: _value,
                                  onChanged: (value) => {
                                        setState(() => {_value = "hard"}),
                                      }),
                              const SizedBox(
                                width: 10.0,
                              ),
                              const Text("Hard",
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                  ))
                            ],
                          )
                        ],
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        backgroundColor: Colors.lightBlue[300],
                      ),
                      onPressed: () {
                        if (_taskController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.white,
                              content: Row(children: const [
                                Icon(
                                  Icons.error,
                                  color: Colors.red,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  "The Text Field is Empty!!",
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 20),
                                ),
                              ]),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        } else {
                          Task task = Task(
                              task: _taskController.text, important: _value);

                          createTask(task);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.white,
                              content: Row(children: const [
                                Icon(
                                  Icons.check,
                                  color: Colors.green,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  "Task Added Successfully!!",
                                  style: TextStyle(
                                      color: Colors.green, fontSize: 20),
                                ),
                              ]),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                          _taskController.clear();
                        }
                      },
                      child: const Text(
                        'Submit',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              )
            ],
          )),
    );
  }

  Future createTask(Task task) async {
    try {
      // refernce to document
      final docUser = FirebaseFirestore.instance.collection("tasks");

      DocumentReference docRef = await docUser.add(task.toJson());

      docUser.doc(docRef.id).update({"id": docRef.id});

      _taskController.clear();

    } catch (e) {
      print("Error creating task: $e");
    }
  }
}
