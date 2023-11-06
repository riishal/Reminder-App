import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/common/show_task_model.dart';
import 'package:todo_app/widgets/card_todo_widget.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      // appBar: AppBar(
      //   title: Text(
      //     "Todo App",
      //     style: TextStyle(color: Colors.black),
      //   ),
      //   backgroundColor: Colors.white,
      //   elevation: 0,
      // ),
      body: SafeArea(
        child: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 30,
          ),
          child: Column(children: [
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Today\'s Task',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      Text(
                        'Wednesday, 11 may',
                        style: TextStyle(color: Colors.grey),
                      )
                    ]),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD5E8FA),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        foregroundColor: Colors.blue.shade800),
                    onPressed: () {
                      showModalBottomSheet(
                        isScrollControlled: true,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25)),
                        context: context,
                        builder: (context) => AddNewTask(size: size),
                      );
                    },
                    child: const Text(
                      "+ New Task",
                      style: TextStyle(color: Colors.indigo),
                    ))
              ],
            ),
            SizedBox(
              height: 20,
            ),
            //task card list

            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('todoApp')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final documents = snapshot.data!.docs;

                  return Container(
                    height: 900,
                    child: ListView.separated(
                        itemBuilder: (context, index) {
                          QueryDocumentSnapshot<Map<String, dynamic>> data =
                              snapshot.data!.docs[index];
                          return Material(
                            color: Colors.transparent,
                            child: Ink(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12)),
                              child: InkWell(
                                  borderRadius: BorderRadius.circular(12),
                                  onTap: () {},
                                  child: CardTodoListWidget(data: data)),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => SizedBox(
                              height: 15,
                            ),
                        itemCount: documents.length),
                  );
                })
          ]),
        )),
      ),
    );
  }
}
