import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_app/model/todo_model.dart';

class TodoService {
  final todoCollection = FirebaseFirestore.instance.collection("todoApp");

  void addNewTask(TodoModel todoModel) {
    todoCollection.add(todoModel.toMap());
  }

  void updateAllTask(TodoModel todoModel, String docId) {
    todoCollection.doc(docId).update(todoModel.toMap());
  }

  void updateTask(String? docId, bool? value) {
    todoCollection.doc(docId).update({"isDone": value});
  }

  void deleteTask(String docId) {
    todoCollection.doc(docId).delete();
  }
}
