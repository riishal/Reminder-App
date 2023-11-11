import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/core/constents.dart';

class TaskHomeProvider extends ChangeNotifier {
  int selectedIndex = 0;
  bool switchState = false;
  final format = DateFormat.yMd();
  List taskList = [];
  String changeTaskState(String taskState) {
    switchState = false;
    if (taskState == 'upcoming') return 'finished';
    if (taskState == 'finished') return 'upcoming';
    return '';
  }

  checkTaskConditions(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> snapshots,
    TaskState taskState,
  ) {
    if (taskState == TaskState.upcoming) {
      taskList = snapshots.where((element) {
        String date = element['dateTask'];
        String time = element['timeTask'];
        List dateList = date.split('/').toList(); // [11, 11, 2023]
        String newFormat = DateFormat("HH:mm")
            .format(DateFormat("hh:mma").parse(time.split(" ").join()));

        List timeList = newFormat.split(':').toList(); // [11, 30]
        DateTime newDate = DateTime(
            int.parse(dateList[2]),
            int.parse(dateList[1]),
            int.parse(dateList[0]),
            int.parse(timeList[0]),
            int.parse(timeList[1]));

        return newDate.isAfter(DateTime.now());
      }).toList();
      print('///////////////// upcoming tasks: ${taskList.length}');
    } else if (taskState == TaskState.finished) {
      taskList = snapshots.where((element) {
        String date = element['dateTask'];
        String time = element['timeTask'];
        List dateList = date.split('/').toList(); // [11, 11, 2023]
        String newFormat = DateFormat("HH:mm")
            .format(DateFormat("hh:mma").parse(time.split(" ").join()));

        List timeList = newFormat.split(':').toList(); // [11, 30]
        DateTime newDate = DateTime(
            int.parse(dateList[2]),
            int.parse(dateList[1]),
            int.parse(dateList[0]),
            int.parse(timeList[0]),
            int.parse(timeList[1]));

        return newDate.isBefore(DateTime.now());
      }).toList();
      print('///////////////// finished: ${taskList.length}');
    }
  }
}
