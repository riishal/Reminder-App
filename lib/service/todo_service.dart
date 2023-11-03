import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_app/model/todo_model.dart';

class TodoService {
  final todoCollection = FirebaseFirestore.instance.collection("todoApp");

  void addNewTask(TodoModel todoModel) {
    todoCollection.add(todoModel.toMap());
  }

  void updateTask(String? docId, bool? valueUpdate) {
    print(docId);
    print(valueUpdate);
    todoCollection.doc(docId).update({"isDone": valueUpdate});
  }

  void delectTask(String docId) {
    todoCollection.doc(docId).delete();
  }
}
