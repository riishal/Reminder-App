import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/view/home_task.dart';

import '../common/show_task_model.dart';
import '../provider/add_task_provider.dart';
import 'calendar_task.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late AddTaskProvider addTaskProvider;
  int _currentIndex = 0;
  bool _isLoading = true;
  @override
  void initState() {
    addTaskProvider = Provider.of<AddTaskProvider>(context, listen: false);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 191, 224, 254),
        foregroundColor: Colors.blue.shade800,
        child: Icon(Icons.add),
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
