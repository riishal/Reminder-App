import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/view/home_task.dart';

import '../common/show_task_model.dart';
import '../provider/add_task_provider.dart';
import 'calendar_task.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late AddTaskProvider addTaskProvider;
  int _currentIndex = 0;
  @override
  void initState() {
    addTaskProvider = Provider.of<AddTaskProvider>(context, listen: false);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        label: const Text("Task"),
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        onPressed: () {
          showModalBottomSheet(
            isScrollControlled: true,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            context: context,
            builder: (context) => AddNewTask(
              size: size,
            ),
          );
        },
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          HomeTask(),
          CalendarTask(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 10,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blue.shade800,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;

            if (_currentIndex == 0) {
              addTaskProvider.dateValue = "dd/MM/yyyy";
            } else {}
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendar',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.view_list),
          //   label: 'View',
          // ),
        ],
      ),
    );
  }
}
