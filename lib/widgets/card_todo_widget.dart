import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/provider/provider.dart';

class CardTodoListWidget extends StatefulWidget {
  CardTodoListWidget({
    super.key,
    required this.data,
  });
  final QueryDocumentSnapshot<Map<String, dynamic>> data;

  @override
  State<CardTodoListWidget> createState() => _CardTodoListWidgetState();
}

class _CardTodoListWidgetState extends State<CardTodoListWidget> {
  var dataTodo;
  @override
  void initState() {
    dataTodo = Provider.of<Providerdata>(context, listen: false);
    ;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color categoryColor = Colors.white;
    final category = widget.data["category"];
    switch (category) {
      case "Learning":
        categoryColor = Colors.green;
        break;
      case "Working":
        categoryColor = Colors.blue.shade200;
        break;
      case "Genarel":
        categoryColor = Colors.amber.shade200;
        break;
    }

    return Consumer<Providerdata>(builder: (context, getdata, child) {
      return Container(
        margin: EdgeInsets.symmetric(vertical: 6),
        height: 120,
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(12)),
        child: Row(children: [
          GestureDetector(
            onTap: () {
              print('clicked');
              getdata.updateTask(widget.data["docId"], true);
            },
            child: Container(
              width: 20,
              decoration: BoxDecoration(
                  color: categoryColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      bottomLeft: Radius.circular(12))),
            ),
          ),
          Expanded(
              child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      widget.data["titleTask"],
                      maxLines: 1,
                    ),
                    subtitle: Text(
                      widget.data["description"],
                      maxLines: 1,
                    ),
                    trailing: Transform.scale(
                      scale: 1.5,
                      child: Checkbox(
                          activeColor: Colors.blue.shade800,
                          shape: CircleBorder(),
                          value: widget.data["isDone"],
                          onChanged: (value) async {
                            print('clicked');
                            // await getdata.addTask();
                            dataTodo.updateTask(widget.data["docId"], value!);
                          }),
                    ),
                  ),
                  Transform.translate(
                    offset: Offset(0, -12),
                    child: Container(
                      child: Column(children: [
                        Divider(
                          color: Colors.grey.shade200,
                          thickness: 1.5,
                        ),
                        Row(
                          children: [
                            Text("Today"),
                            SizedBox(
                              width: 12,
                            ),
                            Text(widget.data["timeTask"])
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
