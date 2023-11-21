import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';
import 'package:todo_app/constants/alert_message.dart';
import 'package:todo_app/provider/add_task_provider.dart';
import 'package:todo_app/widgets/day_widget.dart';

class CardTodoListWidget extends StatefulWidget {
  const CardTodoListWidget({
    super.key,
    required this.data,
  });
  final QueryDocumentSnapshot<Map<String, dynamic>> data;

  @override
  State<CardTodoListWidget> createState() => _CardTodoListWidgetState();
}

class _CardTodoListWidgetState extends State<CardTodoListWidget> {
  @override
  void initState() {
    final providerDatas = Provider.of<AddTaskProvider>(context, listen: false);

    providerDatas.chckConditions(
        widget.data["timeTask"], widget.data["timeTask"]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final format = DateFormat.yMd();

    Color categoryColor = Colors.black;

    final category = widget.data["category"];
    switch (category) {
      case "Learn":
        categoryColor = Colors.green;

        break;
      case "Work":
        categoryColor = Colors.blue.shade200;
        break;
      case "Genarel":
        categoryColor = Colors.amber.shade500;
        break;
    }

    return Consumer<AddTaskProvider>(builder: (context, getdata, child) {
      return SizedBox(
        height: 125,
        width: double.infinity,
        // decoration: BoxDecoration(
        //     color: Colors.white, borderRadius: BorderRadius.circular(12)),
        child: Row(children: [
          Container(
            width: 20,
            decoration: BoxDecoration(
                color: categoryColor,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12))),
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ListTile(
                    leading: widget.data["isDone"]
                        ? IconButton(
                            onPressed: () {
                              AlertMessage.showComplete(
                                widget: SizedBox(),
                                title: "Delete Task",
                                content: "Are sure want to delete your task?",
                                context: context,
                                onTap: () {
                                  getdata.deleteTask(widget.data.id);
                                  Navigator.pop(context);
                                  getdata.showToast(
                                      "${widget.data["titleTask"]} Task has Deleted",
                                      Colors.red);

                                  Navigator.pop(context);
                                },
                                onCancel: () async {
                                  Navigator.pop(context);
                                },
                              );
                            },
                            icon: widget.data["taskState"] == "finished"
                                ? const Icon(
                                    CupertinoIcons.delete,
                                    color: Colors.red,
                                  )
                                : SizedBox())
                        : null,
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      widget.data["titleTask"],
                      maxLines: 1,
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          decoration: widget.data["isDone"]
                              ? TextDecoration.lineThrough
                              : null),
                    ),
                    subtitle: Text(
                      widget.data["description"],
                      maxLines: 1,
                      style: TextStyle(
                          decoration: widget.data["isDone"]
                              ? TextDecoration.lineThrough
                              : null),
                    ),
                    trailing: Transform.scale(
                      scale: 1.5,
                      child: Checkbox(
                          activeColor: widget.data["taskState"] == "finished"
                              ? Colors.red
                              : Colors.green,
                          shape: const CircleBorder(),
                          value: widget.data["isDone"],
                          onChanged: (value) async {
                            getdata.updateTask(widget.data.id, value!);
                            widget.data["taskState"] == "upcoming"
                                ? AlertMessage.showComplete(
                                    widget: CircleAvatar(
                                      radius: 13,
                                      backgroundColor: Colors.green.shade500,
                                      child: Icon(
                                        Icons.done,
                                        size: 13,
                                        color: Colors.white,
                                      ),
                                    ),
                                    title: "Completed Task",
                                    content:
                                        "Are sure want to Complete\nyour task?",
                                    context: context,
                                    onTap: () {
                                      getdata.updateTimeDateState(
                                          widget.data["dateTask"],
                                          widget.data["timeTask"],
                                          widget.data.id);
                                      Navigator.pop(context);
                                    },
                                    onCancel: () async {
                                      Navigator.pop(context);
                                    },
                                  )
                                : null;
                            // .todoCollection
                            // .doc(data.id)
                            // .update({"isDone": value});

                            // print('clicked');
                          }),
                    ),
                  ),
                  Transform.translate(
                    offset: const Offset(0, -12),
                    child: Column(children: [
                      Divider(
                        color: Colors.grey.shade200,
                        thickness: 1.5,
                      ),
                      widget.data["dateTask"] == format.format(DateTime.now())
                          ? const DayWidget(day: "Today", color: Colors.blue)
                          : widget.data["dateTask"] ==
                                  format.format(DateTime.now()
                                      .add(const Duration(days: 1)))
                              ? const DayWidget(
                                  day: "Tomorrow", color: Colors.blue)
                              : widget.data["dateTask"] ==
                                      format.format(DateTime.now()
                                          .add(const Duration(days: -1)))
                                  ? const DayWidget(
                                      day: "Yesterday", color: Colors.blue)
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Date :",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500),
                                        ),
                                        const SizedBox(
                                          width: 4,
                                        ),
                                        Expanded(
                                          child: Text(
                                            widget.data["dateTask"],
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                        Text(
                                          widget.data["category"],
                                          style: TextStyle(
                                              color: categoryColor,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                      const SizedBox(
                        height: 2,
                      ),
                      Row(
                        children: [
                          const Text(
                            "Time :",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Expanded(
                            child: Text(
                              widget.data["timeTask"],
                              style:
                                  const TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ),
                          widget.data["taskState"] == "finished"
                              ? Text(
                                  widget.data["isDone"]
                                      ? "Delete !"
                                      : 'Completed',
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold),
                                )
                              : SizedBox()
                        ],
                      ),
                    ]),
                  )
                ]),
          ))
        ]),
      );
    });
  }
}
