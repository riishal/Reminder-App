// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';

class TodoModel {
  String? docId;
  final String titleTask;
  final String description;
  final String category;
  final String dateTask;
  final String timeTask;
  final bool isDone;
  String taskState;

  TodoModel({
    this.docId,
    required this.isDone,
    required this.titleTask,
    required this.description,
    required this.category,
    required this.dateTask,
    required this.timeTask,
    required this.taskState,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'titleTask': titleTask,
      'description': description,
      'category': category,
      'dateTask': dateTask,
      'timeTask': timeTask,
      'isDone': isDone,
      'taskState': taskState
    };
  }

  factory TodoModel.fromMap(Map<String, dynamic> map) {
    return TodoModel(
      taskState: map["taskState"] as String,
      docId: map["docId"] != null ? map["docId"] as String : null,
      titleTask: map['titleTask'] as String,
      description: map['description'] as String,
      category: map['category'] as String,
      dateTask: map['dateTask'] as String,
      timeTask: map['timeTask'] as String,
      isDone: map['isDone'] as bool,
    );
  }

  factory TodoModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) {
    return TodoModel(
        taskState: doc["taskState"],
        docId: doc.id,
        isDone: doc["isDone"],
        titleTask: doc["titleTask"],
        description: doc["description"],
        category: doc["category"],
        dateTask: doc["dateTask"],
        timeTask: doc["timeTask"]);
  }
}
