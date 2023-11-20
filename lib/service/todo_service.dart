import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/model/todo_model.dart';

class TodoService {
  final todoCollection = FirebaseFirestore.instance.collection("todoApp");

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getTasks(
      DateTime selectedDate) {
    var todos = todoCollection.get().then((value) {
      var date = value.docs.where((element) {
        var date = element['dateTask'].split('/').toList();
        var dateExp = '${date[1]}/${date[0]}/${date[2]}';
        var today =
            '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}';
        print('////////////// date $dateExp: today $today');
        return dateExp == today;
      });
      return date;
    });
    return todos.then((value) => value.toList());
  }

  void addNewTask(TodoModel todoModel) {
    todoCollection.add(todoModel.toMap());
  }

  void updateAllTask(TodoModel todoModel, String docId) {
    todoCollection.doc(docId).update(todoModel.toMap());
  }

  void updateTask(
    String? docId,
    bool? value,
  ) {
    todoCollection.doc(docId).update({"isDone": value});
  }

  void updateTaskState1(
    String? docId,
    String taskState,
  ) {
    todoCollection.doc(docId).update({"taskState": taskState});
  }

  void deleteTask(String docId) {
    todoCollection.doc(docId).delete();
  }
}
