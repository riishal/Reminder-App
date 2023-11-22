import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/constants/app_style.dart';
import 'package:todo_app/provider/add_task_provider.dart';

class DateTimeWidget extends StatelessWidget {
  const DateTimeWidget({
    super.key,
    required this.titleText,
    required this.valueText,
    required this.iconSelection,
    required this.onTap,
  });
  final String titleText;
  final String valueText;
  final IconData iconSelection;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Consumer<AddTaskProvider>(builder: (context, getdata, child) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          titleText,
          style: AppStyle.headingOne,
        ),
        const SizedBox(
          height: 6,
        ),
        Material(
          child: Ink(
            decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10)),
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () => onTap(),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.transparent),
                child: Row(children: [
                  Icon(iconSelection),
                  const SizedBox(
                    width: 12,
                  ),
                  Text(valueText)
                ]),
              ),
            ),
          ),
        )
      ]);
    });
  }
}
