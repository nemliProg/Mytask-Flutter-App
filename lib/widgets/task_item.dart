import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_app/models/task_model.dart';


class TaskItem extends StatelessWidget {
  final Task task;

  const TaskItem({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        onTap: () => {
          updateTask()
        },
        shape: RoundedRectangleBorder(
          side: (task.important == "normal")
              ? const BorderSide(color: Color.fromARGB(255, 255, 255, 255), width: 1)
               :(task.important == "medium")
                  ? const BorderSide(color: Color.fromARGB(255, 255, 191, 96), width: 1)
                  : const BorderSide(color: Color.fromARGB(255, 255, 109, 98), width: 1),
          borderRadius: BorderRadius.circular(20),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        tileColor: Colors.white,
        leading: Icon(
          task.done ? Icons.check_box : Icons.check_box_outline_blank,
          color: Colors.purple,
        ),
        title: Text(
          task.task,
          style: TextStyle(
              fontSize: 16,
              color: Colors.purple,
              decoration: task.done ? TextDecoration.lineThrough : null
        ),
        ),
        trailing: Container(
          padding: const EdgeInsets.all(0),
          margin: const EdgeInsets.symmetric(vertical: 12),
          height: 30,
          width: 30,
          decoration: BoxDecoration(
              color: Colors.red[400], borderRadius: BorderRadius.circular(5)),
          child: IconButton(
            color: Colors.white,
            iconSize: 16,
            icon: const Icon(Icons.delete),
            onPressed: () => {
              deleteTask()
            },
          ),
        ),
      ),
    );
  }

  Future updateTask() async {

    try {
      // refernce to document
      final docUser = FirebaseFirestore.instance.collection("/tasks").doc(task.id);

      await docUser.update({
        'done': !task.done
      });

    } catch (e) {
      print("Error updating task: $e");
    }
    
  }

  Future deleteTask() async {

    try {
      // refernce to document
      final docUser = FirebaseFirestore.instance.collection("/tasks").doc(task.id);

      await docUser.delete();
    } catch (e) {
      print("Error deleting task: $e");
    }
    
  }


}
