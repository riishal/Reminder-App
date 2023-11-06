import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:provider/provider.dart';
import 'package:todo_app/provider/provider.dart';

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
    final providerDatas = Provider.of<Providerdata>(context, listen: false);
    // chckConditions(widget.data["timeTask"]);
    providerDatas.chckConditions(
        widget.data["timeTask"], widget.data["timeTask"]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
        categoryColor = Colors.amber.shade200;
        break;
    }

    return Consumer<Providerdata>(builder: (context, getdata, child) {
      return SizedBox(
        height: 120,
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
                              getdata.deleteTask(widget.data.id);
                              Fluttertoast.showToast(
                                msg: "${widget.data["titleTask"]} Deleted",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.black45,
                                textColor: Colors.white,
                              );
                            },
                            icon: const Icon(
                              CupertinoIcons.delete,
                              color: Colors.red,
                            ))
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
                          activeColor: Colors.blue.shade800,
                          shape: const CircleBorder(),
                          value: widget.data["isDone"],
                          onChanged: (value) async {
                            getdata.updateTask(widget.data.id, value!);
                            // .todoCollection
                            // .doc(data.id)
                            // .update({"isDone": value});

                            print('clicked');
                          }),
                    ),
                  ),
                  Transform.translate(
                    offset: const Offset(0, -12),
                    child: Container(
                      child: Column(children: [
                        Divider(
                          color: Colors.grey.shade200,
                          thickness: 1.5,
                        ),
                        Row(
                          children: [
                            const Text("Today"),
                            const SizedBox(
                              width: 12,
                            ),
                            Text(widget.data["timeTask"]),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              widget.data["category"],
                              style: TextStyle(
                                  color: categoryColor,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        )
                      ]),
                    ),
                  )
                ]),
          ))
        ]),
      );
    });
  }
}
